import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constants/string_constants.dart';

class CommonDataHolder extends StatelessWidget {
  dynamic widget;
  dynamic dataList;
  dynamic controller;

  Axis? scrollDirection;
  bool? showNoResultFound, isRefreshEnabled;
  Future<void> Function()? onRefresh;

  CommonDataHolder({
    Key? key,
    required this.controller,
    required this.dataList,
    required this.widget,
    this.onRefresh,
    this.scrollDirection,
    this.showNoResultFound,
    this.isRefreshEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isRefreshEnabled != null) {
      if (isRefreshEnabled! == false) {
        return _body();
      } else {
        return _onRefreshBody();
      }
    } else {
      return _onRefreshBody();
    }
  }

  Widget _onRefreshBody() {
    return SizedBox(
      height: Get.height,
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[_body()],
        ),
      ),
    );
  }

  Widget _body() {
    try {
      return Obx(
            () {
          if (controller.isLoading.value) {
            return Center(
              child: SizedBox(
                height: Get.mediaQuery.size.height / 5,
                child: Lottie.asset(
                  StringConstants.loadingLottie,
                  repeat: true,
                ),
              ),
            );
          } else {
            if (dataList.value.isNotEmpty) {
              return widget(dataList.value);
            } else {
              if (showNoResultFound != null) {
                if (showNoResultFound! == true) {
                  return const CustomNoResultScreen();
                } else {
                  return SizedBox(
                    height: Get.height,
                    child: widget(dataList.value),
                  );
                }
              } else {
                return const CustomNoResultScreen();
              }
            }
          }
        },
      );
    } catch (e) {
      if (showNoResultFound != null) {
        if (showNoResultFound == false) {
          return SizedBox(
            height: Get.height,
            child: widget(dataList.value),
          );
        }
      }
      return const CustomNoResultScreen();
    }
  }
}

class CustomNoResultScreen extends StatelessWidget {
  const CustomNoResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Lottie.asset(
              StringConstants.noResultLottie,
              repeat: true,
              fit: BoxFit.contain,
            ),
            const Text(
              "No Result Found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
