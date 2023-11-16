import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/app_home_controller.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final appHomeController = Get.put(AppHomeController());

  final List<NavigationItem> navigationItems = [
    NavigationItem(path: AssetsSVG.menuHome, label: "HOME"),
    NavigationItem(path: AssetsSVG.menuFAQ, label: "FAQ"),
    NavigationItem(path: AssetsSVG.menuAboutUs, label: "ABOUT US"),
    NavigationItem(path: AssetsSVG.menuHistory, label: "HISTORY"),
    NavigationItem(path: AssetsSVG.menuProfile, label: "PROFILE"),
  ];

  AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    double fontSize = ScreenUtil().setSp(100);

    return Obx(
      () => BottomNavigationBar(
        items: navigationItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: _containerWrapper(path: item.path, label: item.label),
                activeIcon: _containerWrapper(
                  path: item.path,
                  isActive: true,
                  label: item.label,
                ),
                label: item.label,
              ),
            )
            .toList(),
        currentIndex: appHomeController.currentPage.value,
        enableFeedback: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorPalettes.homeIconDefault,
        unselectedItemColor: ColorPalettes.homeIconDefault,
        selectedFontSize: ScreenUtil().setSp(fontSize),
        unselectedFontSize: ScreenUtil().setSp(fontSize),
        onTap: appHomeController.onChangePage,
      ),
    );
  }

  Widget _containerWrapper(
      {bool isActive = false, String path = "", required String label}) {
    double size = 100;
    double padding = 22;
    double bottomMargin = 10;
    Color backgroundColor =
        isActive ? ColorPalettes.appPrimary : Colors.transparent;
    Color? iconColor = isActive ? Colors.white : ColorPalettes.homeIconDefault;
    if (label == "ABOUT US") {
      padding = 10;
      if (isActive) {
        padding = 2;
        path = AssetsSVG.anugerahActive;
        iconColor = null;
        backgroundColor = Colors.transparent;
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: backgroundColor),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConfiguration.radiusAll100),
      ),
      margin: EdgeInsets.only(bottom: ScreenUtil().setSp(bottomMargin)),
      padding: EdgeInsets.all(ScreenUtil().setSp(padding)),
      width: ScreenUtil().setSp(size),
      height: ScreenUtil().setSp(size),
      child: SvgPicture.asset(path, color: iconColor),
    );
  }
}

class NavigationItem {
  final String path;
  final String label;

  NavigationItem({
    required this.path,
    required this.label,
  });
}
