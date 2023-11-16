import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/message.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/files_service.dart';
import 'package:anugerah_mobile/services/health_checkup_inquiry_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InquiryController extends BaseController {
  final HealthCheckupInquiryService _service =
      Get.put(HealthCheckupInquiryService());
  final FilesService _filesService = Get.put(FilesService());

  var isLoadingInit = RxBool(false);
  var isLastPage = false;
  var latestPage = 1;

  late int _threadId;

  ScrollController scrollController = ScrollController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  var formKey = Rx<GlobalObjectKey<FormBuilderState>>(
      const GlobalObjectKey<FormBuilderState>("inquiryController"));

  RxList<Message> listData = RxList.empty(growable: true);
  RxString uploadedSlug = RxString("");

  @override
  void onClose() {
    scrollController.dispose();

    super.onClose();
  }

  void init(int threadId) {
    _threadId = threadId;

    latestPage = 1;
    fetchAllDataWithScroll(page: latestPage);
  }

  void fetchAllDataWithScroll({int page = 1}) {
    if (isLoadingInit.isFalse) {
      _loading();
      fetchAllData(page);
      scrollController.addListener(_scrollListener);
    }
  }

  Future<void> fetchAllData([int page = 1]) async {
    await wrapperApiCall(
      Future(() async {
        isLoadingInit(true);
        if (page == 1) listData.clear();

        final res = await _service.getMessages(
            _threadId,
            QueryService(
              useQuery: true,
              page: page,
              take: 100,
              orderBy: 'updatedAt',
              sortBy: 'asc',
            ));
        final resData = Message.toList(res.data['data']);
        if (resData.isNotEmpty) {
          listData.addAll(resData);
        } else {
          isLastPage = true;
        }
      }),
      finallyCallback: () => isLoadingInit(false),
      errCallback: () => Get.back(),
      showSuccess: false,
      skipInitLoading: true,
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
        init(_threadId);
        fetchAllData(1);
        Get.back();
      },
    );
  }

  Future<void> onRefresh() async {
    await fetchAllData();

    refreshController.refreshCompleted();
  }

  void selectFile() async {
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
            uploadedSlug(res.data);
          }
        }),
      );
    }
  }

  void submitReply() async {
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

        if (uploadedSlug.isNotEmpty) {
          body.putIfAbsent("fileSlug", () => uploadedSlug.value);
        }

        await _service.postMessages(_threadId.toString(), body);
      }),
      successCallback: () {
        fetchAllDataWithScroll();
        uploadedSlug("");
        Get.back();
      },
    );
  }
}
