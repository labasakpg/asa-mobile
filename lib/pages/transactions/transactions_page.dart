import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/bases/app_home_base.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/app_home_controller.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/controllers/transaction_history_controller.dart';
import 'package:anugerah_mobile/models/transaction.dart';
import 'package:anugerah_mobile/pages/orders/order_confirm_payment_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/transaction_item_card.dart';
import 'package:anugerah_mobile/widgets/app_bottom_navigation_bar.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class TransactionsPage extends StatelessWidget implements AppHomeBase {
  TransactionsPage({super.key});

  final c = Get.put(TransactionHistoryController());
  final co = Get.put(OrderController());
  final appHomeController = Get.put(AppHomeController());

  @override
  Widget actionButton() => Container();

  @override
  Widget appBar() => Container();

  @override
  Color? backgroundColor() => ColorPalettes.homePageBackgroundSecondary;

  @override
  List<Widget> children(BuildContext context) => [];

  @override
  double expandedHeight() => 0;

  @override
  double? hPrefeeredSize() => 0;

  @override
  String? pageName() => "Daftar Transaksi";

  @override
  bool? removeAppBar() => null;

  Widget _buildItem(Transaction? transaction) => TransactionItemCard(
        transaction: transaction,
        previewMode: true,
        useWhiteBackground: true,
        isHidePrice: co.isHidePrice.value,
      );

  Widget _buildTitle(TransactionData transactionData) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setSp(30)),
          child: SizedBox(
            width: ScreenUtil().setSp(100),
            child: CircleAvatar(
              radius: ScreenUtil().setSp(50),
              child: SvgPicture.asset(AssetsSVG.anugerahActive),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppText(
                  "${transactionData.orderNumber} - ",
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                AppText(
                  PageHelper.convertArrivalConfirmationFrom(
                      transactionData.arrivalConfirmation),
                  fontSize: 11,
                ),
              ],
            ),
            AppText(
              PageHelper.formatDate(
                  transactionData.checkupDate, "dd-MM-yyyy HH:mm"),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrailing(TransactionData transactionData) {
    return SizedBox(
      width: ScreenUtil().setSp(225),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const AppText(
                "Detail",
                fontSize: 9,
              ),
              PageHelper.buildGap(5, Axis.horizontal),
              Icon(
                Icons.arrow_drop_down_circle_outlined,
                size: ScreenUtil().setSp(35),
              ),
            ],
          ),
          AppText(
            PageHelper.currencyFormat(transactionData.total),
            color: Colors.red,
            overflow: TextOverflow.ellipsis,
            fontSize: 11,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container();

  @override
  Widget? contentWrapper(BuildContext context) {
    return AppContentWrapper(
      title: "History Transaksi",
      hideLeading: true,
      padding: EdgeInsets.zero,
      useSecondaryBackground: true,
      bottomNavigationBar: AppBottomNavigationBar(),
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    c.fetch();

    return SingleChildScrollView(
      controller: appHomeController.scrollController,
      child: Obx(
        () {
          final height = ScreenUtil().screenHeight / 1.35;

          if (c.isLoading.isTrue) {
            return SizedBox(
              height: height,
              child: PageHelper.simpleCircularLoading(),
            );
          }

          if (c.transactionsData.isEmpty) {
            return SizedBox(
              height: height,
              child: PageHelper.emptyDataResponse(),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
            child: Column(
              children: [
                PageHelper.buildGap(),
                ...c.transactionsData.map(
                  (transactionData) {
                    bool isShowUploadPaymentProof =
                        !transactionData.isBankTransferPaymentPaid &&
                            !transactionData.isTransactionStatusCancelled;

                    return Container(
                      decoration: PageHelper.buildRoundBoxOnly(
                        radius: 30,
                        color: Colors.white,
                        topLeft: true,
                        topRight: true,
                        bottomRight: true,
                      ),
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(30)),
                      child: Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: Column(
                          children: [
                            if (isShowUploadPaymentProof) ...[
                              PageHelper.buildGap(),
                              const AppText(
                                "Selesaikan Proses Pembayaran",
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                            ],
                            if (transactionData
                                .isTransactionStatusCancelled) ...[
                              PageHelper.buildGap(),
                              AppText(
                                "Transaksi di-Cancel oleh Admin",
                                color: ColorPalettes.secondaryButton,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                              Divider(color: ColorPalettes.secondaryButton),
                            ],
                            PageHelper.buildGap(),
                            AppText(
                              "Cabang: ${transactionData.branchName}",
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                              fontSize: 12,
                            ),
                            ExpansionTile(
                              title: _buildTitle(transactionData),
                              trailing: _buildTrailing(transactionData),
                              children: [
                                if (isShowUploadPaymentProof)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: ScreenUtil().setSp(30),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => _continueProcessPayment(
                                          transactionData),
                                      child:
                                          const AppText("Lanjutkan Pembayaran"),
                                    ),
                                  ),
                                if (transactionData.arrivalConfirmation ==
                                    "officer_come_to_your_place")
                                  _buildAdditionalInfoChild(
                                    "Alamat: ${transactionData.contactAddress ?? '-'}",
                                  ),
                                if (transactionData.promotionCouponCode !=
                                    null) ...[
                                  _buildAdditionalInfoChild(
                                    _buildVoucherLabel(transactionData),
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                                ...c.transactions[transactionData.id]!.values
                                    .map((item) => _buildItem(item))
                                    .toList(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
                PageHelper.buildGap(30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdditionalInfoChild(
    String info, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      child: AppText(
        info,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        color: color,
        fontWeight: fontWeight,
        fontSize: 11,
      ),
    );
  }

  void _continueProcessPayment(TransactionData transactionData) async {
    var transactionId = transactionData.id;
    if (transactionId == null) {
      return;
    }

    await Get.to(
        () => OrderConfirmPaymentPage(transactionIds: [transactionId]));
  }

  String _buildVoucherLabel(TransactionData transactionData) {
    String value = "${transactionData.promotionCouponValue}%";
    if (transactionData.promotionCouponType != "PERCENTAGE") {
      value = PageHelper.currencyFormat(transactionData.promotionCouponValue);
    }
    return "Voucher : ${transactionData.promotionCouponCode} | $value";
  }
}
