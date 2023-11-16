import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/pages/sign_in/email_sign_in_page.dart';
import 'package:anugerah_mobile/pages/sign_in/employee_sign_in_page.dart';
import 'package:anugerah_mobile/pages/sign_in/otp_sign_in_page.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_logo.dart';
import 'package:anugerah_mobile/widgets/divider_with_label.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final double _hButtonsPlaceholder = ScreenUtil().setSp(700);
  final double _hButton = ScreenUtil().setSp(150);
  final double _hDividerLabel = ScreenUtil().setSp(10);
  final double _vPadding = ScreenUtil().setSp(10);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.signInBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: ScreenUtil().screenHeight - ScreenUtil().setHeight(800),
              child: const AppLogo(
                onlyLogo: true,
                fullLogo: true,
              ),
            ),
            _buildButtonsPlaceholder(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsPlaceholder(BuildContext context) {
    return SizedBox(
      height: _hButtonsPlaceholder,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: Colors.white30,
          borderRadius: BorderRadius.only(
            topLeft: AppConfiguration.radiusCircular75,
            topRight: AppConfiguration.radiusCircular75,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PageHelper.buildGap(50),
              _buidWithPadding(
                children: Container(
                  padding: AppConfiguration.horizontalPadding50,
                  width: double.infinity,
                  height: _hButton,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalettes.appPrimary,
                    ),
                    icon: const Icon(Icons.phone_android),
                    label: const Text("Login Dengan WhatsApp"),
                    onPressed: onPressedSignInWithWA,
                  ),
                ),
              ),
              _buidWithPadding(
                children: DividerWithLabel(
                  label: "Or Login with",
                  height: _hDividerLabel,
                  horizontalPadding:
                      AppConfiguration.horizontalPadding50.horizontal,
                ),
              ),
              _buidWithPadding(
                children: Container(
                  padding: AppConfiguration.horizontalPadding50,
                  width: double.infinity,
                  height: _hButton,
                  child: ElevatedButton.icon(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                    ),
                    icon: const Icon(Icons.inbox, color: Colors.black),
                    label: const Text(
                      "Login Dengan Email",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: onPressSignInWithEmail,
                  ),
                ),
              ),
              _buidWithPadding(
                children: TextButton(
                  onPressed: onPressedSignInAsEmployee,
                  child: const Text(
                    "Login Karyawan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              PageHelper.buildGap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buidWithPadding({Widget? children}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _vPadding),
      child: children,
    );
  }

  void onPressedSignInWithWA() {
    Get.to(() => OTPSignInPage());
  }

  void onPressSignInWithEmail() {
    Get.to(() => EmailSignInPage());
  }

  void onPressedSignInAsEmployee() {
    Get.to(() => EmployeeSignInPage());
  }
}
