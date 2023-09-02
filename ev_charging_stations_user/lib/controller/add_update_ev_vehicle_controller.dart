import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/ev_vehicles.dart';
import '../utils/constants/api_constants.dart';
import '../utils/custom_widgets/common_progress.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/snack_bar_utils.dart';
import '../utils/helpers/user_pref.dart';
import '../utils/services/api_service.dart';

class AddUpdateEVVehicleController extends GetxController {
  late TextEditingController etVehicleNumber;
  late TextEditingController etVehicleName;

  late FocusNode etVehicleNumberFocusNode;
  late FocusNode etVehicleNameFocusNode;
  late FocusNode btnSubmitFocusNode;

  late EvVehicles? evVehicleArg;
  var evVehicleId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initUI();
    initObj();
    _setDataToFields();
  }

  void initUI() {
    etVehicleNumber = TextEditingController();
    etVehicleName = TextEditingController();
    etVehicleNumberFocusNode = FocusNode();
    etVehicleNameFocusNode = FocusNode();
    btnSubmitFocusNode = FocusNode();
  }

  void initObj() {
    evVehicleArg = Get.arguments;
  }

  void _setDataToFields() {
    try {
      if (evVehicleArg != null) {
        etVehicleNumber.text = evVehicleArg!.vehicleNumber!;
        etVehicleName.text = evVehicleArg!.vehicleName!;
        evVehicleId.value = evVehicleArg!.vehicleId!;
      }
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  Future<EvVehicles> createEvVehicleObject() async {
    EvVehicles evVehicle = EvVehicles();
    try {
      evVehicle.vehicleNumber = etVehicleNumber.text;
      evVehicle.vehicleName = etVehicleName.text;
      evVehicle.userId = await UserPref.getLoginUserId();
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return evVehicle;
  }

  void onTapDelete({required GlobalKey<FormState> formKey}) {
    CommonHelper.deleteDialog(
      toDelete: "course",
      onConfirmDelete: () {
        _deleteVehicle(formKey: formKey);
      },
    );
  }

  void onPressSubmit({
    required GlobalKey<FormState> formKey,
  }) async {
    if (formKey.currentState!.validate()) {
      await CommonHelper.getInternetStatus().then(
        (connection) async {
          if (connection) {
            if (evVehicleArg == null) {
              _createNewVehicle(formKey: formKey);
            } else {
              _updateVehicle(formKey: formKey);
            }
          }
        },
      );
    }
  }

  Future<void> _createNewVehicle({
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      CommonProgressBar.show();

      EvVehicles evVehicles = await createEvVehicleObject();

      var jsonResponse = await ApiService.postGetStatus(
        ApiConstants.addEVVehicles,
        body: evVehicles,
      );

      if (jsonResponse.isNotEmpty) {
        if (jsonResponse.contains("true")) {
          Get.back();
          SnackBarUtils.normalSnackBar(
            title: "Success",
            message: 'Station added successfully',
          );
        } else if (jsonResponse.contains("already")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Station already exist. Please try again',
          );
        } else if (jsonResponse.contains("false") ||
            jsonResponse.contains("no")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Failed to add station. Please try again later',
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

  Future<void> _updateVehicle({
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      CommonProgressBar.show();

      EvVehicles evVehicles = await createEvVehicleObject();
      evVehicles.vehicleId = evVehicleId.value;

      var jsonResponse = await ApiService.postGetStatus(
        ApiConstants.updateEVVehicles,
        body: evVehicles,
      );
      if (jsonResponse.isNotEmpty) {
        if (jsonResponse.contains("true")) {
          Get.back();
          SnackBarUtils.normalSnackBar(
            title: "Success",
            message: 'Station updated successfully',
          );
        } else if (jsonResponse.contains("already")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Station already exist. Please try again',
          );
        } else if (jsonResponse.contains("false") ||
            jsonResponse.contains("no")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Failed to updated station. Please try again later',
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

  Future<void> _deleteVehicle({
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      CommonProgressBar.show();

      EvVehicles evVehicles = EvVehicles();
      evVehicles.vehicleId = evVehicleId.value;

      var jsonResponse = await ApiService.postGetStatus(
        ApiConstants.deleteEVVehicles,
        body: evVehicles,
      );
      if (jsonResponse.isNotEmpty) {
        if (jsonResponse.contains("true")) {
          Get.back();
          SnackBarUtils.normalSnackBar(
            title: "Success",
            message: 'Station deleted successfully',
          );
        } else if (jsonResponse.contains("false") ||
            jsonResponse.contains("no")) {
          SnackBarUtils.errorSnackBar(
            title: "Failed!",
            message: 'Failed to delete station. Please try again later',
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
