import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/string_constants.dart';
import 'common_helper.dart';

class PolyLineUtils {
  static Future<List<LatLng>> getRouteCoordinates({
    required LatLng origin,
    required LatLng destination,
  }) async {
    List<LatLng> polyLineCoordinates = [];
    final client = Dio();
    String apiKey = StringConstants.googleMapApiKey;
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin="
        "${origin.latitude},${origin.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&key=$apiKey";
    var response = await client.get(url);
    Map values = response.data;
    var steps = values["routes"][0]["legs"][0]["steps"];
    for (Map step in steps) {
      Map polyLine = step["polyline"];
      polyLineCoordinates
          .addAll(_convertToLatLng(_decodePoly(polyLine["points"])));
    }
    return polyLineCoordinates;
  }

  static Polyline? addPolyLine({
    required LatLng origin,
    required List<LatLng> polylineCoordinates,
  }) {
    if (polylineCoordinates.isNotEmpty) {
      return Polyline(
        polylineId: PolylineId(origin.toString()),
        visible: true,
        points: polylineCoordinates,
        color: Colors.blue,
      );
    }
    return null;
  }

  static List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  static List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    return lList;
  }

  static double distanceFormula(lat1, lon1, lat2, lon2) {
    try {
      var p = 0.017453292519943295;
      var a = 0.5 -
          cos((lat2 - lat1) * p) / 2 +
          cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    } catch (e) {
      return 0.0;
    }
  }

  static double calculateDistance({
    required List<LatLng> polylineCoordinates,
  }) {
    double totalDistance = 0.0;
    try {
      for (var i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += distanceFormula(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return totalDistance;
  }
}
