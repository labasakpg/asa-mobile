import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/pages/sign_in/sign_in_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: OnBoardingSlider(
        onFinish: _onFinishHandler,
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Get Started',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: ColorPalettes.appPrimary,
        ),
        skipTextButton: AppText(
          "Lewati",
          color: ColorPalettes.appPrimary,
        ),
        background: [
          _buildBackground(AssetsSVG.onBoarding1),
          _buildBackground(AssetsSVG.onBoarding2, top: 125),
          _buildBackground(AssetsSVG.onBoarding3),
        ],
        totalPage: 3,
        speed: 1.8,
        pageBodies: [
          _buildPageBody(
            title: "Kemudahan\nAkses Informasi",
            subTitle:
                "Lab Anugerah memberikan kemudahan\nakses informasi berita, promo dan\nlokasi cabang",
          ),
          _buildPageBody(
            title: "Konsultasi Mobile",
            subTitle: "Kemudahan pesan pemeriksaan via\naplikasi mobile",
          ),
          _buildPageBody(
            title: "Hasil Online",
            subTitle:
                "Temukan kemudahan akses untuk melihat\nHasil Online pasien",
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(String asset, {double top = 175}) {
    return Container(
      width: ScreenUtil().screenWidth,
      padding: EdgeInsets.only(
        top: ScreenUtil().setSp(top),
        bottom: ScreenUtil().setSp(175),
        left: ScreenUtil().setSp(150),
        right: ScreenUtil().setSp(150),
      ),
      child: SvgPicture.asset(asset),
    );
  }

  _buildPageBody({required String title, required String subTitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setSp(1050),
          ),
          AppText(
            title,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            lineHeight: 1,
          ),
          PageHelper.buildGap(),
          AppText(
            subTitle,
            color: ColorPalettes.orderCheckoutSubSectionTitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _onFinishHandler() {
    Get.offAll(() => const SignInPage());
  }
}
