import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/pages/orders/order_cart_page.dart';
import 'package:anugerah_mobile/pages/orders/order_select_checkup_items_page.dart';
import 'package:anugerah_mobile/pages/orders/orders_page.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class AppCartBadge extends StatelessWidget {
  AppCartBadge({super.key});

  final c = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        const double iconMargin = 30;
        const double rightPadding = 50;

        return Container(
          margin: EdgeInsets.all(ScreenUtil().setSp(iconMargin)),
          padding: EdgeInsets.only(
            right: ScreenUtil().setSp(rightPadding),
          ),
          child: badges.Badge(
            // badgeColor: const Color.fromARGB(255, 204, 58, 55),
            badgeContent: AppText(
              c.currentCartLength,
              fontSize: 10,
              color: Colors.white,
            ),
            // shape: badges.BadgeShape.circle,
            child: Padding(
              padding: EdgeInsets.only(
                right: ScreenUtil().setSp(15),
              ),
              child: InkWell(
                onTap: onPressedHandler,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onPressedHandler() {
    switch (Get.currentRoute) {
      case '/OrderSelectCheckupItemPage':
        if (c.addedCheckupItem.isEmpty) return;
        Get.to(() => OrderCartPage());
        break;
      case '/CheckupItemsCategoryPage':
        Get.back();
        Get.to(() => OrderCartPage());
        break;
      case '/AppHome':
        if (c.selectedBranch.value == null) {
          Get.to(() => const OrdersPage());
          return;
        }
        Get.to(() => OrderSelectCheckupItemPage());
        if (c.addedCheckupItem.isNotEmpty) {
          Get.to(() => OrderCartPage());
        }
        break;
      default:
    }
  }
}
