import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SnackBarUtils {
  static normalSnackBar({required String title, required String message}) {
    return Get.snackbar(
      title,
      message,
      colorText: Colors.black,
      backgroundColor: Colors.white,
    );
  }

  static errorSnackBar({required String title, required String message}) {
    return Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }
}
