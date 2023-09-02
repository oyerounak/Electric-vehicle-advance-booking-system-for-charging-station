import 'package:ev_charging_stations_user/screens/find_stations/ev_vehicle_dialog.dart';
import 'package:ev_charging_stations_user/utils/custom_widgets/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/bookings.dart';
import '../models/ev_vehicles.dart';
import '../models/slots.dart';
import '../utils/constants/api_constants.dart';
import '../utils/custom_widgets/common_progress.dart';
import '../utils/helpers/DateTimeUtils.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/snack_bar_utils.dart';
import '../utils/helpers/user_pref.dart';
import '../utils/services/api_service.dart';

class ManageSlotsController extends GetxController {
  var isLoading = true.obs;
  var dataList = <Slots>[].obs;
  var evVehicleList = <EvVehicles>[].obs;
  var isDataTableVisible = false.obs;
  var duration = ''.obs;

  late TextEditingController etDatePicker;
  late TextEditingController etSelectTime;
  late TextEditingController etSelectDuration;
  late FocusNode etDatePickerFocusNode;
  late FocusNode etSelectTimeFocusNode;
  late FocusNode etSelectDurationFocusNode;

  late String stationId;
  late String? stringTimeOut;

  @override
  void onInit() {
    super.onInit();
    initUI();
    initObj();
    fetchEVVehicles();
  }

  void initUI() {
    etDatePicker = TextEditingController();
    etSelectTime = TextEditingController();
    etSelectDuration = TextEditingController();
    etDatePickerFocusNode = FocusNode();
    etSelectTimeFocusNode = FocusNode();
    etSelectDurationFocusNode = FocusNode();
  }

  void initObj() {
    stationId = Get.arguments;
  }

  void fetchEVVehicles() async {
    try {
      isLoading(true);
      EvVehicles evVehicles = EvVehicles();
      evVehicles.userId = await UserPref.getLoginUserId();
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewEVVehicles,
        body: evVehicles,
      ) as List;
      evVehicleList.value =
          jsonResponse.map((e) => EvVehicles.fromJson(e)).toList();
    } finally {
      isLoading(false);
    }
  }

  void onTapDatePickerField() {
    isDataTableVisible.value = false;
    DateTimeUtils.showDatePickerDialog().then((value) {
      if (value != null) {
        etDatePicker.text = value;
      }
    });
  }

  void onTapTimePickerField() {
    DateTimeUtils.showTimePickerDialog().then((value) {
      if (value != null) {
        etSelectTime.text = value;
      }
    });
  }

  String? dropDownValidation(String? value) {
    try {
      if (value == null) {
        return 'Cannot Be Empty';
      }
      if (value == "Select Duration") {
        return 'Cannot Be Empty';
      }
    } catch (e) {
      return 'Cannot Be Empty';
    }
    return null;
  }

  void onChanged(String value) {
    duration.value = value;
  }

  void onTapSlotCard({required Slots slot}) {}

  void loadSlots() async {
    try {
      isLoading(true);
      Slots slots = Slots();
      slots.stationId = stationId;
      slots.date = etDatePicker.text;
      slots.timeIn = etSelectTime.text;

      DateTime dateTime = DateFormat("yyyy/mm/dd hh:mm")
          .parse(etDatePicker.text + " " + etSelectTime.text);

      TimeOfDay timeOut;
      if (duration.value.contains(".")) {
        List<String> hoursMinutes = duration.value.split(".");
        if (hoursMinutes.length == 2) {
          int hours = int.parse(hoursMinutes[0]);
          int minutes = int.parse(hoursMinutes[1]);
          timeOut = TimeOfDay.fromDateTime(
              dateTime.add(Duration(hours: hours, minutes: minutes)));
        } else {
          int hours = int.parse(hoursMinutes[0]);
          timeOut =
              TimeOfDay.fromDateTime(dateTime.add(Duration(hours: hours)));
        }
      } else {
        int hours = int.parse(duration.value);
        timeOut = TimeOfDay.fromDateTime(dateTime.add(Duration(hours: hours)));
      }

      BuildContext context = Get.context as BuildContext;
      final localizations = MaterialLocalizations.of(context);
      stringTimeOut = localizations.formatTimeOfDay(
        timeOut,
        alwaysUse24HourFormat: true,
      );
      slots.timeOut = stringTimeOut;
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewSlot,
        body: slots,
      ) as List;
      dataList.value = jsonResponse.map((e) => Slots.fromJson(e)).toList();
    } finally {
      isLoading(false);
    }
  }


  void onClickGetSlots({required GlobalKey<FormState> formKey}) {
    if (formKey.currentState!.validate()) {
      Get.back();
      isDataTableVisible.value = true;
      loadSlots();
    }
  }

  Future<void> onTapBookSlot({required Slots slot}) async {
    Get.dialog(
      CommonDialog(
        title: "Ev Vehicles",
        contentWidget: SizedBox(
          height: Get.height * 0.3,
          width: Get.width,
          child: EvVehicleDialog(
            controller: this,
            slot: slot,
          ),
        ),
        positiveDialogBtnText: "Back",
      ),
    );
  }

  Future<void> onTapVehicle({
    required EvVehicles evVehicles,
    required Slots slot,
  }) async {
    try {
      Get.back();
      CommonProgressBar.show();

      //{
      //    "StationId":"1",
      //    "Slotid":"1",
      //    "Uid":"1000",
      //    "Vid":"1",
      //    "Date":"2022/03/16",
      //    "TimeIn":"17:00",
      //    "TimeOut":"22:00",
      //    "Amount":"1000",
      //    "DT":"2022/03/16 13:00",
      //}
      Bookings bookings = Bookings();
      bookings.stationId = stationId;
      bookings.slotId = slot.slotsId;
      bookings.userId = await UserPref.getLoginUserId();
      bookings.vehicleId = evVehicles.vehicleId;
      bookings.bookingDate = etDatePicker.text;
      bookings.timeIn = etSelectTime.text;
      bookings.timeOut = stringTimeOut;
      bookings.amount = slot.price;
      bookings.dateTime = DateTimeUtils.currentDateTimeInString();

      var jsonResponse = await ApiService.postGetStatus(
        ApiConstants.bookSlot,
        body: bookings,
      );
      if (jsonResponse.isNotEmpty) {
        if (jsonResponse.contains("true")) {
          Get.back();
          SnackBarUtils.normalSnackBar(
            title: "Success",
            message: 'Slot booked successfully',
          );
        } else if (jsonResponse.contains("false") ||
            jsonResponse.contains("no")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Failed to book slot. Please try again later',
          );
        }
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
