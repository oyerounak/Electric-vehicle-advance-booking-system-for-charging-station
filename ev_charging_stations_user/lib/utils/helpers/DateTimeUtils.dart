import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'common_helper.dart';

class DateTimeUtils {
  static String? currentDayOfWeek() {
    try {
      return DateFormat('EEEE').format(DateTime.now());
    } catch (e) {
      return null;
    }
  }

  static DateTime? stringTimeToDateTime({
    required String time,
  }) {
    try {
      var timeFormat = DateFormat("hh:mm");
      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(timeFormat.parse(time));
      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
    } catch (e) {
      return null;
    }
  }

  static DateTime? stringDateTimeToDateTime({
    required String stringDateTime,
  }) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd hh:mm");
      return dateFormat.parse(stringDateTime);
    } catch (e) {
      return null;
    }
  }

  static DateTime? currentDateTime() {
    try {
      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String currentDateTimeInString() {
    return currentDate() + " " + currentTime();
  }

  static String? dateTimeTo24hrTimeTo12hr({
    required String dateTime,
  }) {
    try {
      var timeFormat = DateFormat("hh:mm");
      return DateFormat("hh:mm a").format(timeFormat.parse(dateTime));
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> showTimePickerDialog() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: Get.context as BuildContext,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null) {
      final localizations =
          MaterialLocalizations.of(Get.context as BuildContext);
      String formattedTime =
          localizations.formatTimeOfDay(timeOfDay, alwaysUse24HourFormat: true);
      return formattedTime;
    }
    return null;
  }

  static Future<String?> showDatePickerDialog() async {
    var dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat(DateFormat.YEAR);
    int currentYear = int.parse(dateFormat.format(dateTime));

    final DateTime? d = await showDatePicker(
      context: Get.context as BuildContext,
      initialDate: dateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(currentYear + 1),
    );
    if (d != null) {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      return dateFormat.format(d);
    }
    return null;
  }

  static String currentDate() {
    DateTime currentDateTime = DateTime.now();
    return currentDateTime.year.toString() +
        "/" +
        currentDateTime.month.toString() +
        "/" +
        currentDateTime.day.toString();
  }

  static String currentTime() {
    DateTime currentDateTime = DateTime.now();
    return currentDateTime.hour.toString() +
        ":" +
        currentDateTime.minute.toString();
  }

  static int checkStringDateTimeDifferenceInHours({
    String? startDate,
    String? startTime,
    required String endDate,
    required String endTime,
  }) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd hh:mm");
      DateTime startDateTime = dateFormat.parse(
          (startDate ?? currentDate()) + " " + (startTime ?? currentTime()));

      DateTime endDateTime = dateFormat.parse(endDate + " " + endTime);
      Duration duration = endDateTime.difference(startDateTime);

      return duration.inHours;
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return 0;
  }

  static String? timeValidation({
    required String startTime,
    required String endTime,
  }) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd hh:mm");
      DateTime startDateTime =
          dateFormat.parse(currentDate() + " " + startTime);
      DateTime endDateTime = dateFormat.parse(currentDate() + " " + endTime);
      if (startDateTime.hour.isGreaterThan(endDateTime.hour)) {
        return "Not valid!!!";
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return null;
  }

  static String? stringDateTimeValidation({
    String? startDate,
    String? startTime,
    required String endDate,
    required String endTime,
  }) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd hh:mm");
      DateTime startDateTime = dateFormat.parse(
          (startDate ?? currentDate()) + " " + (startTime ?? currentTime()));

      DateTime endDateTime = dateFormat.parse(endDate + " " + endTime);

      if (startDateTime.isAfter(endDateTime) ||
          startDateTime.isAtSameMomentAs(endDateTime)) {
        return "Not valid!!!";
      } else {
        return null;
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return null;
  }
}
