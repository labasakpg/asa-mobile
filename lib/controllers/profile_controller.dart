// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';
import 'package:anugerah_mobile/controllers/app_home_controller.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/pages/profile/profile_patients/profile_patients_list_page.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/services/files_service.dart';
import 'package:anugerah_mobile/services/user_service.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';

class ProfilePageController extends BaseController {
  var formKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>("profilPageControllerFormKey"));
  var isLoadingInit = false;
  String? patientId;
  var prevValues = <String, dynamic>{};
  var updatePasswordFormKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>(
          "profilePageControllerUpdatePasswordFormKey"));
  var isEmailNull = RxBool(true);
  var isPasswordNull = RxBool(true);
  var userName = RxString(AppConfiguration.usernameGreetings);
  var photoUrlSlug = RxString("");

  final _userService = Get.put(UserService());
  final _authService = Get.put(AuthService());
  final _appHomeController = Get.put(AppHomeController());
  final _filesService = Get.put(FilesService());

  void init() {
    if (!isLoadingInit) {
      isLoadingInit = true;
      fetchProfileData();
    }
  }

  void onPressedPatientsList() {
    Get.to(() => ProfilePatientsListPage());
  }

  void onPressedSaveButton(BuildContext context) {
    if (!formKey.value.currentState!.validate()) {
      PageHelper.showInvalidInput();
      return;
    }

    wrapperApiCall(
      Future(() async {
        var body = {};

        formKey.value.currentState?.fields.entries.forEach((element) {
          body.putIfAbsent(element.key, () => element.value.value.toString());
        });

        await _userService.updateCurrentProfile({
          ...body,
          // 'gender': PageHelper.convertGenderFrom(body['gender']),
        });

        userName(body['name']);
        await _authService.setWelcomeName(body['name']);
      }),
      successCallback: () {
        Future.delayed(const Duration(seconds: 1), () {
          _appHomeController.onChangePage(0);
        });
      },
    );
  }

  void onPressedChangePasswordButton(BuildContext context) {
    if (!updatePasswordFormKey.value.currentState!.validate()) {
      return;
    }

    wrapperApiCall(
      Future(() async {
        var body = {};

        updatePasswordFormKey.value.currentState?.fields.entries
            .forEach((element) {
          body.putIfAbsent(element.key, () => element.value.value.toString());
        });

        if (body['newPassword'] != body['confirmPassword']) {
          throw const FormatException("Password tidak sama");
        }

        await _userService.updateCurrentPassword(body);
      }),
      showSuccess: false,
      successCallback: () => Get.back(),
    );
  }

  void onPressedDeleteAccountButton(VoidCallback successCallback) {
    Get.defaultDialog(
      onConfirm: () {
        Get.back();
        wrapperApiCall(
          Future(() async {
            await _userService.changeStatus({"status": "INACTIVE"});
          }),
          successCallback: successCallback,
        );
      },
      textConfirm: "Setuju",
      confirmTextColor: Colors.white,
      onCancel: () {},
      textCancel: "Batal",
      middleText: "Apakah anda yakin akan menghapus akun anda?",
      title: "Konfirmasi Penghapusan Akun",
    );
  }

  Future fetchProfileData() async {
    wrapperApiCall(
      Future(() async {
        var res = await _userService.getCurrentProfile();

        Map<String, dynamic> personalData =
            res.data['personalData'] ?? res.data;
        personalData.removeWhere((key, value) => value == null);

        if (res.data['patientId'] != null) {
          patientId = res.data['patientId'];
        }

        prevValues = {
          ...personalData,
        };

        if (personalData.containsKey('dateOfBirth')) {
          prevValues = {
            ...prevValues,
            'dateOfBirth': DateTime.parse(personalData['dateOfBirth']),
          };
        }

        formKey.update((form) {
          form!.currentState?.patchValue(prevValues);
        });

        if (prevValues['email'] != null) {
          isEmailNull(false);
        }
        if (res.data['password'] != null) {
          isPasswordNull(false);
        }

        userName(prevValues['name'] ?? AppConfiguration.usernameGreetings);
        if (prevValues['photo'] != null) {
          photoUrlSlug(prevValues['photo']['slug'] ?? "");
        }
        await _authService.setWelcomeName(prevValues['name']);
      }),
      finallyCallback: () => isLoadingInit = false,
      skipInitLoading: true,
      showSuccess: false,
    );
  }

  void selectAndUploadPhotoProfile() async {
    var source = await PageHelper.getImageSourceWithDialog(context);
    if (source == null) {
      return;
    }

    final XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      wrapperApiCall(
        Future(() async {
          var res = await _filesService.upload(
            filePath: file.path,
            filename: file.name,
          );
          await _userService.updateCurrentProfile({
            "photoSlug": res.data,
          });
          if (res.data != null) {
            Get.back();
            Future.delayed(
              const Duration(seconds: 1),
              () => photoUrlSlug(res.data),
            );
          }
        }),
      );
    }
  }
}
