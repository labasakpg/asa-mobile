import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/checkup_result.dart';
import 'package:anugerah_mobile/pages/checkup_results/checkup_results_detail_page.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/checkup_results_service.dart';
import 'package:anugerah_mobile/utils/service_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckupResultController extends BaseController {
  var isLastPage = false;
  var isLoadingInit = RxBool(false);
  var latestPage = 1;
  RxList<CheckupResult> listData = RxList.empty(growable: true);
  RxString patientId = "".obs;
  late TargetPlatform? platform;
  ScrollController scrollController = ScrollController();

  final _service = Get.put(CheckupResultsService());

  @override
  void onClose() {
    scrollController.dispose();

    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  void init(String id) async {
    patientId(id);
    fetchScroll(latestPage);
  }

  void fetchScroll([int page = 1]) {
    if (isLoadingInit.isFalse) {
      isLoadingInit(true);
      fetch(page);
      scrollController.addListener(_scrollListener);
    }
  }

  void fetch([int page = 1]) {
    wrapperApiCall(
      Future(() async {
        if (patientId.isEmpty) return;

        final res = await _service.getByPatientId(
            patientId: patientId.value,
            query: QueryService(
              useQuery: true,
              page: page,
              take: 6,
              orderBy: 'checkUpDate',
              sortBy: 'desc',
              selects: [
                "id",
                "patientId",
                "checkUpDate",
                "description",
                "doctorId",
                "createdAt",
                "updatedAt",
                "instituteId",
              ],
            ));
        final data = CheckupResult.toList(res.data['data']);
        if (data.isNotEmpty) {
          listData.addAll(data);
        } else {
          isLastPage = true;
        }
      }),
      finallyCallback: () => isLoadingInit(false),
      skipInitLoading: true,
      showSuccess: false,
    );
  }

  void previewHandler({
    String? id,
    String? patientId,
    String? doctorId,
    String? description,
  }) {
    if (id == null ||
        patientId == null ||
        doctorId == null ||
        description == null) {
      EasyLoading.showError("Failed to preview");
      return;
    }

    Get.to(() => CheckupResultDetailPage(
          checkupResultId: id,
          patientId: patientId,
          doctorId: doctorId,
          description: description,
        ));
  }

  Future<void> downloadHandler({
    String? id,
    String? patientId,
    String? doctorId,
    String? description,
    String? label,
    String? patientName,
  }) async {
    if (id == null ||
        patientId == null ||
        doctorId == null ||
        description == null ||
        label == null) {
      EasyLoading.showError("Failed to download");
      return;
    }

    var url = "${apiService.baseUrl}/checkup-results/$id/"
        "$patientId/$doctorId/$description/file?isDownload=true";
    printInfo(info: "CheckupResult Download url: $url");

    try {
      if (await _getStoragePermission()) {
        String downloadDir = await _getDownloadFolderPath();
        String downloadedFilePath = '$downloadDir/$patientName-$id-$label.pdf';
        EasyLoading.show(status: "Downloading ⏳");
        await Dio().download(
          url,
          downloadedFilePath,
        );
        EasyLoading.showSuccess("Downloaded");
      }
    } catch (e) {
      ServiceHelper.showError(e);
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        isLoadingInit.isFalse &&
        !isLastPage) {
      ++latestPage;
      fetchScroll(latestPage);
    }
  }

  Future<bool> _getStoragePermission() async {
    return await Permission.manageExternalStorage.request().isGranted;
  }

  Future<String> _getDownloadFolderPath() async {
    return await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
  }
}
