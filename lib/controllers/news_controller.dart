import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/news.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/news_service.dart';

class NewsController extends BaseController {
  final NewsService _service = Get.put(NewsService());

  var isLoadingInit = RxBool(false);
  var isLastPage = false;
  var latestPage = 1;
  var scrollControllerListNewsPage = ScrollController();
  var scrollControllerNewsPage = ScrollController();
  var listData = RxList.empty(growable: true);
  var selectedData = Rx(News(id: 0));
  var searchFormKey = Rx<GlobalObjectKey<FormBuilderState>>(
    const GlobalObjectKey<FormBuilderState>("newsController"),
  );
  var focusOnSearch = RxBool(false);
  var isLastSearchEmpty = RxBool(true);

  @override
  void onClose() {
    scrollControllerListNewsPage.dispose();
    super.onClose();
  }

  void init() {
    isLoadingInit(false);
    isLastPage = false;
    latestPage = 1;
    fetchNewsScroll(
      page: latestPage,
      take: 10,
    );
  }

  void fetchNewsScroll({int page = 1, int take = 6}) {
    if (isLoadingInit.isFalse) {
      scrollControllerListNewsPage.addListener(_scrollListener);
      fetchNews(page);
    }
  }

  void fetchNews([
    int page = 1,
    String search = "",
  ]) {
    wrapperApiCall(
      Future(() async {
        if (isSearchNews || page == 1) listData.clear();

        isLoadingInit(true);
        final res = await _service.getAll(QueryService(
          useQuery: true,
          page: page,
          take: 6,
          search: search,
          orderBy: 'createdAt',
          sortBy: 'desc',
          selects: [
            'id',
            'title',
            'body',
            'banner',
            'createdAt',
          ],
          customeQuery: {
            "hasPromo": false,
          },
        ));
        final resData = News.toList(res.data['data']);
        if (resData.isNotEmpty) {
          listData.addAll(resData);
        } else {
          isLastPage = true;
        }
      }),
      finallyCallback: () {
        ++latestPage;
        isLoadingInit(false);
      },
      errCallback: () => --latestPage,
      skipInitLoading: true,
      showSuccess: false,
    );
  }

  void _scrollListener() {
    if (scrollControllerListNewsPage.position.pixels ==
            scrollControllerListNewsPage.position.maxScrollExtent &&
        !isLastPage &&
        isLoadingInit.isFalse) {
      fetchNewsScroll(page: latestPage);
    }
  }

  void onEditingComplete({bool useValidate = true}) {
    if (useValidate) searchFormKey.value.currentState?.validate();

    String search =
        searchFormKey.value.currentState?.fields['search']?.value ?? "";
    closeKeyboard();
    isLastSearchEmpty(search.trim().isEmpty);

    if (search.length > 2) fetchNews(1, search);
  }

  void onSearchChanged(String? value) {}

  void onFocusChange(bool value) {
    focusOnSearch(value);
    if (value) {
      listData.clear();
      scrollControllerNewsPage.animateTo(0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }
  }

  bool get isSearchNews => focusOnSearch.isTrue || isLastSearchEmpty.isFalse;

  void clearSearch() {
    searchFormKey.update((form) {
      form!.currentState?.patchValue({"search": ""});
    });
    onEditingComplete(useValidate: false);
    listData.clear();
  }
}
