import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/constants/string_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_text_field.dart';
import '../../utils/custom_widgets/hidden_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());

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
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _iconWidget(),
                      _textFields(),
                      _loginButton(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () => loginController.onTapSignUp(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Sign Up ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  CustomTextField(
                    textEditingController: loginController.etEmail,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    currentFocusNode: loginController.etEmailFocusNode,
                    nextFocusNode: loginController.etPasswordFocusNode,
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
                    textEditingController: loginController.etPassword,
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    currentFocusNode: loginController.etPasswordFocusNode,
                    nextFocusNode: loginController.etPasswordFocusNode,
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
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return CustomButton(
      buttonText: "Login",
      onButtonPressed: () => {
        loginController.onPressButtonLogin(
          formKey: _formKey,
        ),
      },
    );
  }
}
