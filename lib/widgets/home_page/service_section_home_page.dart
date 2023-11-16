import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/home_page/section_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceSectionHomePage extends SectionHomePage {
  const ServiceSectionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double heightSecondaryMenu = 300;
    double widthImageSecondaryMenu = 150;

    return containerWrapper(
      child: columnWrapper(
        children: [
          buildSectionTitle("Layanan Kami"),
          PageHelper.buildGap(gap),
          rowWrapper(
            children: [
              _buildMenu(
                context,
                title: "Pesan Online",
                path: Assets.dashboardMenuOrder,
                homePageMenu: HomePageMenu.order,
                colors: [
                  const Color(0xFF1FA2FF),
                  const Color(0xFFA6FFCB),
                ],
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Hasil Online",
                path: Assets.dashboardMenuCheckupResult,
                homePageMenu: HomePageMenu.checkupResult,
                colors: [
                  const Color(0xFF1FA2FF),
                  const Color(0xFFA6FFCB),
                ],
              ),
              // _buildMainMenu(context),
            ],
          ),
          PageHelper.buildGap(gap),
          rowWrapper(
            children: [
              _buildMenu(
                context,
                title: "Konsultasi",
                titleColor: Colors.black,
                titleSize: 14,
                path: Assets.dashboardMenuHealthCheckupInquiry,
                homePageMenu: HomePageMenu.healthCheckupInquiry,
                colors: [const Color(0xFFFFEBD1)],
                verticalDirection: VerticalDirection.up,
                heightMenu: heightSecondaryMenu,
                widthImage: widthImageSecondaryMenu,
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Cabang",
                titleColor: Colors.black,
                titleSize: 14,
                path: Assets.dashboardMenuBranch,
                homePageMenu: HomePageMenu.branch,
                colors: [const Color(0xFFDAF4DF)],
                verticalDirection: VerticalDirection.up,
                heightMenu: heightSecondaryMenu,
                widthImage: widthImageSecondaryMenu,
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Berita",
                titleColor: Colors.black,
                titleSize: 14,
                path: Assets.dashboardMenuNews,
                homePageMenu: HomePageMenu.news,
                colors: [const Color(0xFFFFE9EB)],
                verticalDirection: VerticalDirection.up,
                heightMenu: heightSecondaryMenu,
                widthImage: widthImageSecondaryMenu,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildMenu(
    BuildContext context, {
    required String title,
    required HomePageMenu homePageMenu,
    required String path,
    required List<Color> colors,
    Color borderColor = Colors.transparent,
    Color titleColor = Colors.white,
    VerticalDirection verticalDirection = VerticalDirection.down,
    double heightMenu = 500,
    double widthImage = 300,
    double titleSize = 20,
  }) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () => onPressedMenu(homePageMenu),
        child: Container(
          height: ScreenUtil().setSp(heightMenu),
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: colors.length == 1 ? colors.first : null,
            gradient: colors.length > 1
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: colors,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            verticalDirection: verticalDirection,
            children: [
              AppText(
                title,
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
              SizedBox(
                width: ScreenUtil().setSp(widthImage),
                child: Image.asset(path),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
