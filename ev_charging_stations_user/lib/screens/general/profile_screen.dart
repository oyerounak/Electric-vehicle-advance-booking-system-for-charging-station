import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/profile_controller.dart';
import '../../models/user_master.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/common_data_holder.dart';
import '../../utils/custom_widgets/common_dialog.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_text_field.dart';
import '../../utils/custom_widgets/hidden_text_field.dart';

class ProfileScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ProfileController _controller = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("PROFILE"),
        centerTitle: true,
      ),
      body: CommonDataHolder(
        controller: _controller,
        widget: _profileScreenWidget,
        dataList: _controller.dataList,
      ),
    );
  }

  Widget _profileScreenWidget(List<UserMaster>? userMasterList) {
    return SizedBox(
      height: Get.height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _textFields(),
            _submitButton(),
            _changePassword(),
          ],
        ),
      ),
    );
  }

  Widget _textFields() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              textEditingController: _controller.etName,
              hintText: "Name",
              prefixIcon: Icons.drive_file_rename_outline,
              currentFocusNode: _controller.etNameFocusNode,
              nextFocusNode: _controller.etEmailIdFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Name Cannot Be Empty';
                }
                return null;
              },
            ),
            CustomTextField(
              textEditingController: _controller.etEmailId,
              hintText: "Email Id",
              prefixIcon: Icons.email_outlined,
              currentFocusNode: _controller.etEmailIdFocusNode,
              nextFocusNode: _controller.etContactFocusNode,
              allowedRegex: "[a-zA-Z0-9@.]",
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Email Id Cannot Be Empty';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Enter Valid Email Id';
                }
                return null;
              },
            ),
            CustomTextField(
              textEditingController: _controller.etContact,
              hintText: "Contact",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.local_phone_outlined,
              currentFocusNode: _controller.etContactFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Contact Cannot Be Empty';
                }
                if (!GetUtils.isPhoneNumber(value)) {
                  return 'Enter Valid Contact';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return CustomButton(
      buttonText: "Update Profile",
      onButtonPressed: () {
        _controller.onClickUpdateProfile(
          formKey: _formKey,
        );
      },
    );
  }

  Widget _changePassword() {
    return InkWell(
      child: Text(
        "Change Password".toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Get.theme.primaryColor,
        ),
      ),
      onTap: () {
        Get.dialog(_changePasswordAlertDialog());
      },
    );
  }

  Widget _changePasswordAlertDialog() {
    _controller.etOldPassword.text = "";
    _controller.etNewPassword.text = "";
    final _formKey = GlobalKey<FormState>();

    return CommonDialog(
      title: "Change Password",
      contentWidget: Card(
        elevation: 0.0,
        color: Colors.transparent,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomHiddenTextField(
                textEditingController: _controller.etOldPassword,
                hintText: "Old Password",
                prefixIcon: Icons.lock_outline,
                currentFocusNode: _controller.etOldPasswordFocusNode,
                nextFocusNode: _controller.etNewPasswordFocusNode,
                validatorFunction: (value) {
                  if (value!.isEmpty) {
                    return 'Cannot Be Empty';
                  }
                  return null;
                },
              ),
              CustomHiddenTextField(
                textEditingController: _controller.etNewPassword,
                hintText: "New Password",
                prefixIcon: Icons.lock_outline,
                currentFocusNode: _controller.etNewPasswordFocusNode,
                validatorFunction: (value) {
                  if (value!.isEmpty) {
                    return 'Cannot Be Empty';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      negativeRedDialogBtnText: "Confirm",
      positiveDialogBtnText: "Back",
      onNegativeRedBtnClicked: () {
        _controller.onConfirmChangePassword(
          formKey: _formKey,
        );
      },
    );
  }
}
