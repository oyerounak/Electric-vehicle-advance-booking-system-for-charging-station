import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';
import '../helpers/common_helper.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode? currentFocusNode, nextFocusNode;
  final TextEditingController textEditingController;
  final TextInputType? keyboardType;
  final String hintText;
  final int? minLines;
  final String? allowedRegex;
  final Color? backgroundColor;
  final IconData? prefixIcon, suffixIcon;
  final bool? isEnabled, readOnly;
  final String? Function(String?)? validatorFunction;
  final void Function()? onTapField;
  final bool? isWrapContent;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.textEditingController,
    this.minLines,
    this.backgroundColor,
    this.prefixIcon,
    this.suffixIcon,
    this.currentFocusNode,
    this.nextFocusNode,
    this.allowedRegex,
    this.keyboardType,
    this.isEnabled,
    this.readOnly,
    this.validatorFunction,
    this.onTapField,
    this.isWrapContent,
  }) : super(key: key);

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
    return TextFormField(
      focusNode: currentFocusNode,
      controller: textEditingController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        if (allowedRegex != null)
          FilteringTextInputFormatter.allow(
            RegExp(allowedRegex!),
          )
      ],
      keyboardType: keyboardType,
      readOnly: readOnly ?? false,
      enabled: isEnabled ?? true,
      validator: validatorFunction,
      minLines: minLines ?? 1,
      maxLines: minLines == null ? 1 : null,
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
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DimenConstants.buttonCornerRadius),
          ),
        ),
      ),
      onTap: onTapField,
    );
  }
}
