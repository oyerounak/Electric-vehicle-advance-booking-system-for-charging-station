import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/registration_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_text_field.dart';
import '../../utils/custom_widgets/hidden_text_field.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final RegistrationController _controller = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _textFields(),
              _submitButton(),
            ],
          ),
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
              nextFocusNode: _controller.etPasswordFocusNode,
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
            CustomHiddenTextField(
              textEditingController: _controller.etPassword,
              hintText: "Password",
              prefixIcon: Icons.lock_outline,
              currentFocusNode: _controller.etPasswordFocusNode,
              nextFocusNode: _controller.etPasswordFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Password Cannot Be Empty';
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
      buttonText: "Submit",
      onButtonPressed: () {
        _controller.onCLickRegister(
          formKey: _formKey,
        );
      },
    );
  }
}
