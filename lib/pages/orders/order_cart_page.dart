import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/models/relative.dart';
import 'package:anugerah_mobile/pages/orders/checkup_items_category_page.dart';
import 'package:anugerah_mobile/pages/profile/profile_patients/profile_patients_list_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_info_card.dart';
import 'package:anugerah_mobile/widgets/app/common/transaction_item_card.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/divider_with_label.dart';

class OrderCartPage extends StatelessWidget {
  OrderCartPage({
    super.key,
  });

  final c = Get.put(OrderController());

  Widget _buildChildren(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PageHelper.buildGap(30),
          _paddingWrapper(
            child: AppInfoCard(
              label: """
Pelaksanaan pemeriksaan yang anda pilih pada:

**${c.selectedBranch.value?.name}**
""",
            ),
          ),
          PageHelper.buildGap(),
          _buildCheckupItemsSection(),
          _buildPatientsSection(),
          _buildTransactions(),
        ],
      ),
    );
  }

  Widget _paddingWrapper({required Widget child}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
        child: child,
      );

  Widget _buildCheckupItemsSection() {
    return Obx(
      () => _paddingWrapper(
        child: Column(
          children: [
            const DividerWithLabel(
              label: "List Pemeriksaan",
              height: 1,
              horizontalPadding: 10,
              color: Colors.black87,
              fontSize: 10,
            ),
            _buildButton(
              label: "Pemeriksaan",
              width: 450,
              onPressed: Get.back,
            ),
            PageHelper.buildGap(),
            ...c.addedCheckupItem.values
                .toList()
                .map(
                  CheckupItemsCategoryPage(
                    isHidePrice: c.isHidePrice.value,
                  ).buildCheckupItemWithRemoveButton,
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    VoidCallback? onPressed,
    int? width,
    bool hideIcon = false,
  }) {
    return Container(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: width != null ? ScreenUtil().setSp(width) : null,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalettes.homeIconSelected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(30)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!hideIcon) const Icon(Icons.add_circle_outline),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    c.onClearSearchCategory();

    return AppContentWrapper(
      title: "Daftar Pemesanan",
      padding: EdgeInsets.zero,
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildChildren(context),
    );
  }

  Widget _buildPatientsSection() {
    return Obx(
      () => _paddingWrapper(
        child: Column(
          children: [
            const DividerWithLabel(
              label: "List Pasien",
              height: 1,
              horizontalPadding: 10,
              color: Colors.black87,
              fontSize: 10,
            ),
            _buildButton(
              label: "Pasien",
              width: 450,
              onPressed: () async {
                await Get.to(() => ProfilePatientsListPage());
                await c.fetchPatients();
              },
            ),
            PageHelper.buildGap(),
            ...c.patients.map(_buildPatientItem).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientItem(Relative patient) {
    return Container(
      decoration: PageHelper.buildRoundBox(radius: 30, color: Colors.white),
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      margin: EdgeInsets.only(bottom: ScreenUtil().setSp(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: ScreenUtil().setSp(50),
                child: Image.asset(Assets.placeholderProfile),
              ),
              PageHelper.buildGap(20, Axis.horizontal),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    patient.personalData?.name ?? "",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText("REG ${patient.patient?.id ?? "-"}",
                      fontSize: 12, color: Colors.black54),
                ],
              ),
            ],
          ),
          Obx(
            () => Checkbox(
              value: c.patientsSelected[patient.id],
              onChanged: (value) => c.togglePatientsSelected(patient.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions() {
    return Column(
      children: [
        Obx(
          () => _paddingWrapper(
            child: _buildButton(
              label: "Tambah Transaksi",
              hideIcon: true,
              onPressed:
                  !c.activatingAddTransactionButton ? null : c.addTransaction,
            ),
          ),
        ),
        PageHelper.buildGap(),
        Container(
          decoration: PageHelper.buildRoundBoxOnly(
            radius: 75,
            color: Colors.white,
            topLeft: true,
            topRight: true,
          ),
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setSp(30),
            horizontal: ScreenUtil().setSp(50),
          ),
          width: double.infinity,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Transaksi Anda",
                  color: ColorPalettes.textSecodary,
                  fontSize: 10,
                ),
                PageHelper.buildGap(),
                ...c.transactions.values
                    .map(
                      (transaction) => TransactionItemCard(
                        transaction: transaction,
                        isHidePrice: c.isHidePrice.value,
                      ),
                    )
                    .toList(),
                _buildButton(
                    label: "Lanjutkan Pembayaran",
                    hideIcon: true,
                    onPressed:
                        c.transactions.isEmpty ? null : c.continuePayment),
                if (c.transactions.isEmpty && c.addedCheckupItem.length == 1)
                  SizedBox(height: ScreenUtil().setSp(300)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
