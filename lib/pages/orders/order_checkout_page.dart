import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_checkout_controller.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/pages/promo/promo_list_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_checkbox.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_date.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_radio_group.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app/common/app_info_card.dart';
import 'package:anugerah_mobile/widgets/app/common/transaction_item_card.dart';
import 'package:anugerah_mobile/widgets/app/common/transaction_overview_card.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/divider_with_label.dart';

class OrderCheckoutPage extends StatelessWidget {
  OrderCheckoutPage({super.key});

  final c = Get.put(OrderController());
  final ci = Get.put(OrderCheckoutController());

  Widget _buildChildren(BuildContext context) {
    ci.init();
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInputPromoSection(),
          _buildInputCheckupDateSection(),
          _buildInputNoteSection(),
          _buildInputServiceSection(),
          _buildInputAddress(),
          _buildInputPaymentMethod(),
          _buildInfoSection(),
          _buildTransactions(),
          TransactionOverviewCard(),
          PageHelper.buildGap(50),
        ],
      ),
    );
  }

  Widget _buildInputPromoSection() {
    return _paddingWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(label: "Kode Promo"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: AppFormInputText(
                  enabled: false,
                  controller: ci.promoCodeController.value,
                  onChanged: (value) =>
                      ci.updateField(CheckoutInputType.voucherCode, value),
                  // onSubmitted: (val) => c.validatePromoCode(
                  //   val,
                  //   errCallback: ci.clearPromoCode,
                  // ),
                  margin: EdgeInsets.zero,
                  initialValue: c.selectedPromo.value?.code,
                  textInputAction: TextInputAction.done,
                  customeInputDecoration: PageHelper.inputDecorationV2(),
                ),
              ),

              // PageHelper.buildGap(30, Axis.horizontal),
              // Flexible(
              //   child: _buildButton(
              //     label: "Gunakan",
              //     width: double.infinity,
              //     onPressed: () => c.validatePromoCode(
              //       ci.inputPromoCode.value,
              //       errCallback: ci.clearPromoCode,
              //     ),
              //   ),
              // ),

              PageHelper.buildGap(30, Axis.horizontal),
              Flexible(
                flex: 1,
                child: _buildButton(
                  label: "Pilih Promo",
                  width: double.infinity,
                  onPressed: () async {
                    await Get.to(
                      () => PromoListPage(
                        showUsePromoButton: true,
                        onSelectPromo: (promo) {
                          String promoCode = promo.code!;
                          ci.promoCodeController.value.text = promoCode;
                          ci.inputPromoCode(promoCode);
                          c.validatePromoCode(
                            promoCode,
                            errCallback: ci.clearPromoCode,
                            successCallback: () => Get.close(1),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String label}) {
    return AppText(
      label,
      fontSize: 10,
      color: ColorPalettes.orderCheckoutSubSectionTitle,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildButton({
    required String label,
    VoidCallback? onPressed,
    double? width,
  }) {
    return SizedBox(
      width: width != null ? ScreenUtil().setSp(width) : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalettes.homeIconSelected,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(30)),
          ),
        ),
        child: AppText(label, fontSize: 12),
      ),
    );
  }

  Widget _paddingWrapper({required Widget child}) => Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil().setSp(50),
          right: ScreenUtil().setSp(50),
          top: ScreenUtil().setSp(20),
        ),
        child: child,
      );

  Widget _buildInputCheckupDateSection() {
    return _paddingWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(label: "Tentukan Tanggal Pemeriksaan"),
          AppFormInputDate(
            onChanged: (value) => ci.updateField(
                CheckoutInputType.checkupDate, value?.toUtc().toString()),
            inputType: InputType.both,
            format: DateFormat("h:mm a, EEEE, d MMMM yyyy", "id_ID"),
            margin: EdgeInsets.zero,
            firstDate: AppFormInputDate.firstDateBeforeToday,
            customeInputDecoration: PageHelper.inputDecorationV2(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputNoteSection() {
    return _paddingWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(label: "Catatan (Optional)"),
          AppFormInputText(
            onChanged: (value) =>
                ci.updateField(CheckoutInputType.note, value),
            margin: EdgeInsets.zero,
            textInputAction: TextInputAction.next,
            customeInputDecoration: PageHelper.inputDecorationV2(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputServiceSection() {
    return _paddingWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(label: "Pilihan Layanan"),
          AppFormInputRadioGroup(
            options: const ["Datang ke LAB", "Home Service"],
            initialValue: "Datang ke LAB",
            onChanged: (value) =>
                ci.updateField(CheckoutInputType.serviceType, value),
            margin: EdgeInsets.zero,
            customeInputDecoration: PageHelper.inputDecorationV2().copyWith(
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputAddress() {
    return Obx(
      () {
        if (ci.inputServiceType.value != "officer_come_to_your_place") {
          return Container();
        }

        return _paddingWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFormInputCheckbox(
                title: "Gunakan Alamat Terdaftar",
                onChanged: (value) => ci.updateField(
                    CheckoutInputType.useSavedAddress, value.toString()),
                margin: EdgeInsets.zero,
                customeInputDecoration: PageHelper.inputDecorationV2().copyWith(
                  contentPadding: EdgeInsets.zero,
                ),
                initialValue: true,
              ),
              PageHelper.buildGap(),
              if (ci.useSavedAddress.isFalse)
                _buildSectionTitle(label: "Gunakan Alamat Lain"),
              if (ci.useSavedAddress.isFalse)
                AppFormInputText(
                  onChanged: (value) =>
                      ci.updateField(CheckoutInputType.address, value),
                  margin: EdgeInsets.zero,
                  textInputAction: TextInputAction.next,
                  customeInputDecoration: PageHelper.inputDecorationV2(),
                  multiLine: true,
                  minLines: 4,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputPaymentMethod() {
    return _paddingWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(label: "Jenis Pembayaran"),
          AppFormInputRadioGroup(
            options: const ["Cash", "Transfer"],
            initialValue: "Transfer",
            onChanged: (value) =>
                ci.updateField(CheckoutInputType.paymentMethod, value),
            margin: EdgeInsets.zero,
            customeInputDecoration: PageHelper.inputDecorationV2().copyWith(
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions() {
    return _paddingWrapper(
      child: Obx(
        () => Column(
          children: [
            PageHelper.buildGap(),
            const DividerWithLabel(
              label: "List Pemeriksaan",
              height: 1,
              horizontalPadding: 10,
              color: Colors.black87,
              fontSize: 10,
            ),
            PageHelper.buildGap(30),
            ...c.transactions.values
                .map(
                  (transaction) => TransactionItemCard(
                    transaction: transaction,
                    useWhiteBackground: true,
                    showDiscount: c.selectedPromo.value != null,
                    showTotalPrice: true,
                    isHidePrice: c.isHidePrice.value,
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Obx(() {
      var paymentMethodType = ci.inputPaymentMethod.value;
      if (paymentMethodType.isEmpty) {
        return Container();
      }

      if (paymentMethodType == "cash") {
        return _paddingWrapper(
          child: const AppInfoCard(
            label: "Pembayaran dilakukan di tempat pemeriksaan",
          ),
        );
      }

      return _paddingWrapper(
        child: const AppInfoCard(
          label: """
Transfer ke Rekening BCA **7910493889**

PT. anugerah Laboratory
""",
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Daftar Pemesanan",
      padding: EdgeInsets.zero,
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildChildren(context),
    );
  }
}
