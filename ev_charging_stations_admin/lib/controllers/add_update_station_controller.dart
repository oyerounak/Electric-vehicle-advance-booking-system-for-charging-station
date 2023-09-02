import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/stations.dart';
import '../screens/manage_stations/google_map_view_screen.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/route_constants.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/snack_bar_utils.dart';
import '../utils/services/api_service.dart';

class AddUpdateStationController extends GetxController {
  late TextEditingController etName;
  late TextEditingController etLocation;
  late TextEditingController etCity;
  late TextEditingController etLatLng;

  late FocusNode etNameFocusNode;
  late FocusNode etLocationFocusNode;
  late FocusNode etCityFocusNode;
  late FocusNode etLatLngFocusNode;

  RxBool isStationEnabled = false.obs;
  Rx<String> switchText = "Station Disabled".obs;

  late Stations? stationArg;
  late String? stationId;

  @override
  void onInit() {
    super.onInit();
    initUI();
    initObj();
  }

  void initUI() {
    etName = TextEditingController();
    etLocation = TextEditingController();
    etCity = TextEditingController();
    etLatLng = TextEditingController();

    etNameFocusNode = FocusNode();
    etLocationFocusNode = FocusNode();
    etCityFocusNode = FocusNode();
    etLatLngFocusNode = FocusNode();
  }

  void initObj() {
    stationArg = Get.arguments;
    stationId = stationArg?.stationId;
    _setStationToFields();
  }

  void toggleSwitch(bool value) {
    isStationEnabled.value = value;
    if (value == false) {
      switchText.value = 'Station Disabled';
    } else {
      switchText.value = 'Station Enabled';
    }
  }

  Future<void> onTapLatLngField() async {
    LatLng result = await Get.toNamed(RouteConstants.googleMapViewScreen);
    if (result.latitude != 0.0) {
      etLatLng.text =
          result.latitude.toString() + "," + result.longitude.toString();
    }
  }

  void onPressSubmit({required GlobalKey<FormState> formKey}) async {
    await CommonHelper.getInternetStatus().then(
      (connection) async {
        if (connection) {
          if (stationArg == null) {
            _createStation(formKey: formKey);
          } else {
            _updateStation(formKey: formKey);
          }
        }
      },
    );
  }

  void onPressViewSlots() {
    Get.toNamed(
      RouteConstants.manageSlots,
      arguments: stationId,
    );
  }

  Future<Stations> createStationObject() async {
    Stations stations = Stations();
    try {
      bool stationEnabled = isStationEnabled.value;

      stations.stationName = etName.text;
      stations.location = etLocation.text;
      stations.city = etCity.text;
      stations.latLng = etLatLng.text;
      if (stationEnabled) {
        stations.status = "Enable";
      } else {
        stations.status = "Disable";
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return stations;
  }

  void _setStationToFields() {
    try {
      if (stationArg != null) {
        etName.text = stationArg!.stationName!;
        etLocation.text = stationArg!.location!;
        etCity.text = stationArg!.city!;
        etLatLng.text = stationArg!.latLng!;
        stationId = stationArg!.stationId!;
        if (stationArg!.status! == "Enable") {
          toggleSwitch(true);
        } else {
          toggleSwitch(false);
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  Future<void> _createStation({
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      Stations stations = await createStationObject();
      var jsonResponse = await ApiService.postGetStatus(
        ApiConstants.addStation,
        body: stations,
      );
      if (jsonResponse.isNotEmpty) {
        if (jsonResponse.contains("true")) {
          Get.back();
          SnackBarUtils.normalSnackBar(
            title: "Success",
            message: 'Station added successfully',
          );
        } else if (jsonResponse.contains("already")) {
          SnackBarUtils.normalSnackBar(
            title: "Failed!",
            message: 'Station already exist.  Please try again',
          );
        } else if (jsonResponse.contains("false") ||
            jsonResponse.contains("no")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Failed to add station. Please try again later',
          );
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
      SnackBarUtils.errorSnackBar(
        title: "Failed!",
        message: 'Failed to add station. Please try again later',
      );
    }
  }

  Future<void> _updateStation({
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      Stations stations = await createStationObject();
      stations.stationId = stationId;

      var jsonResponse = await ApiService.postGetStatus(
        ApiConstants.updateStation,
        body: stations,
      );
      if (jsonResponse.isNotEmpty) {
        if (jsonResponse.contains("true")) {
          Get.back();
          SnackBarUtils.normalSnackBar(
            title: "Success",
            message: 'Station updated successfully',
          );
        } else if (jsonResponse.contains("already")) {
          SnackBarUtils.normalSnackBar(
            title: "Failed!",
            message: 'Station already exist.  Please try again',
          );
        } else if (jsonResponse.contains("false") ||
            jsonResponse.contains("no")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Failed to update station. Please try again later',
          );
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
      SnackBarUtils.errorSnackBar(
        title: "Failed!",
        message: 'Failed to update station. Please try again later',
      );
    }
  }
}
