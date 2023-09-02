import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/constants/string_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_text_field.dart';
import '../../utils/custom_widgets/hidden_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(DimenConstants.layoutPadding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _iconWidget(),
                _textFields(),
                _loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconWidget() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.mainLayoutPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage(StringConstants.logo),
              fit: BoxFit.fitHeight,
              alignment: Alignment.center,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(DimenConstants.contentPadding),
              child: const Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              textEditingController: _controller.etEmail,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              currentFocusNode: _controller.etEmailFocusNode,
              nextFocusNode: _controller.etPasswordFocusNode,
              allowedRegex: "[a-zA-Z0-9@.]",
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Email Cannot Be Empty';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Enter Valid Email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: DimenConstants.contentPadding,
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

  Widget _loginButton() {
    return CustomButton(
      buttonText: "Login",
      onButtonPressed: () => {
        _controller.onPressButtonLogin(
          formKey: _formKey,
        ),
      },
    );
  }
}
