import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/thread.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/health_checkup_inquiry_service.dart';

class HealthCheckupInquiryController extends BaseController {
  final HealthCheckupInquiryService _service =
      Get.put(HealthCheckupInquiryService());

  var isLoadingInit = RxBool(false);
  var isLastPage = false;
  var latestPage = 1;

  ScrollController scrollController = ScrollController();

  var formKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>(
          "healthCheckupInquiryController"));

  RxList<Thread> listData = RxList.empty(growable: true);
  Rx<Thread> selectedData = Rx(Thread(id: 0));

  @override
  void onClose() {
    scrollController.dispose();

    super.onClose();
  }

  void init() {
    latestPage = 1;
    fetchAllDataWithScroll(
      page: latestPage,
      take: 10,
    );
  }

  void fetchAllDataWithScroll({int page = 1, int take = 6}) {
    if (isLoadingInit.isFalse) {
      _loading();
      fetchAllData(page);
      scrollController.addListener(_scrollListener);
    }
  }

  void fetchAllData([int page = 1]) {
    wrapperApiCall(
      Future(() async {
        if (page == 1) listData.clear();

        final res = await _service.getAll(QueryService(
          useQuery: true,
          page: page,
          take: 10,
          orderBy: 'updatedAt',
          sortBy: 'desc',
          customeQuery: {"includeUserName": "true"},
        ));
        final resData = Thread.toList(res.data['data']);
        if (resData.isNotEmpty) {
          listData.addAll(resData);
        } else {
          isLastPage = true;
        }
      }),
      finallyCallback: () => isLoadingInit(false),
      errCallback: () => --latestPage,
      skipInitLoading: true,
      showSuccess: false,
    );
  }

  void _loading() {
    isLoadingInit(true);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        isLoadingInit.isFalse &&
        !isLastPage) {
      ++latestPage;
      fetchAllDataWithScroll(page: latestPage);
    }
  }

  void onPressedCreateThreadButton(BuildContext context) {
    if (!formKey.value.currentState!.validate()) {
      return;
    }

    wrapperApiCall(
      Future(() async {
        var body = {};

        // ignore: avoid_function_literals_in_foreach_calls
        formKey.value.currentState?.fields.entries.forEach((element) {
          body.putIfAbsent(element.key, () => element.value.value.toString());
        });

        await _service.post(body);
      }),
      successCallback: () {
        init();
        // fetchAllData(1);
        Get.back();
      },
    );
  }
}
