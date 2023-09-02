import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../custom_widgets/common_dialog.dart';

class CommonHelper {
  static printDebugError(Object? error) {
    if (error == null) {
      debugPrint("\x1B[31mERROR :- Something went wrong\x1B[0m");
    } else {
      debugPrint("\x1B[31mERROR :- " + error.toString() + "\x1B[0m");
    }
  }

  static printDebug(Object? message) {
    if (message != null) {
      debugPrint(message.toString());
    }
  }

  static Future<bool> getInternetStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        printDebug('connected');
        return true;
      }
    } catch (_) {
      Get.snackbar(
        "ERROR",
        "Internet connection not found. Please try again later",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      printDebug('not connected');
    }
    return false;
  }

  static deleteDialog({
    required String toDelete,
    required Function onConfirmDelete,
  }) {
    Get.dialog(
      CommonDialog(
        title: "Delete $toDelete",
        contentWidget: Text(
          "Are you sure you want to delete current $toDelete?",
        ),
        negativeRedDialogBtnText: "Confirm",
        positiveDialogBtnText: "Back",
        onNegativeRedBtnClicked: () {
          Get.back();
          onConfirmDelete();
        },
      ),
    );
  }
}
