import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/controllers/order_payment_controller.dart';
import 'package:anugerah_mobile/models/transaction.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_home.dart';
import 'package:anugerah_mobile/widgets/divider_with_label.dart';

class OrderSuccessPage extends StatelessWidget {
  OrderSuccessPage({
    super.key,
    required this.transactionIds,
  });

  final c = Get.put(OrderPaymentController());
  final co = Get.put(OrderController());

  final List<int> transactionIds;

  void onPressBackCallback() {
    co.init();
    Get.offAll(() => AppHome());
  }

  Widget _buildChildren(BuildContext context) {
    c.fetchTransactionById(transactionIds);

    return Obx(() {
      if (c.transactionsData.isEmpty) {
        return SizedBox(
          height: ScreenUtil().screenHeight / 2,
          child: PageHelper.simpleCircularLoading(),
        );
      }

      var transaction = c.transactionsData[0];

      return SingleChildScrollView(
        child: Column(children: [
          ...c.transactionsData
              .map((element) => _buildTransactionItem(element))
              .toList(),
          _wrapper(
            child: Column(
              children: [
                _buildItem(
                  "Tanggal Transaksi",
                  PageHelper.formatDate(
                    transaction.createdAt,
                    'hh:mm aaa, dd MMMM yy',
                  ),
                ),
                _buildItem("Catatan", transaction.note),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressBackCallback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalettes.homeIconSelected,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(30)),
                      ),
                    ),
                    child: const Text("Selesai"),
                  ),
                ),
              ],
            ),
          ),
          PageHelper.buildGap(50),
        ]),
      );
    });
  }

  Widget _buildItem(String label, String? value) {
    return AppFormInputText(
      params: AppFormInputParams(label, value ?? "-"),
      initialValue: value,
      enabled: false,
      customeInputDecoration: PageHelper.inputDecorationDisabledV2(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Konfirmasi Pembayaran",
      padding: EdgeInsets.zero,
      useSecondaryBackground: true,
      hideLeading: true,
      child: _buildChildren(context),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return _wrapper(
      child: Column(
        children: [
          PageHelper.buildGap(),
          DividerWithLabel(
            label: "Kode Pembayaran: ${transaction.orderNumber}",
            height: 1,
            horizontalPadding: 10,
            color: Colors.black87,
            fontSize: 12,
          ),
          _buildItem("Nama pasien", transaction.contactName),
          _buildItem("Email", transaction.contactEmail),
          _buildItem("Nomor Handphone / Whatsapp",
              _sanitizePhoneNumber(transaction.contactPhoneNumber)),
          _buildItem("Kode Pembayaran", transaction.orderNumber),
          _buildItem("Jumlah Bayar",
              PageHelper.currencyFormat(transaction.grandTotal)),
          const Divider(),
        ],
      ),
    );
  }

  Widget _wrapper({required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      child: child,
    );
  }

  String _sanitizePhoneNumber(String? val) {
    if (val == null) {
      return "";
    }

    if (val[0] == '0') {
      return "+62 ${val.substring(1)}";
    }

    return val;
  }
}
