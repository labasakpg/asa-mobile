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
import 'package:anugerah_mobile/services/visitations_service.dart';
import 'package:anugerah_mobile/utils/employee_stake_holder_state_converter.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';

class VisitationCreateController extends BaseController {
  final VisitationsService _service = Get.put(VisitationsService());
  final BranchService _branchService = Get.put(BranchService());
  final FilesService _filesService = Get.put(FilesService());
  final LocationService _locationService = Get.put(LocationService());

  var formKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>("VisitationCreateController"));

  RxList<Branch> branchsOptions = RxList.empty(growable: true);
  RxString currentType = RxString("");
  RxString signatureSlug = RxString("");
  RxString picPhotoSlug = RxString("");
  RxString attachmentSlug = RxString("");

  @override
  void onReady() async {
    await initLocation();
  }

  void onPressedSubmit() async {
    if (!formKey.value.currentState!.validate()) {
      PageHelper.showInvalidInput();
      return;
    }
    if (signatureSlug.isEmpty ||
        picPhotoSlug.isEmpty ||
        attachmentSlug.isEmpty) {
      PageHelper.showInvalidInput();
      return;
    }

    String type = "";
    Map<String, dynamic> payload = Map.identity();
    // ignore: avoid_function_literals_in_foreach_calls
    formKey.value.currentState?.fields.entries.forEach((element) {
      String key = element.key;
      String value = element.value.value;
      if (key == "branchCode") {
        value = value.split("-").first;
      }
      payload.addIf(value.isNotEmpty && key != "type", key, value);
      if (key == "type") {
        type = value;
      }
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
    payload.addIf(
      attachmentSlug.isNotEmpty,
      "attachmentSlug",
      attachmentSlug.value,
    );

    var locationData = await _locationService.getLocation();
    payload = {
      ...payload,
      "longitude": locationData?.longitude,
      "latitude": locationData?.latitude,
    };

    wrapperApiCall(
      Future(() async {
        await _service.post(
          EmployeeStakeHolderStateConverter.fromLabel(type),
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

  void updateCurrentType(String? val) {
    if (val != currentType.value) {
      initBranch();
    }
    currentType(val);
  }

  Future<void> initLocation() async {
    await wrapperApiCall(
      Future(() async {
        var locationData = await _locationService.getLocation();
        if (locationData == null) {
          throw Exception("Gagal mendapatkan lokasi perangkat");
        }
      }),
      showSuccess: false,
      errCallback: errCallback,
    );
  }

  Future<void> initBranch() async {
    await wrapperApiCall(
      Future(() async {
        var menuAccess = currentType.isEmpty || currentType.value == "Dokter"
            ? "doctor-visitation"
            : "institute-visitation";
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
