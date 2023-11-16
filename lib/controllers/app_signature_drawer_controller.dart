import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/services/files_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class AppSignatureDrawerController extends BaseController {
  final FilesService _filesService = Get.put(FilesService());
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black87,
    exportBackgroundColor: Colors.white,
  );
  RxString val = RxString("");

  @override
  void onClose() {
    signatureController.dispose();
  }

  void clear() {
    signatureController.clear();
  }

  Future<void> save() async {
    if (signatureController.isEmpty) {
      EasyLoading.showError("Tanda tangan tidak boleh kosong");
      return;
    }

    await wrapperApiCall(
      Future(() async {
        var bytes = await signatureController.toPngBytes();
        if (bytes == null) {
          return;
        }
        final tempDir = await getTemporaryDirectory();
        var file =
            await File('${tempDir.path}/signature.png').writeAsBytes(bytes);

        var res = await _filesService.upload(
          filePath: file.path,
          filename: "signature.png",
        );

        if (res.data != null) {
          val(res.data);
        }
      }),
    );
  }
}
