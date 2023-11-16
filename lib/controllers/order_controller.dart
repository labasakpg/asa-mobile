import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/controllers/order_checkout_controller.dart';
import 'package:anugerah_mobile/models/branch.dart';
import 'package:anugerah_mobile/models/category.dart';
import 'package:anugerah_mobile/models/promo.dart';
import 'package:anugerah_mobile/models/relative.dart';
import 'package:anugerah_mobile/models/transaction.dart';
import 'package:anugerah_mobile/models/transaction_item.dart';
import 'package:anugerah_mobile/pages/orders/order_checkout_page.dart';
import 'package:anugerah_mobile/pages/orders/order_confirm_payment_page.dart';
import 'package:anugerah_mobile/pages/orders/order_select_branch_page.dart';
import 'package:anugerah_mobile/pages/orders/order_select_checkup_items_page.dart';
import 'package:anugerah_mobile/pages/orders/order_success_page.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/branch_service.dart';
import 'package:anugerah_mobile/services/master_service.dart';
import 'package:anugerah_mobile/services/promo_service.dart';
import 'package:anugerah_mobile/services/relatives_service.dart';
import 'package:anugerah_mobile/services/system_config_service.dart';
import 'package:anugerah_mobile/services/transaction_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';

class OrderController extends BaseController {
  RxMap<String, TransactionItem> addedCheckupItem = RxMap({});
  RxList<Branch> branchs = RxList.empty();
  RxList<Category> categories = RxList.empty();
  RxMap<String, TransactionItem> checkupItemsByBranchCode = RxMap();
  RxMap<String, TransactionItem> checkupItemsByBranchCodeAndCategory = RxMap();
  RxMap<String, bool> checkupItemsSelected = RxMap({});
  RxList<Relative> patients = RxList.empty();
  RxMap<int, bool> patientsSelected = RxMap({});
  Rx<Branch?> selectedBranch = Rx(null);
  Rx<Promo?> selectedPromo = Rx(null);
  RxMap<int, Transaction> transactions = RxMap({});
  RxBool dataIsEmpty = RxBool(false);
  RxBool isHidePrice = RxBool(false);
  var isLoading = RxBool(false);
  RxString filterCategory = RxString("");
  RxString filterCategoryItem = RxString("");
  var checkupItemsPage = RxInt(1);
  var checkupItemsLastPage = RxBool(false);
  var selectedSubGroup = RxString("");

  final _branchService = Get.put(BranchService());
  final _systemConfigService = Get.put(SystemConfigService());
  final _masterService = Get.put(MasterService());
  final _orderCheckoutController = Get.put(OrderCheckoutController());
  final _promoService = Get.put(PromoService());
  final _relativesService = Get.put(RelativesService());
  final _transactionService = Get.put(TransactionService());

  void init() {
    checkupItemsSelected = RxMap({});
    patientsSelected = RxMap({});
    selectedBranch = Rx(null);
    selectedPromo = Rx(null);
    transactions = RxMap({});
    addedCheckupItem = RxMap({});
  }

  Future<void> initFetch() async {
    fetchCategories();
    await updateSearchCategoryItem("");
    fetchPatients();
  }

  int get transactionItemsLength => transactions.values
      .map((e) => e.items)
      .map((e) => e.length)
      .reduce((value, element) => value + element);

  String get currentCartLength => addedCheckupItem.length.toString();

  bool get activatingAddTransactionButton =>
      checkupItemsSelected.containsValue(true) &&
      patientsSelected.containsValue(true);

  List<Category> get filteredCategories => categories
      .where((element) =>
          element.name!.toLowerCase().contains(filterCategory.toLowerCase()))
      .toList();

  List<TransactionItem> get filteredItems => checkupItemsByBranchCode.values
      .where((element) => element.name!
          .toLowerCase()
          .contains(filterCategoryItem.toLowerCase()))
      .toList();

  List<TransactionItem> get filteredCheckupItemsByBranchCodeAndCategory =>
      checkupItemsByBranchCodeAndCategory.values.toList();

  void onSearchCategory(String? val) => filterCategory(val ?? "");

  Future<void> onSearchCategoryItem(String? val) =>
      updateSearchCategoryItem(val ?? "");

  void onClearSearchCategory() {
    filterCategory("");
  }

