import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';
import '../helpers/common_helper.dart';

class CustomHiddenTextField extends StatelessWidget {
  final FocusNode? currentFocusNode, nextFocusNode;
  final TextEditingController textEditingController;
  final String hintText;
  final String? allowedRegex;
  final IconData? prefixIcon, suffixIcon;
  final bool? isEnabled;
  final String? Function(String?)? validatorFunction;
  final bool? isWrapContent;

  var obscureText = true.obs;

  CustomHiddenTextField(
      {Key? key,
      required this.hintText,
      required this.textEditingController,
      this.prefixIcon,
      this.suffixIcon,
      this.currentFocusNode,
      this.nextFocusNode,
      this.allowedRegex,
      this.isEnabled,
      this.validatorFunction,
      this.isWrapContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    if (isWrapContent != null) {
      if (isWrapContent == true) {
        return SizedBox(child: _textFormField());
      }
    }
    return Container(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: _textFormField(),
    );
  }

  Widget _textFormField() {
    return Obx(
      () => TextFormField(
        focusNode: currentFocusNode,
        controller: textEditingController,
        obscureText: obscureText.value,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [
          if (allowedRegex != null)
            FilteringTextInputFormatter.allow(
              RegExp(allowedRegex!),
            )
        ],
        enabled: isEnabled ?? true,
        validator: validatorFunction,
        onFieldSubmitted: (_) {
          try {
            FocusManager.instance.primaryFocus?.unfocus();
            if (nextFocusNode != null) {
              FocusScope.of(Get.context as BuildContext)
                  .requestFocus(nextFocusNode);
            }
          } catch (e) {
            CommonHelper.printDebugError(e);
          }
        },
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText.value ? Icons.visibility_off : Icons.remove_red_eye,
            ),
            onPressed: () {
              obscureText.value = !obscureText.value;
            },
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(DimenConstants.buttonCornerRadius),
            ),
          ),
        ),
      ),
    );
  }
}
