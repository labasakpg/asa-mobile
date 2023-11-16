import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/about_us.dart';
import 'package:anugerah_mobile/models/thread.dart';
import 'package:anugerah_mobile/pages/consultations/health_checkup_inquiry_detail_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AppController extends BaseController {
  AboutUs? aboutUs;

  @override
  void onInit() {
    super.onInit();
    _initAboutUs();
  }

  Future<void> _initAboutUs() async {
    String data =
        await DefaultAssetBundle.of(context).loadString(AssetsJson.aboutUs);
    aboutUs = AboutUs.fromJson(jsonDecode(data));
  }

  // Current implementation will only handle HealthCheckupInquiryListPage
  void handleDeepLink(OSNotification osNotification) async {

    var threadRaw = osNotification.additionalData?['thread'];
    if (threadRaw == null) {
      return;
    }

    var thread = Thread.fromJson(Map<String, dynamic>.from(threadRaw));
    Get.to(
      () => HealthCheckupInquiryDetailPage(
        thread: thread,
      ),
    );
  }
}
