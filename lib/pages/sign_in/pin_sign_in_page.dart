import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/sign_in_controller.dart';
import 'package:anugerah_mobile/widgets/app_divider.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/shared/sign_in/sign_in_wrapper.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PinSignInPage extends StatelessWidget {
  final c = Get.put(SignInController());

  PinSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    _init();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: ColorPalettes.textInputOTP,
      ),
    );

    return SignInWrapper(
      appBarBackgroundAssetPath: Assets.signInAppBarPin,
      children: [
        Obx(
          () => AppText(
            "Masukkan 6-digit kode yang telah kami kirimkan ke Nomor Whatsapp \n0${c.phoneValue()}",
            fontSize: 16,
            letterSpacing: 1.5,
            textAlign: TextAlign.center,
            width: double.infinity,
          ),
        ),
        const AppDivider(height: 50),
        Pinput(
          controller: c.pinTextEditingController.value,
          length: 6,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          validator: c.pinValidator,
          onCompleted: (value) => c.onCompletedInputPin(value, context),
        ),
        const AppDivider(height: 100),
        const AppText(
          "Belum menerima kode OTP?",
          fontSize: 16,
          letterSpacing: 1.5,
          width: double.infinity,
        ),
        Countdown(
          controller: c.countdownController.value,
          seconds: c.defaultCountdownInSeconds,
          build: (_, time) => Container(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: time > 0 ? null : () => c.resetCounterOTP(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Text("Permintaan kode baru ${c.convertToCountdown(time)}"),
            ),
          ),
        ),
      ],
    );
  }

  void _init() {
    c.pinTextEditingController.update((val) => val?.clear());
  }
}
