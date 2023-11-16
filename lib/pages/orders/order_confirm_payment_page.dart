import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/controllers/order_payment_controller.dart';
import 'package:anugerah_mobile/models/transaction.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app/common/app_info_card.dart';
import 'package:anugerah_mobile/widgets/app/common/transaction_item_card.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_home.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/divider_with_label.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderConfirmPaymentPage extends StatelessWidget {
  OrderConfirmPaymentPage({
    super.key,
    this.transactionIds = const [],
  });

  final c = Get.put(OrderPaymentController());
  final co = Get.put(OrderController());
  final List<int> transactionIds;

  void onPressBackCallback() {
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

      return SingleChildScrollView(
        child: Column(
          children: [
            PageHelper.buildGap(50),
            _buildInformationSection(context),
            ...c.transactionsData
                .map(
                  (transaction) => _buildTransactionItem(context, transaction),
                )
                .toList(),
            PageHelper.buildGap(30),
            _buildLabel(),
            PageHelper.buildGap(30),
            _buildPaymentGuideline(context),
            PageHelper.buildGap(30),
            _buildButton(),
            PageHelper.buildGap(30),
          ],
        ),
      );
    });
  }

  Widget _buildUploadButton(BuildContext context, Transaction transaction) {
    const double radius = 30;
    var borderRadius = Radius.circular(ScreenUtil().setSp(radius));

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: borderRadius,
      dashPattern: const [3],
      strokeWidth: 0.5,
      color: ColorPalettes.dotBorder,
      child: InkWell(
        onTap: () => c.selectFile(transaction.id),
        child: ClipRRect(
          borderRadius: BorderRadius.all(borderRadius),
          child: Ink(
            decoration: PageHelper.buildRoundBox(
              radius: radius,
              color: ColorPalettes.uploadPaymentConfirmation,
            ),
            child: SizedBox(
              width: double.infinity,
              height: ScreenUtil().setSp(100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.drive_folder_upload_outlined),
                  PageHelper.buildGap(30, Axis.horizontal),
                  const AppText("Upload Bukti Transfer", fontSize: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context, Transaction transaction) {
    return Obx(
      () {
        if (!c.uploadedSlugs.containsKey(transaction.id)) {
          return Container();
        }

        return SizedBox(
            height: ScreenUtil().setSp(300),
            width: double.infinity,
            child: AppImageNetwork(slug: c.uploadedSlugs[transaction.id]));
      },
    );
  }

  Widget _buildInformationSection(BuildContext context) {
    return Container(
      decoration: PageHelper.buildRoundBox(
        radius: 50,
        color: ColorPalettes.tileWarningBackground,
      ),
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Icon(
                  Icons.info_outline_rounded,
                  color: ColorPalettes.tileWarningIcon,
                  size: ScreenUtil().setSp(75),
                ),
              ),
              PageHelper.buildGap(30, Axis.horizontal),
              Flexible(
                flex: 5,
                child: MarkdownBody(
                  data:
                      "**Terima kasih telah mempercayakan kesehatan anda kepada Lab Anugerah**",
                  styleSheet: AppInfoCard.style(context),
                ),
              ),
            ],
          ),
          const Divider(),
          MarkdownBody(
            data: """
Transaksi Anda belum selesai. Transaksi Anda akan di proses jika pembayaran telah dilunasi.

Segera lakukan pembayaran ke rekening yang tertera di bawah untuk menghindari kegagalan transaksi.
""",
            styleSheet: AppInfoCard.style(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentGuideline(BuildContext context) {
    return MarkdownBody(
      data: """
1. Transfer melalui ATM, Internet Banking, atau Mobile Banking Anda.

2. Pilih tujuan transfer dari salah satu bank dan nomor rekening yang tertera di bawah.

3. Masukkan jumlah transfer sesuai dengan informasi yang tertera.

4. Transfer ke Rekening Bank BNI 1982021436 PT. ANUGERAH ERSADA PERKASA.

5. Lakukan konfirmasi pembayaran melalui Tombol dibawah ini.
""",
      styleSheet: AppInfoCard.style(context),
    );
  }

  Widget _buildButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: c.uploadedSlugs.length != c.transactionsData.length
                ? null
                : c.processPaymentTransaction,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalettes.homeIconSelected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(30)),
              ),
            ),
            child: const Text("Konfirmasi Pembayaran"),
          ),
        ));
  }

  Widget _buildLabel() {
    return const DividerWithLabel(
      label: "Cara Pembayaran",
      height: 1,
      horizontalPadding: 10,
      color: Colors.black87,
      fontSize: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Pembayaran",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      hideLeading: true,
      child: _buildChildren(context),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    return Column(
      children: [
        const Divider(),
        _buildInformationSectionTransaction(context, transaction),
        PageHelper.buildGap(),
        ...c
            .convertToMapTransaction(transaction)
            .values
            .map(
              (transaction) => TransactionItemCard(
                transaction: transaction,
                previewMode: true,
                isHidePrice: co.isHidePrice.value,
              ),
            )
            .toList(),
        _buildUploadButton(context, transaction),
        _buildPreview(context, transaction),
      ],
    );
  }

  Widget _buildInformationSectionTransaction(
    BuildContext context,
    Transaction transaction,
  ) {
    return Container(
      decoration: PageHelper.buildRoundBox(
        radius: 50,
        color: ColorPalettes.tileWarningBackground,
      ),
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: Column(
        children: [
          MarkdownBody(
            data: """
Kode Pembayaran Anda **${transaction.orderNumber}**

Total Pembayaran **${PageHelper.currencyFormat(transaction.grandTotal)}** setelah diskon.
""",
            styleSheet: AppInfoCard.style(context),
          ),
        ],
      ),
    );
  }
}
