import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_master.dart';
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

  void onTapSignUp() {
    Get.toNamed(RouteConstants.registrationScreen);
  }

  void onPressButtonLogin({required GlobalKey<FormState> formKey}) async {
    if (formKey.currentState!.validate()) {
      login();
    }
  }

  Future<void> login() async {
    try {
      CommonProgressBar.show();
      String emailId = etEmail.text;
      String password = etPassword.text;

      UserMaster adminMaster = UserMaster();
      adminMaster.emailId = emailId;
      adminMaster.password = password;

      var jsonResponse = await ApiService.postLoginAndGetData(
          ApiConstants.userLogin,
          body: adminMaster) as List;

      List<UserMaster> userMasterList =
          jsonResponse.map((e) => UserMaster.fromJson(e)).toList();

      if (userMasterList.isNotEmpty) {
        if (userMasterList[0].status != null) {
          if (userMasterList[0].status!.contains("false") ||
              userMasterList[0].status!.contains("no")) {
            SnackBarUtils.errorSnackBar(
              title: "Error",
              message: 'Invalid username or password. Please try again later',
            );
          } else {
            SnackBarUtils.errorSnackBar(
              title: "Error",
              message: 'Something went wrong. Please try again later',
            );
          }
        } else {
          if (userMasterList[0].userId != null) {
            UserPref.setLoginStatus(true);
            UserPref.setLoginUserId(userMasterList[0].userId);
            UserPref.setLoginUserName(userMasterList[0].userName);
            Get.offAllNamed(RouteConstants.dashboardScreen);
          } else {
            SnackBarUtils.errorSnackBar(
              title: "Error",
              message: 'Something went wrong. Please try again later',
            );
          }
        }
      } else {
        SnackBarUtils.errorSnackBar(
          title: "Error",
          message: 'Something went wrong. Please try again later',
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
      SnackBarUtils.errorSnackBar(
        title: "Error",
        message: 'Something went wrong. Please try again later',
      );
    } finally {
      CommonProgressBar.hide();
    }
  }
}
