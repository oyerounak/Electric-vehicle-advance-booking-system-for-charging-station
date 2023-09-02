import 'package:ev_charging_stations_user/models/bookings.dart';
import 'package:ev_charging_stations_user/utils/helpers/DateTimeUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/api_constants.dart';
import '../utils/custom_widgets/common_dialog.dart';
import '../utils/custom_widgets/common_progress.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/snack_bar_utils.dart';
import '../utils/services/api_service.dart';

class ViewBookingDetailsController extends GetxController {
  late Bookings bookingArg;
  late bool isCancelButtonVisible;

  @override
  void onInit() {
    super.onInit();
    bookingArg = Get.arguments;
    isCancelButtonVisible = checkIfBookingCanCancel();
  }

  bool checkIfBookingCanCancel() {
    try {
      String? bookingDate = bookingArg.bookingDate!;
      String? bookingTime = bookingArg.timeIn!;

      int hoursRemaining = DateTimeUtils.checkStringDateTimeDifferenceInHours(
        endDate: bookingDate,
        endTime: bookingTime,
      );

      if (hoursRemaining >= 1) {
        if (bookingArg.bookingStatus != null) {
          if (bookingArg.bookingStatus!.toLowerCase().contains("cancel")) {
            return false;
          }
        }
        return true;
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return false;
  }

  Future<void> onTapCancelBooking() async {
    Get.dialog(
      CommonDialog(
        title: "WARNING!!!!",
        contentWidget: const Text(
          "Are you sure you want to "
          "cancel booking? This cannot be undone",
        ),
        negativeRedDialogBtnText: "Confirm",
        positiveDialogBtnText: "Back",
        onNegativeRedBtnClicked: () => cancelBooking(),
      ),
    );
  }

  Future<void> cancelBooking() async {
    try {
      String? bookingDate = bookingArg.bookingDate!;
      String? bookingTime = bookingArg.timeIn!;

      int hoursRemaining = DateTimeUtils.checkStringDateTimeDifferenceInHours(
        endDate: bookingDate,
        endTime: bookingTime,
      );

      if (hoursRemaining >= 1) {
        Get.back();
        CommonProgressBar.show();

        Bookings booking = Bookings();
        booking.bookingId = booking.bookingId;

        var jsonResponse = await ApiService.postGetStatus(
          ApiConstants.cancelBookings,
          body: booking,
        );
        if (jsonResponse.isNotEmpty) {
          if (jsonResponse.contains("true")) {
            Get.back();
            SnackBarUtils.normalSnackBar(
              title: "Success",
              message: 'Booking cancelled',
            );
          } else if (jsonResponse.contains("false") ||
              jsonResponse.contains("no")) {
            SnackBarUtils.errorSnackBar(
              title: "Failed!",
              message: 'Failed to cancel booking. Please try again later',
            );
          }
        }
      } else {
        SnackBarUtils.errorSnackBar(
          title: "Failed!",
          message: 'Booking cannot be cancelled',
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
      SnackBarUtils.errorSnackBar(
        title: "Failed!",
        message: 'Something went wrong. Please try again later',
      );
    } finally {
      CommonProgressBar.hide();
    }
  }
}
