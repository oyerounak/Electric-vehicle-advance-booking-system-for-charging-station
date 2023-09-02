import 'package:ev_charging_stations_user/utils/constants/route_constants.dart';
import 'package:ev_charging_stations_user/utils/helpers/user_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/bookings.dart';
import '../utils/constants/api_constants.dart';
import '../utils/services/api_service.dart';

class ViewBookingController extends GetxController {
  var selectedDate = 'Tap to select date'.obs;
  var isLoading = true.obs;
  var dataList = <Bookings>[].obs;
  var isDataHolderVisible = false.obs;

  Future<void> selectDate(BuildContext context) async {
    var dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat(DateFormat.YEAR);
    int currentYear = int.parse(dateFormat.format(dateTime));

    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(currentYear + 1),
    );
    if (d != null) {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      selectedDate.value = dateFormat.format(d);
      selectedDate.obs;
      fetchBookingsByDate();
    }
  }

  void onPressViewRoadMap() {
    Get.toNamed(
      RouteConstants.googleMapViewRoadMap,
    )?.then((value) => fetchBookingsByDate());
  }

  void fetchBookingsByDate() async {
    try {
      isDataHolderVisible.value = true;
      isLoading(true);
      Bookings bookings = Bookings();
      bookings.userId = await UserPref.getLoginUserId();
      bookings.bookingDate = selectedDate.value;
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewBookings,
        body: bookings,
      ) as List;
      dataList.value = jsonResponse.map((e) => Bookings.fromJson(e)).toList();
    } finally {
      isLoading(false);
    }
  }

  void onTapBookingCard({required Bookings booking}) {
    Get.toNamed(
      RouteConstants.viewBookingDetails,
      arguments: booking,
    )?.then((value) => fetchBookingsByDate());
  }
}
