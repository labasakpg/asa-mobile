import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/sign_in_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/shared/sign_in/sign_in_wrapper.dart';

class OTPSignInPage extends StatelessWidget {
  final c = Get.put(SignInController());

  OTPSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInWrapper(
      appBarBackgroundAssetPath: Assets.signInAppBarOTP,
      children: [
        const AppText(
          "Selamat Datang! Masukkan Nomor Telepone Aktif Anda?",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        SizedBox(height: ScreenUtil().setSp(22)),
        AppText(
          "Dengan nomor yang valid, Anda dapat mengakses dan mendapatkan layanan ini.",
          fontSize: 14,
          color: ColorPalettes.textSecodary,
        ),
        SizedBox(height: ScreenUtil().setSp(100)),
        Row(
          children: [
            _buildInput(
              2,
              TextField(
                controller: TextEditingController(text: "+62"),
                textAlign: TextAlign.center,
                enabled: false,
                style: PageHelper.textStyle(),
                decoration: PageHelper.inputDecoration(),
              ),
            ),
            SizedBox(width: ScreenUtil().setSp(50)),
            _buildInput(
              7,
              Obx(
                () => TextField(
                  controller: c.phoneTextEditingController.value,
                  onChanged: (value) => c.onChangedValue(InputState.phone, value),
                  keyboardType: TextInputType.phone,
                  style: PageHelper.textStyle(),
                  decoration: PageHelper.inputDecoration().copyWith(
                    hintText: "Contoh: 81XXXXXXXX",
                    suffixIcon: PageHelper.suffixIcon(
                      isEmpty: c.phoneValue.isEmpty,
                      callback: () => c.clearValue(InputState.phone),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setSp(100)),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Obx(() => ElevatedButton(
                onPressed: c.phoneValue.value.length < 5 ? null : () => c.onClickRequestOTPCode(context),
                child: const Text("Kirim Kode OTP"),
              )),
        ),
      ],
    );
  }

  Widget _buildInput(int flex, Widget child) {
    return Expanded(flex: flex, child: child);
  }
}
