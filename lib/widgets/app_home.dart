import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/bases/app_home_base.dart';
import 'package:anugerah_mobile/controllers/app_home_controller.dart';
import 'package:anugerah_mobile/pages/about_us/about_us_page.dart';
import 'package:anugerah_mobile/pages/faqs/faqs_page.dart';
import 'package:anugerah_mobile/pages/home/home_employee_page.dart';
import 'package:anugerah_mobile/pages/home/home_page.dart';
import 'package:anugerah_mobile/pages/profile/profile_page.dart';
import 'package:anugerah_mobile/pages/register/register_agreement_page.dart';
import 'package:anugerah_mobile/pages/transactions/transactions_page.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/services/location_service.dart';
import 'package:anugerah_mobile/widgets/app_bottom_navigation_bar.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {

  final authService = Get.put(AuthService());
  final locationService = Get.put(LocationService());
  final appHomeController = Get.put(AppHomeController());

  @override
  void initState() {
    super.initState();
    showTnCDialog();
  }

  Future<void> showTnCDialog() async {
    final bool isFirstTime = await authService.isFirstTime();
    if (isFirstTime) {
      Future.delayed(const Duration(seconds: 1), () {
        showDialog(
          context: context,
          builder: (context) {
            return const RegisterAgreementPage(
              agreementType: AgreementType.tnc,
              previewMode: false,
            );
          }
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isPatient && locationService.isLocationEnabled.isFalse) {
      locationService.getLocation().then(locationService.updatePeriodically);
    }

    return Obx(() {
      return _getAppHomeBase().contentWrapper(context) ??
        AppbarWrapper(
          topSafeArea: false,
          useDashboardAppbar: true,
          useCustomeAppbar: true,
          expandedHeight: _getAppHomeBase().expandedHeight(),
          customeAppBarFlexibleSpace: _getAppHomeBase().appBar(),
          bottomNavigationBar: AppBottomNavigationBar(),
          actions: [_getAppHomeBase().actionButton()],
          backgroundColor: _getAppHomeBase().backgroundColor(),
          removeAppBar: _getAppHomeBase().removeAppBar(),
          scrollController: appHomeController.scrollController,
          hideLeading: true,
          hPrefeeredSize: _getAppHomeBase().hPrefeeredSize() ?? 100,
          children: _getAppHomeBase().children(context),
        );
    });
  }

  AppHomeBase _getAppHomeBase() {
    switch (appHomeController.currentPage.value) {
      case 1:
        return FaqsPage();
      case 2:
        return AboutUsPage();
      case 3:
        return TransactionsPage();
      case 4:
        return ProfilePage(hideEditIcon: false);
      case 0:
      default:
        if (!isPatient) {
          return HomeEmployeePage();
        }
        return HomePage();
    }
  }

  bool get isPatient => authService.authData.value?.user?.asPatient ?? false;
}
