import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/helpers/search_view.dart';
import '../utils/helpers/snack_bar_utils.dart';

class GoogleMapViewController extends GetxController {
  final Completer<GoogleMapController> _controller = Completer();
  late bool serviceEnabled;
  late LocationPermission permission;
  late TextEditingController etSearchLocation;
  late FocusNode etSearchLocationFocusNode;
  late GoogleMapController googleMapController;
  late LatLng? _latLng;

  List<Marker> markers = <Marker>[].obs;

  @override
  void onInit() {
    super.onInit();
    initUI();
  }

  void initUI() async {
    etSearchLocation = TextEditingController();
    etSearchLocationFocusNode = FocusNode();

    _latLng = await getUserLocation();
    if (_latLng != null) {
      _addMarker("", _latLng.toString(), _latLng!);
      googleMapController
          .animateCamera(CameraUpdate.newLatLngZoom(_latLng!, 20));
    }
  }

  void onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
    this.googleMapController = googleMapController;
  }

  void onTapGoogleMap(LatLng latLng) {
    _addMarker("", latLng.toString(), latLng);
  }

  void onTapSearchLocation(BuildContext context) {
    showSearch(
      context: context,
      delegate: SearchView(),
    ).then(
      (value) => {
        onSearched(value),
      },
    );
  }

  void onSearched(value) async {
    etSearchLocation.text = value;
    try {
      List<Location> locations = await locationFromAddress(value);
      var first = locations.first;
      LatLng latLng = LatLng(
        first.latitude,
        first.longitude,
      );
      _addMarker("", value, latLng);
    } catch (e) {
      e.printError();
    }
  }

  void onTapSubmit() {
    Get.back(result: _latLng);
  }

  Future<LatLng>? getUserLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SnackBarUtils.errorSnackBar(
          title: 'Failed to fetch current location !!!',
          message: 'Location Permission Denied',
        );
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      SnackBarUtils.errorSnackBar(
        title: 'Failed to fetch current location !!!',
        message: 'Location Permission Denied',
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  void _addMarker(String title, String markerId, LatLng latLng) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: latLng,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        infoWindow: InfoWindow(title: title),
      ),
    );

    _latLng = latLng;
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 20));
  }
}
