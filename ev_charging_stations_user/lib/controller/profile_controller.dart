import 'package:ev_charging_stations_user/utils/helpers/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_master.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/route_constants.dart';
import '../utils/custom_widgets/common_dialog.dart';
import '../utils/custom_widgets/common_progress.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/user_pref.dart';
import '../utils/services/api_service.dart';

class ProfileController extends GetxController {
  late TextEditingController etName;
  late TextEditingController etContact;
  late TextEditingController etEmailId;
  late TextEditingController etOldPassword;
  late TextEditingController etNewPassword;

  late FocusNode etNameFocusNode;
  late FocusNode etContactFocusNode;
  late FocusNode etEmailIdFocusNode;
  late FocusNode etOldPasswordFocusNode;
  late FocusNode etNewPasswordFocusNode;

  var isLoading = true.obs;
  var dataList = <UserMaster>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    initUI();
    fetchProfile().then((value) {
      _setUserProfileToField();
    });
  }

  void initUI() {
    etName = TextEditingController();
    etContact = TextEditingController();
    etEmailId = TextEditingController();
    etOldPassword = TextEditingController();
    etNewPassword = TextEditingController();

    etNameFocusNode = FocusNode();
    etContactFocusNode = FocusNode();
    etEmailIdFocusNode = FocusNode();
    etOldPasswordFocusNode = FocusNode();
    etNewPasswordFocusNode = FocusNode();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      UserMaster userMaster = UserMaster();
      userMaster.userId = await UserPref.getLoginUserId();
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewUserProfile,
        body: userMaster,
      ) as List;
      dataList.value = jsonResponse.map((e) => UserMaster.fromJson(e)).toList();
    } finally {
      isLoading(false);
    }
  }

  void _setUserProfileToField() {
    try {
      UserMaster userMaster = dataList.value[0];
      etName.text = userMaster.userName!;
      etContact.text = userMaster.contact!;
      etEmailId.text = userMaster.emailId!;
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  void onClickUpdateProfile({
    required GlobalKey<FormState> formKey,
  }) async {
    if (formKey.currentState!.validate()) {
      try {
        CommonProgressBar.show();
        UserMaster userMaster = UserMaster();
        userMaster.userId = await UserPref.getLoginUserId();
        userMaster.userName = etName.text;
        userMaster.contact = etContact.text;
        userMaster.emailId = etEmailId.text;

        var jsonResponse = await ApiService.postGetStatus(
            ApiConstants.updateUserProfile,
            body: userMaster);
        if (jsonResponse.isNotEmpty) {
          if (jsonResponse.contains("true")) {
            SnackBarUtils.normalSnackBar(
              title: "Success",
              message: 'Profile updated successfully',
            );
          } else if (jsonResponse.contains("false") ||
              jsonResponse.contains("no")) {
            SnackBarUtils.normalSnackBar(
              title: "Failed!",
              message: 'Failed to update profile. Please try again later',
            );
          }
        }
      } catch (e) {
        CommonHelper.printDebugError(e);
        SnackBarUtils.normalSnackBar(
          title: "ERROR!",
          message: 'Something went wrong. Please try again later',
        );
      } finally {
        CommonProgressBar.hide();
      }
    }
  }

  Future<void> onConfirmChangePassword({
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      CommonProgressBar.show();
      if (formKey.currentState!.validate()) {
        UserMaster userMaster = UserMaster();
        userMaster.userId = await UserPref.getLoginUserId();
        userMaster.oldPassword = etOldPassword.text;
        userMaster.newPassword = etNewPassword.text;
        var jsonResponse = await ApiService.postGetStatus(
          ApiConstants.changePassword,
          body: userMaster,
        );
        if (jsonResponse.toString().contains("true")) {
          Get.back();
          Get.dialog(
            CommonDialog(
              title: "Success",
              contentWidget: const Text(
                "Password Changed Successfully,\n Need to login again!!!",
              ),
              positiveDialogBtnText: "Ok",
              onPositiveButtonClicked: () {
                Get.offAllNamed(RouteConstants.loginScreen);
                UserPref.removeAllFromUserPref();
              },
            ),
          );
        } else if (jsonResponse.toString().contains("false") ||
            jsonResponse.toString().contains("no")) {
          Get.back();
          Get.dialog(
            CommonDialog(
              title: "Failed",
              contentWidget: const Text(
                "Enter Correct Password And \nTry Again Later",
              ),
              positiveDialogBtnText: "Ok",
              onPositiveButtonClicked: () {
                Get.back();
              },
            ),
          );
        } else {
          SnackBarUtils.normalSnackBar(
            title: "ERROR!",
            message: 'Something went wrong. Please try again later',
          );
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    } finally {
      CommonProgressBar.hide();
    }
  }
}
