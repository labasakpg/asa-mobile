import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/app_controller.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/controllers/profile_controller.dart';
import 'package:anugerah_mobile/pages/loading_page.dart';
import 'package:anugerah_mobile/pages/on_boarding/on_boarding_page.dart';
import 'package:anugerah_mobile/services/api_service.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/widgets/app_home.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final authService = Get.put(AuthService());
  final apiService = Get.put(ApiService());
  final appController = Get.put(AppController());
  final orderController = Get.put(OrderController());
  final profileController = Get.put(ProfilePageController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), _callback);
    return const LoadingPage();
  }

  FutureOr _callback() {
    if (authService.authData.value != null) {
      profileController.init();
      Get.offAll(() => AppHome());
    } else {
      Get.offAll(() => const OnBoardingPage());
    }
  }
}
