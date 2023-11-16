import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/pages/register/register_agreement_page.dart';
import 'package:anugerah_mobile/pages/register/register_success_page.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/services/system_config_service.dart';

enum InputState {
  email,
  username,
  password,
  phone,
}

class RegisterController extends BaseController {
  var agreementData = RxString("");
  Rx<TextEditingController> emailTextEditingController =
      Rx<TextEditingController>(TextEditingController());
  var emailValue = RxString("");
  var obscureText = RxBool(true);
  Rx<TextEditingController> passwordTextEditingController =
      Rx<TextEditingController>(TextEditingController());
  var passwordValue = RxString("");
  Rx<TextEditingController> phoneTextEditingController =
      Rx<TextEditingController>(TextEditingController());
  var phoneValue = RxString("");
  var privacyPolicyCheckbox = RxBool(false);
  var privacyPolicyData = "";
  var tncCheckbox = RxBool(false);
  var tncData = "";
  Rx<TextEditingController> usernameTextEditingController =
      Rx<TextEditingController>(TextEditingController());
  var usernameValue = RxString("");

  final _systemConfigService = Get.put(SystemConfigService());
  final _authService = Get.put(AuthService());

  bool get isValidToRegister =>
      tncCheckbox.value &&
      privacyPolicyCheckbox.value &&
      emailValue.isNotEmpty &&
      usernameValue.isNotEmpty &&
      passwordValue.isNotEmpty &&
      phoneValue.isNotEmpty;

  void onChangedValue(InputState inputState, String value) {
    switch (inputState) {
      case InputState.email:
        emailValue(value);
        break;
      case InputState.username:
        usernameValue(value);
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
      case InputState.username:
        usernameValue("");
        usernameTextEditingController.update((val) => val?.clear());
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

  void toggleObscureText() {
    obscureText(!obscureText.value);
  }

  void onPressAgreeButton(AgreementType agreementType) {
    switch (agreementType) {
      case AgreementType.tnc:
        tncCheckbox(true);
        _authService.setIsFirstTime(false);
        break;
      case AgreementType.privacyPolicy:
        privacyPolicyCheckbox(true);
        break;
    }
    Get.close(1);
  }

  Future<void> fetchAgreementData(AgreementType agreementType) async {
    wrapperApiCall(
      Future(() async {
        var res = await _systemConfigService
            .getByKey(_convertToSystemConfigOptions(agreementType));

        agreementData(res.data["data"]);
      }),
      showSuccess: false,
      closePageIfGotException: true,
    );
  }

  Future<void> onPressedRegisterButton(BuildContext context) async {
    await wrapperApiCall(Future(
      () async {
        _validateRegisterPayload();

        var res = await apiService.register(
          username: usernameValue.value,
          email: emailValue.value,
          password: passwordValue.value,
          phone: phoneValue.value,
        );
        await _processAuthResponse(res);
      },
    ));
  }

  SystemConfigOptions _convertToSystemConfigOptions(
      AgreementType agreementType) {
    switch (agreementType) {
      case AgreementType.tnc:
        return SystemConfigOptions.tnc;
      case AgreementType.privacyPolicy:
        return SystemConfigOptions.privacyPolicy;
    }
  }

  void _validateRegisterPayload() {
    if (usernameValue.isEmpty || emailValue.isEmpty || passwordValue.isEmpty) {
      throw Exception("Invalid register payload");
    }
  }

  Future<void> _processAuthResponse(res) async {
    String? accessToken = res.data["accessToken"].toString();
    if (accessToken.isEmpty) {
      throw Exception("Invalid response");
    }

    await _authService.setAuthData(accessToken, true);
    dismissLoading();
    await Get.offAll(() => const RegisterSuccessPage());
  }
}
