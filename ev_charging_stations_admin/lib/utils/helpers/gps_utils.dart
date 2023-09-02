import 'package:geolocator/geolocator.dart';
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
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return LatLng(currentPosition.latitude, currentPosition.longitude);
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return const LatLng(0.0, 0.0);
  }

  static String getStringFromLatLng({required LatLng latLng}) {
    double latitude = latLng.latitude;
    double longitude = latLng.longitude;
    return latitude.toString() + "," + longitude.toString();
  }

}
