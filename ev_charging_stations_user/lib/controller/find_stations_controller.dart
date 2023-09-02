import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/stations.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/route_constants.dart';
import '../utils/custom_widgets/common_progress.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/gps_utils.dart';
import '../utils/services/api_service.dart';

class FindStationsController extends GetxController {
  var filterBy = ''.obs;
  var isDataTableVisible = false.obs;
  var isFilterValueTextFieldVisible = false.obs;
  var isLoading = true.obs;
  var dataList = <Stations>[].obs;

  late TextEditingController etFilterValue;
  late FocusNode etFilterValueFocusNode;

  late bool serviceEnabled;
  late LocationPermission permission;

  @override
  void onInit() {
    super.onInit();
    initUI();
  }

  void initUI() {
    etFilterValue = TextEditingController();
    etFilterValueFocusNode = FocusNode();
  }

  void onChanged(String value) {
    filterBy.value = value;
    isDataTableVisible.value = false;
    etFilterValue.text = "";
    if (value == "City" || value == "Kilometer") {
      isFilterValueTextFieldVisible.value = true;
    } else {
      isFilterValueTextFieldVisible.value = false;
    }
  }

  void onTapStationCard({required Stations station}) {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }

    String? stationId = station.stationId;
    if (stationId != null) {
      Get.toNamed(
        RouteConstants.manageSlots,
        arguments: stationId,
      )?.then((value) {
        fetchStations();
      });
    }
  }

  void onButtonPressSubmit({required GlobalKey<FormState> formKey}) {
    etFilterValueFocusNode.unfocus();
    if (formKey.currentState!.validate()) {
      isDataTableVisible.value = true;
      Get.back();
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
    }
  }

  void onBottomSheetClose() {
    fetchStations();
  }

  String? dropDownValidation(String? value) {
    try {
      if (value == null) {
        return 'Cannot Be Empty';
      }
      if (value == "Select Filter") {
        return 'Cannot Be Empty';
      }
    } catch (e) {
      return 'Cannot Be Empty';
    }
    return null;
  }

  Future<Stations> createStationObject() async {
    Stations stations = Stations();
    if (filterBy.value == "Near by") {
      stations.type = "Nearby";
      stations.latLng = await getUserLocation();
    } else if (filterBy.value == "City") {
      stations.type = "City";
      stations.city = etFilterValue.text;
    } else if (filterBy.value == "Kilometer") {
      stations.type = "Kms";
      stations.kms = etFilterValue.text;
      stations.latLng = await getUserLocation();
    }

    return stations;
  }

  void fetchStations() async {
    try {
      isLoading(true);

      Stations stations = await createStationObject();
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewStation,
        body: stations,
      ) as List;
      dataList.value = jsonResponse.map((e) => Stations.fromJson(e)).toList();
    } finally {
      isLoading(false);
    }
  }

  Future<String> getUserLocation() async {
    try {
      CommonProgressBar.show();
      LatLng? userCurrentLatLng = await GpsUtils.getUserLocation();
      return GpsUtils.getStringFromLatLng(latLng: userCurrentLatLng!);
    } catch (e) {
      CommonHelper.printDebugError(e);
      return "0.0,0.0";
    } finally {
      CommonProgressBar.hide();
    }
  }
}
