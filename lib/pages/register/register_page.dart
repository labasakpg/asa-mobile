import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/register_controller.dart';
import 'package:anugerah_mobile/pages/register/register_agreement_page.dart';
import 'package:anugerah_mobile/pages/sign_in/otp_sign_in_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';
import 'package:anugerah_mobile/widgets/divider_with_label.dart';

class RegisterPage extends StatelessWidget {
  final c = Get.put(RegisterController());
  final illustrationHeight = 400;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppbarWrapper(
      backButtonBackgroundWhite: false,
      child: Column(
        children: [
          PageHelper.buildGap(50),
          SizedBox(
            height: ScreenUtil().setSp(illustrationHeight),
            child: Image.asset(Assets.registerIllustration),
          ),
          PageHelper.buildGap(),
          const AppText(
            "Lengkapi Pendaftaran!",
            fontSize: 25,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          PageHelper.buildGap(),
          _buildFormInput(context),
        ],
      ),
    );
  }

  Widget _buildInput({
    required BuildContext context,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required bool isEmpty,
    required VoidCallback callback,
    TextInputType? keyboardType,
    String? hintText,
    bool enabled = true,
    TextAlign textAlign = TextAlign.left,
  }) {
    const double contentPaddingVal = 35;

    return TextField(
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textAlign: textAlign,
      style: PageHelper.textStyle(),
      decoration: PageHelper.inputDecoration(
        contentPaddingVal: contentPaddingVal,
      ).copyWith(
        hintText: hintText,
        suffixIcon: PageHelper.suffixIcon(
          isEmpty: isEmpty,
          callback: callback,
        ),
      ),
    );
  }

  Widget _buildFormInput(BuildContext context) {
    const double contentPaddingVal = 35;
    const double hPadding = 20;

    return Obx(() => Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildInput(
                    context: context,
                    controller: TextEditingController(text: "+62"),
                    onChanged: (value) {},
                    enabled: false,
                    callback: () {},
                    isEmpty: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: ScreenUtil().setSp(50)),
                Expanded(
                  flex: 7,
                  child: _buildInput(
                    context: context,
                    controller: c.phoneTextEditingController.value,
                    onChanged: (value) => c.onChangedValue(InputState.phone, value),
                    isEmpty: c.phoneValue.isEmpty,
                    callback: () => c.clearValue(InputState.phone),
                    keyboardType: TextInputType.phone,
                    hintText: "Phone No.",
                  ),
                ),
              ],
            ),
            PageHelper.buildGap(),
            _buildInput(
              context: context,
              controller: c.usernameTextEditingController.value,
              onChanged: (value) => c.onChangedValue(InputState.username, value),
              isEmpty: c.usernameValue.isEmpty,
              callback: () => c.clearValue(InputState.username),
              keyboardType: TextInputType.name,
              hintText: "Username",
            ),
            PageHelper.buildGap(),
            _buildInput(
              context: context,
              controller: c.emailTextEditingController.value,
              onChanged: (value) => c.onChangedValue(InputState.email, value),
              isEmpty: c.emailValue.isEmpty,
              callback: () => c.clearValue(InputState.email),
              keyboardType: TextInputType.emailAddress,
              hintText: "example@mail.com",
            ),
            PageHelper.buildGap(),
            TextField(
              obscureText: c.obscureText.value,
              controller: c.passwordTextEditingController.value,
              onChanged: (value) => c.onChangedValue(InputState.password, value),
              keyboardType: TextInputType.visiblePassword,
              style: PageHelper.textStyle(),
              decoration: PageHelper.inputDecoration(
                contentPaddingVal: contentPaddingVal,
              ).copyWith(
                hintText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    c.obscureText.value ? Icons.visibility : Icons.visibility_off,
                    color: ColorPalettes.textInputClear,
                  ),
                  onPressed: c.toggleObscureText,
                ),
              ),
            ),
            PageHelper.buildGap(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAggreementButton(
                  label: "Terms & Conditions",
                  value: c.tncCheckbox.value,
                  onPressed: _onPressedTnCButton,
                ),
                _buildAggreementButton(
                  label: "Privacy Policy",
                  value: c.privacyPolicyCheckbox.value,
                  onPressed: _onPressedPrivacyPolicy,
                ),
              ],
            ),
            PageHelper.buildGap(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: c.isValidToRegister ? () => c.onPressedRegisterButton(context) : null,
                child: const Text("Setuju dan Daftar"),
              ),
            ),
            DividerWithLabel(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(25)),
              label: "Or Login with",
              height: 10,
              fontSize: 12,
              horizontalPadding: hPadding,
              color: ColorPalettes.primaryBlack,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onPressedLoginUsingWhatsapp,
                child: const Text("Login Dengan Whatsapp"),
              ),
            ),
          ],
        ));
  }

  Widget _buildAggreementButton({
    required String label,
    required bool value,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
      onPressed: onPressed,
      child: Row(
        children: [
          Checkbox(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value,
            onChanged: (value) => onPressed(),
          ),
          AppText(label, color: ColorPalettes.primaryBlack),
        ],
      ),
    );
  }

  _onPressedTnCButton() {
    Get.to(() => const RegisterAgreementPage(agreementType: AgreementType.tnc));
  }

  _onPressedPrivacyPolicy() {
    Get.to(() => const RegisterAgreementPage(agreementType: AgreementType.privacyPolicy));
  }

  _onPressedLoginUsingWhatsapp() {
    Get.close(2);
    Get.to(() => OTPSignInPage());
  }
}
