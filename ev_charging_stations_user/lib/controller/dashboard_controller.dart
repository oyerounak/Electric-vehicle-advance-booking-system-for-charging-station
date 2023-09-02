import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/route_constants.dart';
import '../utils/custom_widgets/common_dialog.dart';
import '../utils/helpers/user_pref.dart';

class DashboardController extends GetxController {
  void onTapManageEVVehicles() {
    Get.toNamed(RouteConstants.manageEVVehicles);
  }

  void onTapFindStations() {
    Get.toNamed(RouteConstants.findStations);
  }

  void onTapViewBooking() {
    Get.toNamed(RouteConstants.viewBookings);
  }

  void onTapProfile() {
    Get.toNamed(RouteConstants.profileScreen);
  }

  void onPressViewRoadMap() {
    Get.toNamed(RouteConstants.googleMapViewRoadMap);
  }

  void onPressLogout() {
    Get.dialog(
      CommonDialog(
        title: "WARNING!!!!",
        contentWidget: const Text("Are you sure you want to logout?"),
        negativeRedDialogBtnText: "Confirm",
        positiveDialogBtnText: "Back",
        onNegativeRedBtnClicked: () {
          Get.offAllNamed(RouteConstants.loginScreen);
          UserPref.removeAllFromUserPref();
        },
      ),
    );
  }
}
