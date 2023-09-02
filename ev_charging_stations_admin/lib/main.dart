import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'utils/constants/route_constants.dart';
import 'utils/helpers/route_screens.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EV Charging Stations',
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(platform: TargetPlatform.android),
      initialRoute: RouteConstants.splashScreen,
      getPages: RouteScreen.routes,
    );
  }
}
