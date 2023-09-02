import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final Widget body;

  const CommonScaffold({
    Key? key,
    this.appBar,
    this.floatingActionButton,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: body,
        ),
      ),
    );
  }
}