  void onClearSearch() {
    onClearSearchCategory();
    onClearSearchCategoryItem();
  }

  Future<void> onClearSearchCategoryItem() async {
    updateSearchCategoryItem("");
    selectedSubGroup("");
  }

  Future<void> updateSearchCategoryItem(String? val, {int page = 1}) async {
    filterCategoryItem(val ?? filterCategoryItem.value);
    checkupItemsPage(page);
    isLoading(false);
    await fetchCheckupItems();
  }

  void validateSelectedBranch() {
    if (selectedBranch.value == null) {
      Get.off(() => const OrderSelectBranchPage());
      return;
    }

    onClearSearchCategory();
    Get.off(() => OrderSelectCheckupItemPage());
    return;
  }

  void fetchInitialData() {
    fetchBranchs();
    fetchHidePriceSystemConfig();
  }

  // [GET] branchs/all
  void fetchBranchs() {
    wrapperApiCall(
      Future(() async {
        final res = await _branchService.getAll(QueryService(useQuery: false));
        final data = Branch.toListBranchs(res.data);
        if (data.isNotEmpty) {
          branchs.clear();
          branchs.addAll(data);
        }
      }),
      skipInitLoading: true,
      showSuccess: false,
      errCallback: errCallback,
    );
  }

  // [GET] system-configurations/key/hide-price-for-mobile-apps
  void fetchHidePriceSystemConfig() {
    wrapperApiCall(
      Future(() async {
        var res =
            await _systemConfigService.getByKey(SystemConfigOptions.hidePrice);
        isHidePrice(res.data['data'] == 'true');
      }),
      skipInitLoading: true,
      showSuccess: false,
    );
  }

  // [GET] master/categories
  void fetchCategories() {
    wrapperApiCall(
      Future(() async {
        final res = await _masterService.getCategories();
        final data = Category.toList(res.data['data']);
        if (data.isNotEmpty) {
          categories.clear();
          categories.addAll(data);
        }
      }),
      skipInitLoading: true,
      showSuccess: false,
      errCallback: errCallback,
    );
  }

  // [GET] master/general-prices?branchCode=branchCode
  Future<void> fetchCheckupItems() async {
    if (isLoading.isTrue) {
      return;
    }
    isLoading(true);

    if (checkupItemsPage.value == 1) {
      checkupItemsByBranchCode.clear();
    }

    return wrapperApiCall(
      Future(() async {
        checkupItemsLastPage(false);
        final res = await _masterService.getGeneralPricesByBranchCode(
          branchCode: selectedBranch.value!.code,
          page: checkupItemsPage.value,
          search: filterCategoryItem.value,
          subGroup: selectedSubGroup.value,
        );
        printInfo(
            info:
                "fetchCheckupItems() branchCode: ${selectedBranch.value!.code} "
                "subGroup: ${selectedSubGroup.value} "
                "search: ${filterCategoryItem.value} "
                "page: ${checkupItemsPage.value} "
                "total: ${res.data['total']}");

        final totalData = res.data['total'];
        final data = TransactionItem.toList(res.data['data']);
        if (data.isNotEmpty) {
          int counter = 1;
          checkupItemsByBranchCode.addAll(
            Map.fromEntries(data.map((item) {
              item.isEven = counter % 2 != 0;
              ++counter;
              return MapEntry(item.testCode, item);
            })),
          );
        }

        if ((checkupItemsPage.value > 1 && data.isEmpty) ||
            totalData < _masterService.take) {
          checkupItemsLastPage(true);
        }
      }),
      finallyCallback: () => isLoading(false),
      skipInitLoading: true,
      showSuccess: false,
      errCallback: errCallback,
    );
  }

  // [GET] master/general-prices?subgroup=categoryId&branchCode=branchCode
  void fetchCheckupItemsByBranchCodeAndCategory(String subgroup) {
    dataIsEmpty(false);
    wrapperApiCall(
      Future(() async {
        final res =
            await _masterService.getGeneralPricesByBranchCodeAndCategory(
                selectedBranch.value!.code, subgroup);
        final data = TransactionItem.toList(res.data['data']);
        checkupItemsByBranchCodeAndCategory.clear();
        int counter = 1;
        if (data.isNotEmpty) {
          checkupItemsByBranchCodeAndCategory.addAll(
            Map.fromEntries(data.map((item) {
              item.isEven = counter % 2 != 0;
              ++counter;
              return MapEntry(item.testCode, item);
            })),
          );
        } else {
          dataIsEmpty(true);
          // await EasyLoading.showToast("Data tidak ditemukan");
          // await Future.delayed(const Duration(seconds: 1));
          // Get.back();
        }
      }),
      skipInitLoading: true,
      showSuccess: false,
      errCallback: errCallback,
    );
  }

