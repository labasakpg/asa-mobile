import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';

enum CheckoutInputType {
  voucherCode,
  note,
  checkupDate,
  serviceType,
  useSavedAddress,
  address,
  paymentMethod,
}

class OrderCheckoutController extends BaseController {
  var inputPromoCode = RxString("");
  var inputCheckupDate = RxString("");
  var inputNote = RxString("");
  var inputServiceType = RxString("");
  var useSavedAddress = RxBool(true);
  var inputAddress = RxString("");
  var inputPaymentMethod = RxString("");
  var promoCodeController = Rx<TextEditingController>(TextEditingController());

  void init() {
    inputPromoCode = RxString("");
    inputCheckupDate = RxString("");
    inputServiceType = RxString("patients_come_to_the_lab_sakura");
    useSavedAddress = RxBool(true);
    inputAddress = RxString("");
    inputNote = RxString("");
    inputPaymentMethod = RxString("bank_transfer");
    promoCodeController.value.clear();
  }

  void updateField(CheckoutInputType type, String? value) {
    if (value == null) return;

    switch (type) {
      case CheckoutInputType.voucherCode:
        inputPromoCode(value);
        break;
      case CheckoutInputType.note:
        inputNote(value);
        break;
      case CheckoutInputType.checkupDate:
        inputCheckupDate(value);
        break;
      case CheckoutInputType.serviceType:
        inputServiceType(convertToArrivalConfirmation(value));
        break;
      case CheckoutInputType.useSavedAddress:
        useSavedAddress(value == "true");
        break;
      case CheckoutInputType.address:
        inputAddress(value);
        break;
      case CheckoutInputType.paymentMethod:
        inputPaymentMethod(convertPaymentMethod(value));
        break;
      default:
    }
  }

  String convertToArrivalConfirmation(String value) {
    return value == "Home Service"
        ? "officer_come_to_your_place"
        : "patients_come_to_the_lab_sakura";
  }

  String convertPaymentMethod(String value) {
    return value == "Cash" ? "cash" : "bank_transfer";
  }

  bool validate() {
    if (useSavedAddress.isTrue && inputAddress.isEmpty) return false;

    return true;
  }

  Map<String, dynamic> getFields() {
    Map<String, dynamic> body = {
      "promoCode": inputPromoCode.value,
      "checkupDate": inputCheckupDate.value,
      "note": inputNote.value,
      "arrivalConfirmation": inputServiceType.value,
      "paymentMethod": inputPaymentMethod.value,
      "useRegisteredAddress": useSavedAddress.value,
      "address": inputAddress.value,
    };

    body.removeWhere((key, value) => value == null || value.toString().isEmpty);

    if (!body.containsKey("checkupDate")) {
      EasyLoading.showError("Tanggal Pemeriksaan\nbelum diisi");
      return {};
    }

    if (useSavedAddress.isFalse && inputAddress.value.isEmpty) {
      EasyLoading.showError("Alamat belum diisi");
      return {};
    }

    return body;
  }

  void clearPromoCode() {
    inputPromoCode("");
    promoCodeController.value.clear();
  }
}
