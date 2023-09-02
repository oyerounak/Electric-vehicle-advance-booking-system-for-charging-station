import 'package:flutter/material.dart';

class CardRichText extends StatelessWidget {
  final String boldText, normalText;

  const CardRichText({
    Key? key,
    required this.boldText,
    required this.normalText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: boldText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: normalText,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
