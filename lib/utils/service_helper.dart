import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ServiceHelper {
  ServiceHelper._();

  static void unfocus([BuildContext? context]) {
    context ??= Get.context;

    if (context == null) {
      if (kDebugMode) {
        print("context cannot be null");
      }
      return;
    }

    FocusScope.of(context).unfocus();
  }

  static Future<void> handleDioException(DioException e) async {
    if (kDebugMode) {
      print('DioError: $e');
    }
    await handleGeneralException(
        (e.response?.data["message"]?.toString() ?? e.error) as String?);
  }

  static Future<void> handleFormatException(FormatException e) async {
    await handleGeneralException(e.message);
  }

  static Future<void> handleHttpException(HttpException e) async {
    await handleGeneralException(e.message);
  }

  static Future<void> handleGeneralException(String? message) async {
    showError(message);
  }

  static Future<void> handleException(Object e) async {
    if (kDebugMode) {
      print('Error: $e');
    }
    showError(e);
  }

  static Future<void> handleLoading([bool show = true]) async {
    if (show) {
      await EasyLoading.show(
          status: 'Loading', maskType: EasyLoadingMaskType.black);
    } else {
      await EasyLoading.dismiss();
    }
  }

  static void showError(Object? error) {
    var context = Get.context;
    if (context != null) {
      EasyLoading.showError(
        'Terjadi Kesalahan.\n$error',
        duration: const Duration(seconds: 3)
      );
    }
    EasyLoading.dismiss();
  }
}
