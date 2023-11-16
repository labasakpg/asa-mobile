import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/branch.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/branch_service.dart';
import 'package:anugerah_mobile/services/files_service.dart';
import 'package:anugerah_mobile/services/location_service.dart';
import 'package:anugerah_mobile/services/sponsorships_service.dart';
import 'package:anugerah_mobile/utils/employee_stake_holder_state_converter.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';

class SponsorshipCreateController extends BaseController {
  final SponsorshipsService _service = Get.put(SponsorshipsService());
  final BranchService _branchService = Get.put(BranchService());
  final FilesService _filesService = Get.put(FilesService());
  final LocationService _locationService = Get.put(LocationService());

  var formKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>("SponsorshipCreateController"));

  RxList<Branch> branchsOptions = RxList.empty(growable: true);
  RxString currentType = RxString("");
  RxString signatureSlug = RxString("");
  RxString picPhotoSlug = RxString("");

  void init(String label) async {
    currentType(label);
    await initPrefetchData();
  }

  void onPressedSubmit() async {
    if (!formKey.value.currentState!.validate()) {
      PageHelper.showInvalidInput();
      return;
    }
    if (signatureSlug.isEmpty || picPhotoSlug.isEmpty) {
      PageHelper.showInvalidInput();
      return;
    }

    Map<String, dynamic> payload = Map.identity();
    // ignore: avoid_function_literals_in_foreach_calls
    formKey.value.currentState?.fields.entries.forEach((element) {
      String key = element.key;
      String value = element.value.value;
      if (key == "branchCode") {
        value = value.split("-").first;
      }
      payload.addIf(value.isNotEmpty, key, value);
    });
    payload.addIf(
      signatureSlug.isNotEmpty,
      "signatureSlug",
      signatureSlug.value,
    );
    payload.addIf(
      picPhotoSlug.isNotEmpty,
      "picPhotoSlug",
      picPhotoSlug.value,
    );

    var locationData = await _locationService.getLocation();
    payload = {
      ...payload,
      "longitude": locationData?.longitude,
      "latitude": locationData?.latitude,
    };
    printInfo(info: payload.toString());

    wrapperApiCall(
      Future(() async {
        return await _service.post(
          EmployeeStakeHolderStateConverter.fromLabel(currentType.value),
          payload,
        );
      }),
      finallyCallback: Get.back,
    );
  }

  void selectFile(RxString val) async {
    var source = await PageHelper.getImageSourceWithDialog(context);
    if (source == null) {
      return;
    }

    final XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      wrapperApiCall(
        Future(() async {
          var res = await _filesService.upload(
              filePath: file.path, filename: file.name);
          if (res.data != null) {
            val(res.data);
          }
        }),
      );
    }
  }

  Future<void> initPrefetchData() async {
    await wrapperApiCall(
      Future(() async {
        var locationData = await _locationService.getLocation();
        if (locationData == null) {
          throw Exception("Gagal mendapatkan lokasi perangkat");
        }

        var menuAccess = currentType.isEmpty || currentType.value == "Dokter"
            ? "doctor-sponsorship-submission"
            : "institute-sponsorship-submission";
        final res = await _branchService.getAll(QueryService(
          useQuery: true,
          customeQuery: {"menuAccess": menuAccess},
        ));
        final resBranchs = Branch.toListBranchs(res.data);
        branchsOptions(resBranchs);
      }),
      showSuccess: false,
      errCallback: errCallback,
    );
  }
}
