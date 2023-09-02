import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;

import '../constants/api_constants.dart';
import '../helpers/common_helper.dart';
import 'logging_interceptors.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
      validateStatus: (status) {
        return status! < 500;
      },
      headers: {
        "Content-Type": "application/json; charset=UTF-8'",
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods':
            'GET, POST, OPTIONS, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'X-Requested-With,content-type',
      },
      connectTimeout: 60 * 1000,
      receiveTimeout: 60 * 1000))
    ..interceptors.add(LoggingInterceptor());

  static Future<dynamic> postGetData(String url, {dynamic body}) async {
    var jsonResponse = [];

    try {
      Response response = await request(
        url,
        body: body,
        method: ApiConstants.post,
      );
      if (response.statusCode == 200) {
        var data = response.data;
        if (data["status"] != "no" &&
            data["status"] != "false" &&
            data["status"] != "error") {
          for (int i = 0; i < data["Data"].length; i++) {
            jsonResponse.add(data["Data"][i]);
          }
        }
        if (jsonResponse.isNotEmpty) {
          return jsonResponse;
        } else {
          return jsonResponse;
        }
      } else {
        get_x.Get.snackbar(
            "ERROR", "Something went wrong. Please try again later'",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on DioError catch (e) {
      CommonHelper.printDebugError(e);
      var error = handleError(e);
      get_x.Get.snackbar("ERROR", error,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    return jsonResponse;
  }

  static Future<dynamic> postGetStatus(String url, {dynamic body}) async {
    var jsonResponse = [];

    try {
      Response response =
          await request(url, body: body, method: ApiConstants.post);
      if (response.statusCode == 200) {
        var data = response.data;
        jsonResponse.add(data["status"]);
        if (jsonResponse.isNotEmpty) {
          return jsonResponse;
        } else {
          return jsonResponse;
        }
      } else {
        get_x.Get.snackbar(
            "ERROR", "Something went wrong. Please try again later'",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on DioError catch (e) {
      var error = handleError(e);
      get_x.Get.snackbar("ERROR", error,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return jsonResponse;
  }

  static Future<dynamic> postLoginAndGetData(String url, {dynamic body}) async {
    var jsonResponse = [];

    try {
      Response response =
          await request(url, body: body, method: ApiConstants.post);
      if (response.statusCode == 200) {
        var data = response.data;

        if (data["status"] == "ok") {
          for (int i = 0; i < data["Data"].length; i++) {
            jsonResponse.add(data["Data"][i]);
          }
        } else {
          jsonResponse.add(data);
        }
        return jsonResponse;
      } else {
        get_x.Get.snackbar(
            "ERROR", "Something went wrong. Please try again later'",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on DioError catch (e) {
      CommonHelper.printDebugError(e);
      var error = handleError(e);
      get_x.Get.snackbar("ERROR", error,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    return jsonResponse;
  }

  static Future<Response> request(String url,
      {dynamic body, String? method}) async {
    var res = _dio.request(url,
        data: json.encode(body),
        options: Options(
          contentType: Headers.jsonContentType,
          method: method,
        ));
    return res;
  }
}

handleError(DioError error) {
  if (kDebugMode) {
    print(error.response.toString());
  }

  if (error.message.contains('SocketException')) {
    return 'Cannot connect. Check that you have internet connection';
  }

  if (error.type == DioErrorType.connectTimeout) {
    return 'Connection timed out. Please retry.';
  }

  if (error.response == null || error.response!.data is String) {
    return 'Something went wrong. Please try again later';
  }
  return 'Something went wrong. Please try again later';
}
