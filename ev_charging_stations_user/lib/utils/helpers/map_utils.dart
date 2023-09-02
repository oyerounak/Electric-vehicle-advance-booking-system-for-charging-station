import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_helper.dart';

class MapUtils {
  static const double defaultCameraZoom = 20;

  static Future<void> openMap({
    required double latitude,
    required double longitude,
  }) async {
    String googleUrl = 'https://www.google.com/maps/search/'
        '?api=1&query=$latitude,$longitude';
    Uri googleUrlURI = Uri.parse(googleUrl);
    if (await canLaunchUrl(googleUrlURI)) {
      await launchUrl(
        googleUrlURI,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open the map.';
    }
  }

  static void zoomInCamera({
    required GoogleMapController controller,
    required LatLng latLng,
    double? zoomLength,
  }) {
    try {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, zoomLength ?? defaultCameraZoom),
      );
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  static Future<String?> getAddressFromLatLng({
    required LatLng latLng,
  }) async {
    try {
      List<Placemark> placeMarkList = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      Placemark place = placeMarkList[0];
      return '${place.street}, ${place.subLocality}, ${place.locality}, '
          '${place.postalCode}, ${place.country}';
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return null;
  }

  static Marker? addMarker({
    required LatLng latLng,
    required String title,
    String? snippet,
    Function? onTapMarker,
    BitmapDescriptor? bitmapDescriptor,
  }) {
    try {
      return Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        anchor: const Offset(0.5, 0.5),
        icon: bitmapDescriptor ?? BitmapDescriptor.defaultMarker,
        flat: true,
        infoWindow: InfoWindow(
          title: title,
          snippet: snippet,
          onTap: () {
            if (onTapMarker != null) {
              onTapMarker();
            }
          },
        ),
      );
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return null;
  }
}
