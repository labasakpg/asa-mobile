import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/visitation.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/visitations_service.dart';
import 'package:anugerah_mobile/utils/employee_stake_holder_state_converter.dart';
import 'package:anugerah_mobile/utils/service_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class VisitationsController extends BaseController {
  final VisitationsService _service = Get.put(VisitationsService());
  final AuthService _authService = Get.find<AuthService>();

  var isLastPage = false;
  var latestPage = 1;
  ScrollController scrollControllerListVisitationsPage = ScrollController();
  ScrollController scrollControllerVisitationsPage = ScrollController();

  RxList<Visitation> listData = RxList.empty(growable: true);
  Rx<Visitation> selectedData = Rx(Visitation(id: 0));
  var searchFormKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>("visitationsController"));
  RxBool focusOnSearch = RxBool(false);
  RxBool isLastSearchEmpty = RxBool(true);
  RxBool isLoading = RxBool(false);
  RxList<String> rangeDateQuery = RxList.empty(growable: true);
  Rx<EmployeeStakeHolderState> employeeMenuState =
      Rx(EmployeeStakeHolderState.doctor);

  @override
  void onReady() {
    init();
  }

  @override
  void onClose() {
    scrollControllerListVisitationsPage.dispose();

    super.onClose();
  }

  void setEmployeeMenuState(EmployeeStakeHolderState state) {
    employeeMenuState(state);
  }

  void init() {
    latestPage = 1;
    fetchVisitationsScroll(
      page: latestPage,
      take: 10,
    );
  }

  void fetchVisitationsScroll({int page = 1, int take = 6}) {
    if (!EasyLoading.isShow) {
      fetchVisitations(page);
      scrollControllerListVisitationsPage.addListener(_scrollListener);
    }
  }

  void fetchVisitations([
    int page = 1,
    String search = "",
  ]) {
    isLoading(true);
    wrapperApiCall(
      Future(() async {
        if (isSearchVisitations || page == 1) listData.clear();

        Map<String, dynamic> customQuery = Map.identity();
        if (rangeDateQuery.isNotEmpty) {
          customQuery.addIf(true, "startDate", rangeDateQuery[0]);
          customQuery.addIf(true, "endDate", rangeDateQuery[1]);
        }
        customQuery.addIf(true, "id", _getUserId());

        final res = await _service.getAll(
            employeeMenuState.value,
            QueryService(
              useQuery: true,
              page: page,
              take: 10,
              search: search,
              orderBy: 'createdAt',
              sortBy: 'desc',
              customeQuery: customQuery,
            ));
        final resData = Visitation.toList(res.data['data']);
        if (resData.isNotEmpty) {
          listData.addAll(resData);
        } else {
          isLastPage = true;
        }
      }),
      errCallback: () => --latestPage,
      closePageIfGotException: true,
      showSuccess: false,
      skipInitLoading: true,
      finallyCallback: () => isLoading(false),
    );
  }

  void _scrollListener() {
    if (scrollControllerListVisitationsPage.position.pixels ==
            scrollControllerListVisitationsPage.position.maxScrollExtent &&
        !isLastPage) {
      ++latestPage;
      fetchVisitationsScroll(page: latestPage);
    }
  }

  void onEditingComplete({bool useValidate = true}) {
    if (useValidate) searchFormKey.value.currentState?.validate();

    String search =
        searchFormKey.value.currentState?.fields['search']?.value ?? "";
    closeKeyboard();
    isLastSearchEmpty(search.trim().isEmpty);

    if (search.length > 2) fetchVisitations(1, search);
  }

  void onFocusChange(bool value) {
    focusOnSearch(value);
    if (value) {
      scrollControllerVisitationsPage.animateTo(0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }
  }

  bool get isSearchVisitations =>
      focusOnSearch.isTrue || isLastSearchEmpty.isFalse;

  bool get isEligibleToDownloadResult =>
      listData.isNotEmpty && rangeDateQuery.isNotEmpty;

  void clearSearch() {
    searchFormKey.update((form) {
      form!.currentState?.patchValue({"search": ""});
    });
    focusOnSearch(false);
    onEditingComplete(useValidate: false);
    init();
  }

  void onPressFilter() async {
    var context = Get.context;
    if (context == null) {
      return;
    }
    if (rangeDateQuery.isNotEmpty) {
      rangeDateQuery.clear();
      init();
      return;
    }

    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
    );

    if (results == null || results.isEmpty || results.length != 2) {
      await EasyLoading.showToast("Tanggal yang dipilih tidak valid");
      return;
    }

    rangeDateQuery
        .addAll(results.map((val) => val!.toIso8601String().split("T")[0]));
    init();
  }

  void downloadResult() async {
    EasyLoading.showToast("Download");
    var employeeState =
        EmployeeStakeHolderStateConverter.toKey(employeeMenuState.value);

    var url = "${apiService.baseUrl}/visits/$employeeState/export-pdf?"
        "startDate=${rangeDateQuery[0]}&endDate=${rangeDateQuery[1]}"
        "&id=${_getUserId()}";
    try {
      if (await _getStoragePermission()) {
        String downloadDir = await _getDownloadFolderPath();
        String downloadedFilePath =
            '$downloadDir/anugerah-${DateTime.now().microsecondsSinceEpoch}.pdf';
        EasyLoading.show(status: "Downloading ⏳");
        await Dio().download(
          url,
          downloadedFilePath,
        );
        EasyLoading.showSuccess("Downloaded");
      }
    } catch (e) {
      printError(info: "Failed with error: ${e.toString()}");
      ServiceHelper.showError(e);
    }
  }

  Future<bool> _getStoragePermission() async {
    return await Permission.manageExternalStorage.request().isGranted;
  }

  Future<String> _getDownloadFolderPath() async {
    return await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
  }

  _getUserId() => _authService.authData.value!.user!.id;
}
