import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/sign_in_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';

class EmployeeSignInPage extends StatelessWidget {
  final c = Get.put(SignInController());
  final illustrationHeight = 700;

  EmployeeSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppbarWrapper(
      backButtonBackgroundWhite: false,
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setSp(illustrationHeight),
            child: Image.asset(Assets.signInEmployeeIllustratin),
          ),
          const AppText(
            "Masuk sebagai Karyawan",
            fontSize: 25,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          PageHelper.buildGap(),
          SizedBox(height: ScreenUtil().setSp(50)),
          _buildFormInput(context),
          PageHelper.buildGap(50),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(
              () => ElevatedButton(
                onPressed: !c.isValidEmailSignIn ? null : () => c.onClickLoginEmail(context, asPatient: false),
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
              onChanged: (value) => c.onChangedValue(InputState.password, value),
              keyboardType: TextInputType.visiblePassword,
              style: PageHelper.textStyle(),
              decoration: PageHelper.inputDecoration(
                contentPaddingVal: contentPaddingVal,
              ).copyWith(
                hintText: "Enter your password",
                suffixIcon: IconButton(
                  icon: Icon(
                    c.obscureText.value ? Icons.visibility : Icons.visibility_off,
                    color: ColorPalettes.textInputClear,
                  ),
                  onPressed: c.toggleObscureText,
                ),
              ),
            ))
      ],
    );
  }
}
