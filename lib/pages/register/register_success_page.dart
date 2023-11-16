import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_root.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppbarWrapper(
      backButtonBackgroundWhite: false,
      child: Column(
        children: [
          PageHelper.buildGap(350),
          SizedBox(
            height: ScreenUtil().setSp(700),
            child: SvgPicture.asset(AssetsSVG.commonsRegisterSuccess),
          ),
          const AppText(
            "Selamat Bergbung",
            fontSize: 25,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          AppText(
            "Pendaftaran telah sukses. Silakan lanjutkan dan\nlengkapi halaman profil Anda",
            textAlign: TextAlign.center,
            color: ColorPalettes.textHint,
            fontSize: 12,
          ),
          PageHelper.buildGap(200),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalettes.appPrimary,
              ),
              onPressed: _onPressedContinueButton,
              child: const Text("Mulai Sekarang"),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressedContinueButton() async {
    await Get.offAll(() => const AppRoot());
  }
}
