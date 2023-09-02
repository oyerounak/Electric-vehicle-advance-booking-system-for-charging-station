import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/roadmap/road_map.dart';
import '../models/roadmap/road_map_data.dart';
import '../models/roadmap/road_map_steps.dart';
import '../models/stations.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/string_constants.dart';
import '../utils/custom_widgets/common_progress.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/gps_utils.dart';
import '../utils/helpers/map_utils.dart';
import '../utils/helpers/poly_line_utils.dart';
import '../utils/helpers/search_view.dart';
import '../utils/services/api_service.dart';

class GoogleMapViewController extends GetxController {
  final Completer<GoogleMapController> _controller = Completer();
  Rx<bool> isBottomSheetVisible = false.obs;

  late TextEditingController etStartLocation, etDestination;
  late FocusNode etStartLocationFocusNode, etDestinationFocusNode;
  late GoogleMapController? googleMapController;
  late BitmapDescriptor stationIcon;

  LatLng emptyLocation = const LatLng(0.0, 0.0);
  RxList<Marker> markerList = <Marker>[].obs;
  RxList<LatLng> polylineCoordinatesList = <LatLng>[].obs;
  RxList<Polyline> polylineList = <Polyline>[].obs;

  Rx<LatLng> startLatLng = const LatLng(0.0, 0.0).obs;
  Rx<LatLng> destinationLatLng = const LatLng(0.0, 0.0).obs;

