import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/sign_in_controller.dart';
import 'package:anugerah_mobile/pages/register/register_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmailSignInPage extends StatelessWidget {
  final c = Get.put(SignInController());
  final illustrationHeight = 700;

  EmailSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppbarWrapper(
      backButtonBackgroundWhite: false,
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setSp(illustrationHeight),
            child: Image.asset(Assets.signInEmailIllustratin),
          ),
          const AppText(
            "Selamat Datang! Senang bertemu kembali!",
            fontSize: 25,
            textAlign: TextAlign.center,
            color: const Color(0xFF15233D),
            fontWeight: FontWeight.bold,
          ),
          PageHelper.buildGap(),
          SizedBox(height: ScreenUtil().setSp(50)),
          _buildFormInput(context),
          PageHelper.buildGap(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppText(
                "Belum terdaftar?  ",
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: _onPressRegister,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                child: const Text("Daftar Sekarang"),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(
              () => ElevatedButton(
                onPressed: !c.isValidEmailSignIn
                    ? null
                    : () => c.onClickLoginEmail(context, asPatient: true),
                child: const Text("Login"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormInput(BuildContext context) {
    const double contentPaddingVal = 35;
    return Column(
      children: [
        TextField(
          controller: c.emailTextEditingController.value,
          onChanged: (value) => c.onChangedValue(InputState.email, value),
          keyboardType: TextInputType.emailAddress,
          style: PageHelper.textStyle(),
          decoration: PageHelper.inputDecoration(
            contentPaddingVal: contentPaddingVal,
          ).copyWith(
            hintText: "Enter your email",
            suffixIcon: PageHelper.suffixIcon(
              isEmpty: c.emailValue.isEmpty,
              callback: () => c.clearValue(InputState.email),
            ),
          ),
        ),
        PageHelper.buildGap(),
        Obx(() => TextField(
              obscureText: c.obscureText.value,
              controller: c.passwordTextEditingController.value,
              onChanged: (value) =>
                  c.onChangedValue(InputState.password, value),
              keyboardType: TextInputType.visiblePassword,
              style: PageHelper.textStyle(),
              decoration: PageHelper.inputDecoration(
                contentPaddingVal: contentPaddingVal,
              ).copyWith(
                hintText: "Enter your password",
                suffixIcon: IconButton(
                  icon: Icon(
                    c.obscureText.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: ColorPalettes.textInputClear,
                  ),
                  onPressed: c.toggleObscureText,
                ),
              ),
            ))
      ],
    );
  }

  void _onPressRegister() {
    Get.to(() => RegisterPage());
  }
}
