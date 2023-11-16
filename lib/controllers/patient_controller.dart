import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/personal_data.dart';
import 'package:anugerah_mobile/models/relative.dart';
import 'package:anugerah_mobile/models/title_option.dart';
import 'package:anugerah_mobile/pages/profile/profile_patients/profile_patients_list_page.dart';
import 'package:anugerah_mobile/services/master_service.dart';
import 'package:anugerah_mobile/services/relatives_service.dart';
import 'package:anugerah_mobile/services/user_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/utils/service_helper.dart';

class PatienController extends BaseController {
  static const double defaultHeightInputField = 275;
  static const double defaultErrorHeightInputField = 350;
  var formKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>("patienController"));
  var includePatienData = false;
  RxList<String> titleOptions = RxList.empty();
  RxList<Relative> listData = RxList.empty(growable: true);
  RxDouble heightNameInput = RxDouble(defaultHeightInputField);
  var noRegValue = RxString("");
  var isLoadingInit = RxBool(false);
  var isLoadingTitles = RxBool(false);
  var isUser = RxBool(false);

  PersonalData? _personalData;
  final RelativesService _service = Get.put(RelativesService());
  final UserService _userService = Get.put(UserService());
  final MasterService _masterService = Get.put(MasterService());

  void init() {
    fetchData();
  }

  void fetchData() {
    if (isLoadingInit.isFalse) {
      isLoadingInit(true);

      wrapperApiCall(
        Future(() async {
          final res = await _service.getAll();
          final resData = Relative.toList(res.data);

          if (resData.isNotEmpty) {
            listData.clear();
            listData.addAll(resData);
          }
        }),
        finallyCallback: () => isLoadingInit(false),
        showSuccess: false,
        skipInitLoading: true,
        closePageIfGotException: true,
      );
    }
  }

  void removeRelative(Relative relative) {
    if (isLoadingInit.isFalse) {
      isLoadingInit(true);

      wrapperApiCall(
        Future(() async {
          await _service.removeRelative(relative.id!);
        }),
        finallyCallback: () {
          isLoadingInit(false);
          init();
        },
        closePageIfGotException: true,
      );
    }
  }

  void onPressedSubmit(Relative? relative) {
    if (!formKey.value.currentState!.validate()) {
      bool nameHasError = formKey.value.currentState!.fields["name"]!.hasError;
      bool titleHasError =
          formKey.value.currentState!.fields["title"]!.hasError;
      if (nameHasError || titleHasError) {
        heightNameInput(defaultErrorHeightInputField);
      } else {
        heightNameInput(defaultHeightInputField);
      }

      PageHelper.showInvalidInput();
      return;
    }

    if (relative == null || relative.id == null) {
      return _processCreateRelative();
    }

    if (relative.id == 0) {
      return _processUpdateUserProfile();
    } else {
      return _processUpdateRelative(relative.id!);
    }
  }

  void updateFormByPersonalData(
    PersonalData? personalData, [
    Relative? relative,
  ]) async {
    isLoadingTitles(true);
    heightNameInput = RxDouble(defaultHeightInputField);
    await _getTitleOptions();

    if (relative != null && relative.id == 0) {
      isUser(true);
    } else {
      isUser(false);
    }

    if (personalData == null) {
      isLoadingTitles(false);
      return;
    }
    _personalData = personalData;

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        var prevValues = <String, dynamic>{
          ...personalData.toJson(),
          // 'gender': PageHelper.convertGenderTo(personalData.gender),
          'dateOfBirth': DateTime.parse(
              personalData.dateOfBirth ?? DateTime.now().toString()),
          'ktp': personalData.ktp == null || personalData.ktp == 'null'
              ? ''
              : personalData.ktp,
        };

        formKey.update((form) {
          form!.currentState?.patchValue(prevValues);
        });
      },
    );

    isLoadingTitles(false);
  }

  void onPressedCheckPatientData(BuildContext context) {
    ServiceHelper.unfocus(context);
    final patientData = _getPatienData();
    if (patientData.isEmpty) return;

    wrapperApiCall(
      Future(() async {
        final res = await _service.checkPatient(
          noReg: patientData[0],
          pin: patientData[1],
        );
        if (res.data['personalData'] != null) {
          final personalData = PersonalData.fromJson(res.data['personalData']);
          updateFormByPersonalData(personalData);
          EasyLoading.showSuccess("Berhasil mendapatkan data");
          includePatienData = true;
        } else {
          EasyLoading.showInfo("Tidak dapat menghubungkan data");
          includePatienData = false;
        }
      }),
      showSuccess: false,
    );
  }

  void onPressedConnectPatientData(BuildContext context, int? relativeId) {
    final patienData = _getPatienData();
    if (patienData.isEmpty || relativeId == null) return;
    ServiceHelper.unfocus(context);

    Get.dialog(AlertDialog(
      title: const Text("Apakah anda yakin menghubungkan?"),
      content:
          const Text("Data Pasien akan menyesuaikan dengan perubahan terakhir"),
      actions: [
        TextButton(
          onPressed: () => Get.close(1),
          child: const Text("Tidak"),
        ),
        ElevatedButton(
          onPressed: () => _processConnectPatienData(context, relativeId),
          child: const Text("Lanjutkan"),
        ),
      ],
    ));
  }

  bool _validatePatienData() {
    String? noReg = formKey.value.currentState?.fields['noReg']!.value;
    String? pin = formKey.value.currentState?.fields['pin']!.value;
    if (noReg == null || noReg.isEmpty || pin == null || pin.isEmpty) {
      EasyLoading.showError("No. Reg. dan PIN tidak boleh kosong");
      return false;
    }

    return true;
  }

  List<String> _getPatienData() {
    if (!_validatePatienData()) {
      return [];
    }

    String noReg = formKey.value.currentState?.fields['noReg']!.value;
    String pin = formKey.value.currentState?.fields['pin']!.value;

    return [noReg, pin];
  }

  void _processUpdateUserProfile() {
    wrapperApiCall(
      Future(() async {
        var body = {};

        // ignore: avoid_function_literals_in_foreach_calls
        formKey.value.currentState?.fields.entries.forEach((element) {
          body.putIfAbsent(element.key, () => element.value.value.toString());
        });

        if (_personalData != null) {
          body = {
            ...body,
            'email': body['email'] ?? _personalData?.email,
          };
        }
        body.removeWhere((key, value) => value == null);

        await _userService.updateCurrentProfile(body);
      }),
      showSuccess: false,
      successCallback: _closeAndFetchData,
    );
  }

  void _processUpdateRelative(int relativeId) {
    wrapperApiCall(
      Future(() async {
        var body = _buildPersonalDataByFormKey();
        await _service.updatePersonalData(relativeId, body);
      }),
      successCallback: _closeAndFetchData,
    );
  }

  void _closeAndFetchData() {
    Get.close(1);
    fetchData();
  }

  void _processCreateRelative() {
    String? noReg;
    if (includePatienData) {
      List<String> patienData = _getPatienData();
      noReg = patienData[0];
    }

    wrapperApiCall(
      Future(() async {
        var personalData = _buildPersonalDataByFormKey();

        var body = {};
        body.addIf(includePatienData && noReg != null, 'noReg', noReg);
        body.addIf(personalData.isNotEmpty, 'personalData', personalData);

        var res = await _service.createNewRelative(body);
        _closeAndFetchData();
        Get.to(() => ProfilePatientsListPage());
      }),
      showSuccess: false,
    );
  }

  Map<dynamic, dynamic> _buildPersonalDataByFormKey() {
    var personalData = {};

    // ignore: avoid_function_literals_in_foreach_calls
    formKey.value.currentState?.fields.entries.forEach((element) {
      personalData.putIfAbsent(
          element.key, () => element.value.value.toString());
    });

    if (_personalData != null) {
      personalData = {
        ...personalData,
        'email': _personalData?.email,
      };
    }
    personalData.removeWhere((key, value) => value == null);

    return personalData;
  }

  void _processConnectPatienData(BuildContext context, int relativeId) {
    wrapperApiCall(
      Future(() async {
        var patienData = _getPatienData();

        await _service.connectPatient(relativeId, {
          "noReg": patienData[0],
          "pin": patienData[1],
        });
      }),
      showSuccess: false,
      successCallback: () {
        fetchData();
        Get.close(1);
      },
      errCallback: () => Get.close(1),
    );
  }

  Future<void> _getTitleOptions() async {
    return wrapperApiCall(
      Future(() async {
        var res = await _masterService.getTitles();
        var titles = TitleOption.toList(res.data);
        titleOptions(titles
            .map((e) => e.nama ?? "")
            .where((element) => element.isNotEmpty)
            .toSet()
            .toList());
      }),
      showSuccess: false,
      skipInitLoading: true,
      errCallback: () => Get.close(1),
    );
  }
}
