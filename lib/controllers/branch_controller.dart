import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/branch.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/branch_service.dart';

class BranchController extends BaseController {
  var isLastPage = false;
  var isLoadingInit = false;
  var latestPage = 1;
  RxList<Branch> listData = RxList.empty(growable: true);
  MapController mapController = MapController();
  ScrollController scrollController = ScrollController();
  Rx<Branch> selectedData = Rx(Branch(code: ""));

  final BranchService _service = Get.put(BranchService());

  @override
  void onClose() {
    scrollController.dispose();

    super.onClose();
  }

  void init() {
    fetchScroll(latestPage);
  }

  void fetchScroll([int page = 1]) {
    if (!isLoadingInit && !EasyLoading.isShow) {
      isLoadingInit = true;
      fetch(page);
      scrollController.addListener(_scrollListener);
    }
  }

  void fetch([int page = 1]) {
    wrapperApiCall(
      Future(() async {
        final res = await _service.getAllWithQuery(QueryService(
          useQuery: true,
          page: page,
          take: 6,
          sortBy: 'desc',
          selects: ['code', 'name', 'address', 'city', 'picture'],
        ));
        final branchs = Branch.toListBranchs(res.data['data']);
        if (branchs.isNotEmpty) {
          listData.addAll(branchs);
        } else {
          isLastPage = true;
        }
      }),
      finallyCallback: () => isLoadingInit = false,
      skipInitLoading: true,
      showSuccess: false,
    );
  }

  void fetchBranch(String code) {
    isLoadingInit = true;

    wrapperApiCall(
      Future(() async {
        final res = await _service.get(code, QueryService(useQuery: false));
        Branch branch = Branch.fromJson(res.data);
        selectedData(branch);

        Future.delayed(
          const Duration(milliseconds: 500),
          () => mapController.move(branch.location!.toLatLng(), 17),
        );
      }),
      finallyCallback: () => isLoadingInit = false,
      showSuccess: false,
      skipInitLoading: true,
      closePageIfGotException: true,
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadingInit &&
        !isLastPage) {
      ++latestPage;
      fetchScroll(latestPage);
    }
  }
}
