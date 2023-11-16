import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/pages/sign_in/pin_sign_in_page.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/services/location_service.dart';
import 'package:anugerah_mobile/utils/service_helper.dart';
import 'package:anugerah_mobile/widgets/app_root.dart';
import 'package:timer_count_down/timer_controller.dart';

enum InputState {
  phone,
  email,
  password,
}

class SignInController extends BaseController {
  final int defaultCountdownInSeconds = 180;
  final authService = Get.put(AuthService());
  final locationService = Get.put(LocationService());

  var phoneValue = RxString("");
  var emailValue = RxString("");
  var passwordValue = RxString("");
  var obscureText = RxBool(true);
  var alreadyRequestOTP = RxBool(false);

  Rx<TextEditingController> phoneTextEditingController =
      Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> pinTextEditingController =
      Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> emailTextEditingController =
      Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> passwordTextEditingController =
      Rx<TextEditingController>(TextEditingController());

  var countdownController =
      Rx<CountdownController>(CountdownController(autoStart: true));

  void toggleObscureText() {
    obscureText(!obscureText.value);
  }

  bool get isValidEmailSignIn =>
      emailValue.value.isNotEmpty && passwordValue.value.isNotEmpty;

  void onChangedValue(InputState inputState, String value) {
    switch (inputState) {
      case InputState.email:
        emailValue(value);
        break;
      case InputState.password:
        passwordValue(value);
        break;
      case InputState.phone:
        phoneValue(value);
        break;
    }
  }

  void clearValue(InputState inputState) {
    switch (inputState) {
      case InputState.email:
        emailValue("");
        emailTextEditingController.update((val) => val?.clear());
        break;
      case InputState.password:
        passwordValue("");
        passwordTextEditingController.update((val) => val?.clear());
        break;
      case InputState.phone:
        phoneValue("");
        phoneTextEditingController.update((val) => val?.clear());
        break;
    }
  }

  Future<void> resetCounterOTP(BuildContext context) async {
    await onClickRequestOTPCode(context, false);

    countdownController.update((val) {
      val?.restart();
    });
  }

  Future<void> onClickRequestOTPCode(
    BuildContext context, [
    bool changeScreen = true,
  ]) async {
    if (phoneValue.value[0] == '0') {
      EasyLoading.showError(
        "Nomor tidak valid",
        duration: const Duration(seconds: 3)
      );
      return;
    }

    if (alreadyRequestOTP.isTrue) {
      Get.to(() => PinSignInPage());
      return;
    }

    wrapperApiCall(
      Future(
        () async {
          await apiService.requestOTP(
            phoneNumber: int.parse(phoneValue.value),
            asPatient: true,
          );

          alreadyRequestOTP(true);
          ServiceHelper.handleLoading(false);
          Get.to(() => PinSignInPage());
        },
      ),
      showSuccess: false,
    );
  }

  Future<void> onCompletedInputPin(String pin, BuildContext context) async {
    wrapperApiCall(Future(
      () async {
        if (pinValidator(pin) != null) throw Exception("Invalid PIN");

        final res = await apiService.signIn(
          phoneNumber: int.parse(phoneValue.value),
          otpCode: pin,
          asPatient: true,
        );
        await _processAuthResponse(res, true);
      },
    ));
  }

  Future<void> onClickLoginEmail(BuildContext context,
      {required bool asPatient}) async {
    wrapperApiCall(Future(() async {
      if (emailValue.isEmpty || passwordValue.isEmpty) {
        throw Exception();
      }

      var location = asPatient ? null : await locationService.constructToLocation();
      final res = await apiService.signIn(
        email: emailValue.value,
        password: passwordValue.value,
        asPatient: asPatient,
        location: location,
      );
      await _processAuthResponse(res, asPatient);
    }));
  }

  String convertToCountdown(double val) {
    var numberFormat = NumberFormat("00");
    var seconds = (val % 60).toInt();
    var minutes = val ~/ 60;

    return "${numberFormat.format(minutes)}:${numberFormat.format(seconds)}";
  }

  String? pinValidator(s) =>
      double.tryParse(s ?? "") == null ? "Invalid PIN" : null;

  Future<void> _processAuthResponse(res, [bool? asPatient]) async {
    String? accessToken = res.data["accessToken"].toString();
    if (accessToken.isEmpty) {
      throw Exception("Invalid response");
    }

    await authService.setAuthData(accessToken, asPatient);
    dismissLoading();
    await Get.to(() => const AppRoot());
  }
}
