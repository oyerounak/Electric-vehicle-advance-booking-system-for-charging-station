import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/helpers/user_pref.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/constants/route_constants.dart';
import '../../utils/constants/string_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return CommonScaffold(
      body: Padding(
        padding: const EdgeInsets.all(DimenConstants.mainLayoutPadding),
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
                StringConstants.appName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () async {
      var isLoggedIn = await UserPref.getLoginStatus();
      Get.offAllNamed(isLoggedIn
          ? RouteConstants.dashboardScreen
          : RouteConstants.loginScreen);
    });
  }
}
