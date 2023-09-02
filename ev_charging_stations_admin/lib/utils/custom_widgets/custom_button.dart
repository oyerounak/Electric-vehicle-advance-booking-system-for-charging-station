import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onButtonPressed;
  final FocusNode? currentFocusNode;
  final bool? isWrapContent;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onButtonPressed,
    this.currentFocusNode,
    this.isWrapContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    if (isWrapContent!= null) {
      if (isWrapContent == true) {
        return SizedBox(child: _elevatedButton());
      }
    }
    return Container(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      padding: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: Get.size.width * 0.8,
          height: 50,
        ),
        child: _elevatedButton(),
      ),
    );
  }

  Widget _elevatedButton() {
    return ElevatedButton(
      focusNode: currentFocusNode,
      child: Text(
        buttonText.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor:
        MaterialStateProperty.all<Color>(Get.theme.primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(DimenConstants.buttonCornerRadius),
            side: BorderSide(color: Get.theme.primaryColor),
          ),
        ),
      ),
      onPressed: () => onButtonPressed(),
    );
  }
}