  void onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
    this.googleMapController = googleMapController;
  }

  void cameraZoomIn(LatLng latLng, double? zoomLength) {
    MapUtils.zoomInCamera(
      controller: googleMapController!,
      latLng: latLng,
      zoomLength: zoomLength,
    );
  }

  @override
  void onInit() {
    super.onInit();
    initUI();
    markUserCurrentLocation();
    variableListeners();
    setStationIcon();
  }

  void initUI() {
    etStartLocation = TextEditingController();
    etDestination = TextEditingController();
    etStartLocationFocusNode = FocusNode();
    etDestinationFocusNode = FocusNode();
  }

  Future<void> markUserCurrentLocation() async {
    try {
      startLatLng.value = await GpsUtils.getUserLocation() ?? emptyLocation;
      if (startLatLng.value != emptyLocation) {
        String? address = await MapUtils.getAddressFromLatLng(
          latLng: startLatLng.value,
        );
        etStartLocation.text = address ?? "";
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  void variableListeners() {
    startLatLng.listen((p0) {
      if (p0 != emptyLocation) {
        _placeMarkers();
      }
    });

    destinationLatLng.listen((p0) {
      if (p0 != emptyLocation) {
        Get.back();
        _placeMarkers();
      }
    });
  }

  Future<Uint8List?> getBytesFromAsset({
    required String path,
    required int width,
  }) async {
    try {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width,
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
    } catch (e) {
      CommonHelper.printDebugError(e);
      return null;
    }
  }

  Future<void> setStationIcon() async {
    final Uint8List? markerIcon = await getBytesFromAsset(
      path: StringConstants.chargingStation,
      width: 70,
    );
    if (markerIcon != null) {
      stationIcon = BitmapDescriptor.fromBytes(markerIcon);
    } else {
      BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(2, 2),
          devicePixelRatio: 3.0,
        ),
        StringConstants.chargingStation,
      ).then((onValue) {
        stationIcon = onValue;
      });
    }
  }

  void onTapActionWidget() {
    if (isBottomSheetVisible.value == true) {
      isBottomSheetVisible.value = false;
    } else {
      isBottomSheetVisible.value = true;
    }
  }

  void onTapGoogleMap(LatLng latLng) {
    // _addMarker("", latLng.toString(), latLng);
  }

  void onTapSearchLocation({
    required String searchType,
  }) {
    if (googleMapController != null) {
      showSearch(
        context: Get.context as BuildContext,
        delegate: SearchView(),
      ).then((value) => onSearched(value, searchType));
    }
  }

  void onSearched(value, String searchType) async {
    try {
      List<Location> locations = await locationFromAddress(value);
      var first = locations.first;
      LatLng latLng = LatLng(first.latitude, first.longitude);

      if (searchType.contains("Destination")) {
        etDestination.text = value;
        destinationLatLng.value = latLng;
      } else {
        etStartLocation.text = value;
        startLatLng.value = latLng;
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  void _placeMarkers() {
    CommonProgressBar.show();
    markerList.clear();
    polylineList.clear();
    if (googleMapController != null) {
      _addMarker(startLatLng.value, "Starting Point");
      _addMarker(destinationLatLng.value, "Destination");
      _zoomCameraAndAddPolyLine();
    }
    CommonProgressBar.hide();
  }

  void _addMarker(LatLng latLng, String title) {
    if (latLng != emptyLocation) {
      Marker? marker = MapUtils.addMarker(latLng: latLng, title: title);
      marker != null ? markerList.add(marker) : null;
    }
  }

  void _addStationMarker(LatLng latLng, Stations station) {
    if (latLng != emptyLocation) {
      Marker? marker = MapUtils.addMarker(
          latLng: latLng,
          title: station.stationName ?? "",
          snippet: station.city,
          bitmapDescriptor: stationIcon,
          onTapMarker: () {
            try {
              CommonHelper.printDebugError("TAPPED");
              MapUtils.openMap(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              );
            } catch (e) {
              CommonHelper.printDebugError(e);
            }
          });
      marker != null ? markerList.add(marker) : null;
    }
  }

  Future<void> _zoomCameraAndAddPolyLine() async {
    if (startLatLng.value != emptyLocation) {
      cameraZoomIn(startLatLng.value, null);
      if (destinationLatLng.value != emptyLocation) {
        polylineCoordinatesList.value = await PolyLineUtils.getRouteCoordinates(
          origin: startLatLng.value,
          destination: destinationLatLng.value,
        );

        if (polylineCoordinatesList.isNotEmpty) {
          Polyline? polyline = PolyLineUtils.addPolyLine(
            origin: startLatLng.value,
            polylineCoordinates: polylineCoordinatesList.value,
          );

          if (polyline != null) {
            polylineList.add(polyline);
            cameraZoomIn(startLatLng.value, 12.0);
            fetchRoadMap();
          }
        }
      }
    }
  }

  RoadMap createRoadMapObject() {
    String distance = PolyLineUtils.calculateDistance(
      polylineCoordinates: polylineCoordinatesList.value,
    ).toString();

    List<RoadMapSteps> roadMapStepsList = [];
    for (LatLng latLng in polylineCoordinatesList.value) {
      RoadMapSteps roadMapSteps = RoadMapSteps();
      roadMapSteps.latLng = GpsUtils.getStringFromLatLng(latLng: latLng);
      roadMapStepsList.add(roadMapSteps);
    }

    RoadMapData roadMapData = RoadMapData();
    roadMapData.steps = roadMapStepsList;

    RoadMap roadMap = RoadMap();
    roadMap.source = GpsUtils.getStringFromLatLng(latLng: startLatLng.value);
    roadMap.destination = GpsUtils.getStringFromLatLng(
      latLng: destinationLatLng.value,
    );
    roadMap.km = distance;
    roadMap.roadMapData = roadMapData;
    return roadMap;
  }

  Future<void> fetchRoadMap() async {
    try {
      CommonProgressBar.show();
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.roadMap,
        body: createRoadMapObject(),
      ) as List;

      List<Stations> stationList = jsonResponse.map((e) {
        return Stations.fromJson(e);
      }).toList();

      if (stationList.isNotEmpty) {
        for (Stations station in stationList) {
          List<String> stringLatLng = station.latLng.toString().split(",");
          double? latitude = double.tryParse(stringLatLng[0]);
          double? longitude = double.tryParse(stringLatLng[1]);
          LatLng latLng = LatLng(latitude!, longitude!);
          _addStationMarker(latLng, station);
        }
      }
      CommonHelper.printDebug(stationList);
    } catch (e) {
      CommonHelper.printDebugError(e);
    } finally {
      CommonProgressBar.hide();
    }
  }
}
