import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/helpers/common_helper.dart';

class FadeTransitionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController? animationController;
  late Animation<double> fadeInFadeOut;

  @override
  void onInit() {
    super.onInit();
    animationController = null;
    fadeInFadeOut = const AlwaysStoppedAnimation<double>(1);
    try {
      startAnimation();
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  void startAnimation() {
    try {
      if(animationController!=null){
        animationController!.dispose();
      }
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        animationBehavior: AnimationBehavior.preserve,
      );
      fadeInFadeOut = Tween<double>(
        begin: 0.0,
        end: 1,
      ).animate(animationController!);

      animationController?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController?.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController?.forward();
        }
      });
      animationController?.forward();
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  void stopAnimation() {
    try {
      animationController?.stop();
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      animationController?.dispose();
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }
}
