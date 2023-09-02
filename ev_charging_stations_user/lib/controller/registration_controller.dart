import 'package:ev_charging_stations_user/utils/helpers/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_master.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/route_constants.dart';
import '../utils/custom_widgets/common_progress.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/services/api_service.dart';

class RegistrationController extends GetxController {
  late TextEditingController etName;
  late TextEditingController etContact;
  late TextEditingController etEmailId;
  late TextEditingController etPassword;

  late FocusNode etNameFocusNode;
  late FocusNode etContactFocusNode;
  late FocusNode etEmailIdFocusNode;
  late FocusNode etPasswordFocusNode;

  @override
  void onInit() {
    super.onInit();
    initUI();
  }

  void initUI() {
    etName = TextEditingController();
    etContact = TextEditingController();
    etEmailId = TextEditingController();
    etPassword = TextEditingController();

    etNameFocusNode = FocusNode();
    etContactFocusNode = FocusNode();
    etEmailIdFocusNode = FocusNode();
    etPasswordFocusNode = FocusNode();
  }

  void onCLickRegister({
    required GlobalKey<FormState> formKey,
  }) async {
    if (formKey.currentState!.validate()) {
      _registerUser();
    }
  }

  UserMaster createUserObject() {
    String userName = etName.text;
    String contact = etContact.text;
    String emailId = etEmailId.text;
    String password = etPassword.text;

    UserMaster userMaster = UserMaster();
    userMaster.userName = userName;
    userMaster.contact = contact;
    userMaster.emailId = emailId;
    userMaster.password = password;

    return userMaster;
  }

  Future<void> _registerUser() async {
    try {
      CommonProgressBar.show();

      UserMaster userMaster = createUserObject();
      var jsonResponse = await ApiService.postGetStatus(
        ApiConstants.userRegistration,
        body: userMaster,
      );
      CommonHelper.printDebugError(jsonResponse.toString());
      if (jsonResponse.isNotEmpty) {
        if (jsonResponse.toString().contains("true")) {
          SnackBarUtils.normalSnackBar(
            title: "Success",
            message: 'User registered successfully',
          );
          Get.offAllNamed(RouteConstants.loginScreen);
        } else if (jsonResponse.toString().contains("already")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: "User already exist.  Please try again",
          );
        } else if (jsonResponse.toString().contains("false") ||
            jsonResponse.toString().contains("no")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Something went wrong. Please try again later',
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
