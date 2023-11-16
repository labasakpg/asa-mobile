import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/faq.dart';
import 'package:anugerah_mobile/pages/faqs/faqs_list_page.dart';
import 'package:anugerah_mobile/services/faqs_service.dart';

class FaqsController extends BaseController {
  final _service = Get.put(FaqsService());

  var isLoadingInit = false;
  var retry = 0;

  RxList<Faq> listData = RxList.empty(growable: true);

  var searchFormKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>("faqController"));

  List<Faq> getPopularList() {
    const lengthData = 5;

    if (listData.isEmpty) return [];

    if (listData.length > lengthData) return listData.sublist(0, lengthData);

    return listData;
  }

  void init() {
    fetchData();
  }

  void fetchData() {
    if (!isLoadingInit && listData.isEmpty && retry < 3) {
      ++retry;
      isLoadingInit = true;

      wrapperApiCall(
        Future(() async {
          final res = await _service.getAll();
          final resData = Faq.toList(res.data);
          if (resData.isNotEmpty) {
            listData.addAll(resData);
          }
        }),
        finallyCallback: () => isLoadingInit = false,
        showSuccess: false,
        skipInitLoading: true,
      );
    }
  }

  void onEditingComplete() {
    var validate = searchFormKey.value.currentState?.validate();
    if (validate != null && !validate) return;

    String query = "";
    // ignore: avoid_function_literals_in_foreach_calls
    searchFormKey.value.currentState?.fields.entries.forEach((element) {
      query = element.value.value.toString();
    });

    Get.to(() => FaqsListPage(
          listData: listData,
          query: query,
        ));
  }
}
