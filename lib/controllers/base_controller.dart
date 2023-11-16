import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/services/api_service.dart';
import 'package:anugerah_mobile/utils/service_helper.dart';
import 'package:anugerah_mobile/widgets/app_home.dart';

class BaseController extends GetxController {
  late BuildContext _context;
  late ApiService apiService;

  BaseController() {
    apiService = Get.find<ApiService>();
    _context = Get.context!;
  }

  BuildContext get context => _context;

  Future<void> wrapperApiCall(
    Future callback, {
    bool showSuccess = true,
    bool skipInitLoading = false,
    bool closePageIfGotException = false,
    int closePageDelay = 1,
    VoidCallback? successCallback,
    VoidCallback? errCallback,
    VoidCallback? finallyCallback,
    String? overrideErrMessage,
  }) async {
    try {
      ServiceHelper.unfocus(_context);
      if (!skipInitLoading) await ServiceHelper.handleLoading();

      await callback;

      if (showSuccess) {
        EasyLoading.showSuccess("Success");
      } else {
        EasyLoading.dismiss();
      }
      successCallback?.call();
    } on DioException catch (e) {
      errCallback?.call();
      if (overrideErrMessage != null) {
        await ServiceHelper.handleGeneralException(overrideErrMessage);
      } else {
        await ServiceHelper.handleDioException(e);
      }
      _handleClosePageIfGotException(closePageIfGotException, 1);
    } on HttpException catch (e) {
      errCallback?.call();
      await ServiceHelper.handleHttpException(e);
      _handleClosePageIfGotException(closePageIfGotException, 1);
    } on FormatException catch (e) {
      errCallback?.call();
      await ServiceHelper.handleFormatException(e);
      _handleClosePageIfGotException(closePageIfGotException, 1);
    } catch (e) {
      errCallback?.call();
      await ServiceHelper.handleException(e);
      _handleClosePageIfGotException(closePageIfGotException, 1);
    } finally {
      finallyCallback?.call();
    }
  }

  void _handleClosePageIfGotException(bool closePageIfGotException, int delay) {
    if (closePageIfGotException) {
      Future.delayed(
        Duration(seconds: delay),
        () => Get.back(),
      );
    }
  }

  void dismissLoading() => EasyLoading.dismiss();

  void errCallback() {
    Get.off(() => AppHome());
  }

  void closeKeyboard() {
    var context = Get.context;
    if (context != null) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}