  // [GET] relatives
  Future<void> fetchPatients() async {
    return wrapperApiCall(
      Future(() async {
        final res = await _relativesService.getAll();
        final data = Relative.toList(res.data);
        if (data.isNotEmpty) {
          patients.clear();
          patients.addAll(data);
          patientsSelected.clear();
          for (var patient in data) {
            int? patientId = patient.id;
            if (patientId != null) {
              patientsSelected.addIf(true, patientId, false);
            }
          }
        }
      }),
      skipInitLoading: true,
      showSuccess: false,
      errCallback: errCallback,
    );
  }

  // [GET] promos/code/MANTAP123/validate
  void validatePromoCode(
    String? code, {
    VoidCallback? successCallback,
    VoidCallback? errCallback,
  }) {
    if (code == null || code.isEmpty) {
      EasyLoading.showToast("Kode Promo tidak boleh kosong");
      return;
    }
    closeKeyboard();

    wrapperApiCall(
      Future(() async {
        final res = await _promoService.validatePromoCode(code);
        final data = Promo.fromJson(res.data);
        selectedPromo(data);
      }),
      showSuccess: false,
      successCallback: () {
        EasyLoading.showSuccess("Kode Promo berhasil ditambahkan");
        successCallback?.call();
      },
      overrideErrMessage: "Kode Promo tidak valid",
      errCallback: () {
        errCallback?.call();
        selectedPromo = Rx(null);
      },
    );
  }

  // [POST] transactions V2
  void processTransaction(Map<String, dynamic> payload) {
    Get.back();

    wrapperApiCall(
      Future(() async {
        final res = await _transactionService.postV2(payload);
        List<int> transactionIds = List<int>.from(res.data);
        if (payload["paymentMethod"] == "bank_transfer") {
          Get.offAll(
            () => OrderConfirmPaymentPage(transactionIds: transactionIds),
          );
        } else {
          Get.offAll(() => OrderSuccessPage(transactionIds: transactionIds));
        }
        init();
      }),
      showSuccess: false,
    );
  }

  // [POST] transactions/payment
  void processTransactionPayment() {}

  void initOrdersPage() {
    validateSelectedBranch();
  }

  void selectBranch(Branch branch) {
    selectedBranch(branch);
    Get.off(() => OrderSelectCheckupItemPage());
  }

  bool isAdded(String testCode) => addedCheckupItem.containsKey(testCode);

  void addCheckupItem(TransactionItem checkupItem) {
    String testCode = checkupItem.testCode;
    if (isAdded(testCode)) {
      addedCheckupItem.remove(testCode);
      checkupItemsSelected.remove(testCode);
    } else {
      addedCheckupItem.addIf(true, testCode, checkupItem);
      checkupItemsSelected.addIf(true, testCode, false);
    }
  }

  void toggleCheckupItemsSelected(String testCode) {
    if (checkupItemsSelected.containsKey(testCode)) {
      checkupItemsSelected.update(testCode, (value) => !value);
    }
  }

  void togglePatientsSelected(int? patientId) {
    if (patientId == null) return;

    if (patientsSelected.containsKey(patientId)) {
      patientsSelected.update(patientId, (value) => !value);
    }
  }

  void addTransaction() {
    if (checkupItemsSelected.isEmpty || patientsSelected.isEmpty) {
      return;
    }

    List<Relative> processPatients = [];
    Set<TransactionItem> processCheckupItems = {};

    checkupItemsSelected.forEach((key, value) {
      if (value) {
        TransactionItem? checkupItem = addedCheckupItem[key];
        if (checkupItem != null) {
          processCheckupItems.add(checkupItem);
        }
      }
    });

    patientsSelected.forEach((key, value) {
      if (value) {
        Relative? relative =
            patients.firstWhere((patient) => patient.id == key);
        processPatients.add(relative);
      }
    });

    checkupItemsSelected.forEach(
        (key, value) => checkupItemsSelected.update(key, (value) => false));
    patientsSelected.forEach(
        (key, value) => patientsSelected.update(key, (value) => false));

    for (var patient in processPatients) {
      int? patientId = patient.id;
      if (patientId != null) {
        transactions.update(
          patientId,
          (value) {
            value.items.addAll(Set.from(processCheckupItems));
            return value;
          },
          ifAbsent: () => Transaction(
            relative: patient,
            items: Set.from(processCheckupItems),
          ),
        );
      }
    }
  }

