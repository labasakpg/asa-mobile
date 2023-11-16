import 'package:anugerah_mobile/bases/app_home_base.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_cart_badge.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/home_page/news_section_home_page.dart';
import 'package:anugerah_mobile/widgets/home_page/promo_section_home_page.dart';
import 'package:anugerah_mobile/widgets/home_page/service_section_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget implements AppHomeBase {
  HomePage({super.key});

  final _authService = Get.put(AuthService());

  @override
  Widget actionButton() => AppCartBadge();

  @override
  Widget appBar() {
    String name = _authService.welcomeName;

    return PageHelper.disableVerticalDrag(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(ScreenUtil().setSp(50))),
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(Assets.dashboardAppbarBackground),
              ),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: SizedBox(
                  width: ScreenUtil().setSp(200),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setSp(30)),
                    child: Image.asset(Assets.dashboardanugerahLogo),
                  ),
                ),
                title: AppText(
                  "Hai, $name\nSenang bertemu anda kembali",
                  textAlign: TextAlign.right,
                  color: const Color(0xFF15233D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Color? backgroundColor() => null;

  @override
  List<Widget> children(BuildContext context) => [
        PageHelper.buildGap(),
        PromoSectionHomePage(),
        const ServiceSectionHomePage(),
        PageHelper.buildGap(50),
        NewsSectionHomePage(),
      ];

  @override
  double expandedHeight() => 325;

  @override
  double? hPrefeeredSize() => null;

  @override
  String pageName() {
    return "home";
  }

  @override
  bool? removeAppBar() => null;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Widget? contentWrapper(BuildContext context) => null;
}
