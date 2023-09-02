import 'package:ev_charging_stations_user/utils/custom_widgets/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'common_helper.dart';
import 'snack_bar_utils.dart';

class GpsUtils {
  static Future<bool> checkForLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SnackBarUtils.errorSnackBar(
          title: "Failed to fetch current location!!!",
          message: "Location Permission Denied",
        );
        serviceEnabled = false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      SnackBarUtils.errorSnackBar(
        title: "Failed to fetch current location!!!",
        message: "Location Permission Denied",
      );
      serviceEnabled = false;
    }

    return serviceEnabled;
  }

  static Future<LatLng>? getUserLocation() async {
    try {
      bool isPermission = await checkForLocationPermission();
      if (isPermission) {
        return getCurrentLocation();
      } else {
        Get.dialog(
          CommonDialog(
            title: 'Location Permission',
            contentWidget: const Text(
              "The application require location "
              "permission to get current location\n"
              "Enable and then refresh again to get current location",
            ),
            positiveDialogBtnText: 'Confirm',
            negativeRedDialogBtnText: 'Back',
            onPositiveButtonClicked: () async {
              Get.back();
              Geolocator.openAppSettings();
            },
          ),
        ).then((value) async {
          bool isPermission = await checkForLocationPermission();
          if (isPermission) {
            return await getCurrentLocation();
          }
        });
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return const LatLng(0.0, 0.0);
  }

  static Future<LatLng> getCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  static String getStringFromLatLng({required LatLng latLng}) {
    double latitude = latLng.latitude;
    double longitude = latLng.longitude;
    return "$latitude,$longitude";
  }
}
