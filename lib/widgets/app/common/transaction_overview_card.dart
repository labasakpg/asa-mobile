import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class TransactionOverviewCard extends StatelessWidget {
  TransactionOverviewCard({super.key});

  final c = Get.put(OrderController());

  Widget _buildItem({required String label, required String value, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          fontWeight: FontWeight.bold,
        ),
        AppText(
          value,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageHelper.paddingWrapper(
      child: Container(
        decoration: PageHelper.buildRoundBox(
          radius: 30,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(ScreenUtil().setSp(50)),
        child: Obx(
          () => Column(
            children: [
              _buildItem(label: "Sub Total Sebelum Diskon", value: PageHelper.currencyFormat(c.calculateSubTotal())),
              if (c.selectedPromo.value != null) _buildItem(label: "Diskon Promo", value: c.buildDiscountValue()),
              const Divider(
                thickness: 1.5,
              ),
              _buildItem(
                label: "Total Pembayaran",
                value: PageHelper.currencyFormat(c.calculateTotal()),
                color: ColorPalettes.homeIconSelected,
              ),
              PageHelper.buildGap(30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: c.processPaymentTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalettes.homeIconSelected,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ScreenUtil().setSp(30)),
                    ),
                  ),
                  child: const Text("Lanjutkan Pembayaran"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
