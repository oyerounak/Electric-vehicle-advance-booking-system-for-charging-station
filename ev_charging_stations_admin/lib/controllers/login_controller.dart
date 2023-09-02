import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/admin_master.dart';
import '../utils/custom_widgets/common_progress.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/snack_bar_utils.dart';
import '../utils/services/api_service.dart';
import '../utils/helpers/user_pref.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/route_constants.dart';

class LoginController extends GetxController {
  late TextEditingController etEmail;
  late TextEditingController etPassword;

  late FocusNode etEmailFocusNode;
  late FocusNode etPasswordFocusNode;

  @override
  void onInit() {
    super.onInit();
    initUI();
  }

  void initUI() {
    etEmail = TextEditingController();
    etPassword = TextEditingController();
    etEmailFocusNode = FocusNode();
    etPasswordFocusNode = FocusNode();
  }

  void onPressButtonLogin({
    required GlobalKey<FormState> formKey,
  }) async {
    if (formKey.currentState!.validate()) {
      login();
    }
  }

  AdminMaster createAdminObject() {
    String emailId = etEmail.text;
    String password = etPassword.text;

    AdminMaster adminMaster = AdminMaster();
    adminMaster.emailId = emailId;
    adminMaster.password = password;

    return adminMaster;
  }

  Future<void> login() async {
    try {
      CommonProgressBar.show();

      AdminMaster adminMaster = createAdminObject();
      var jsonResponse = await ApiService.postGetStatus(
        ApiConstants.adminLogin,
        body: adminMaster,
      );
      if (jsonResponse.isNotEmpty) {
        if (jsonResponse.contains("true")) {
          UserPref.setLoginStatus(true);
          Get.offAllNamed(RouteConstants.dashboardScreen);
        } else if (jsonResponse.contains("false") ||
            jsonResponse.contains("no")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed",
            message: 'Invalid username or password. Please try again later',
          );
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
      SnackBarUtils.errorSnackBar(
        title: "Failed",
        message: "Something went wrong. Please try again later",
      );
    }finally{
      CommonProgressBar.hide();
    }
  }
}