  void removeTransaction(int? patientId) {
    if (patientId == null) return;

    transactions.remove(patientId);
    handleIfInCheckoutPageAndTransactionsEmpty();
  }

  void removeTransactionItem(int? patientId, TransactionItem item) {
    if (patientId == null) return;

    bool isItemsEmpty = false;
    transactions.update(patientId, (value) {
      value.items.remove(item);
      isItemsEmpty = value.items.isEmpty;
      return value;
    });

    if (isItemsEmpty) {
      removeTransaction(patientId);
    }

    handleIfInCheckoutPageAndTransactionsEmpty();
  }

  void removeCheckupItem(TransactionItem checkupItem) async {
    addedCheckupItem.remove(checkupItem.testCode);
    checkupItemsSelected.remove(checkupItem.testCode);

    if (addedCheckupItem.isEmpty) {
      await infoEmptyCartAndBack();
    }
  }

  void handleIfInCheckoutPageAndTransactionsEmpty() async {
    if (Get.currentRoute != "/OrderCheckoutPage") return;

    if (transactions.isEmpty) {
      await infoEmptyCartAndBack();
    }
  }

  Future<void> infoEmptyCartAndBack() async {
    await EasyLoading.showInfo("Keranjang Kosong");
    Get.back();
  }

  void continuePayment() {
    selectedPromo = Rx(null);

    Get.to(() => OrderCheckoutPage());
  }

  void processPaymentTransaction() {
    var payload = _orderCheckoutController.getFields();
    if (payload.isEmpty) return;

    var items = [];
    transactions.forEach((key, value) {
      var personalDataId = value.relative?.personalData?.id;
      var checkupCodes = [];

      for (var item in value.items) {
        checkupCodes.add(item.testCode);
      }

      items.add({
        "personalDataId": personalDataId,
        "checkupCodes": checkupCodes,
      });
    });
    payload.putIfAbsent("items", () => items);
    payload.putIfAbsent("branchCode", () => selectedBranch.value?.code);

    Get.defaultDialog(
      onConfirm: () => processTransaction(payload),
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onCancel: () {},
      textCancel: "No",
      middleText: "Transaksi yang telah dibuat,\ntidak dapat dibatalkan",
      title: "Konfirmasi Transaksi",
    );
  }

  // OK
  int calculateCheckoutItem(int? price) {
    if (price == null) return 0;

    var discountAmount = (price * discountPercentage());
    if (selectedPromo.value?.type == "AMOUNT") {
      discountAmount =
          selectedPromo.value!.value!.toInt() / transactionItemsLength;
    }

    double total = price - discountAmount;
    return max(0, total.toInt());
  }

  // OK
  int calculateSubTotal() {
    int total = 0;

    transactions.forEach((key, value) {
      for (var item in value.items) {
        total += item.price3 ?? 0;
      }
    });

    return total;
  }

  // OK
  int calculateTotal() {
    int total = calculateSubTotal();
    int discountAmount = (total * discountPercentage()).ceil();

    return max(0, (total - discountAmount).toInt());
  }

  // OK
  String buildDiscountValue() {
    if (selectedPromo.value == null) return "";

    var value = selectedPromo.value?.value;
    if (isDiscountTypeAmount(selectedPromo.value?.type)) {
      return PageHelper.currencyFormat(value);
    }

    return "$value%";
  }

  // OK
  double discountPercentage() {
    if (selectedPromo.value == null) return 0;

    var value = selectedPromo.value?.value ?? 0;
    var finalVal = value / 100;

    if (isDiscountTypeAmount(selectedPromo.value?.type)) {
      finalVal = value / calculateSubTotal();
    }

    return finalVal;
  }

  bool isDiscountTypeAmount(String? type) => type == "AMOUNT" ? true : false;
}
