import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/state_manager.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';

class AppHomeController extends BaseController {
  var currentPage = RxInt(0);

  ScrollController scrollController = ScrollController();

  void onChangePage(int value) {
    EasyLoading.dismiss();
    currentPage(value);
    scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }
}
