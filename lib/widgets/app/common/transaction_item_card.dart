import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/models/transaction.dart';
import 'package:anugerah_mobile/models/transaction_item.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class TransactionItemCard extends StatelessWidget {
  TransactionItemCard({
    super.key,
    this.transaction,
    this.useWhiteBackground = false,
    this.showDiscount = false,
    this.previewMode = false,
    this.isHidePrice = false,
    this.showTotalPrice = false,
  });

  final c = Get.put(OrderController());
  final bool previewMode;
  final bool showDiscount;
  final Transaction? transaction;
  final bool useWhiteBackground;
  final bool isHidePrice;
  final bool showTotalPrice;

  Widget _buildCheckupItem({required TransactionItem item}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              item.name ?? "-",
              fontSize: 12,
            ),
            Row(
              children: [
                if (showDiscount)
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil().setSp(30)),
                    child: AppText(
                      PageHelper.currencyFormat(item.price3),
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                if (!isHidePrice)
                  AppText(
                    PageHelper.currencyFormat(
                      !showDiscount
                          ? item.price3
                          : c.calculateCheckoutItem(item.price3),
                    ),
                    fontSize: 10,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setSp(10)),
          child: InkWell(
            onTap: () =>
                c.removeTransactionItem(transaction?.relative?.id, item),
            child: Icon(
              Icons.delete,
              color: ColorPalettes.textInputClear,
              size: ScreenUtil().setSp(50),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewItem({required TransactionItem item}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          item.name ?? "-",
          fontSize: 12,
        ),
        if (!isHidePrice)
          AppText(
            PageHelper.currencyFormat(
              !showDiscount
                  ? item.price3
                  : c.calculateCheckoutItem(item.price3),
            ),
            fontSize: 10,
            color: Colors.red,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (transaction == null) return Container();

    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      decoration: PageHelper.buildRoundBox(
        radius: 30,
        color: useWhiteBackground
            ? Colors.white
            : ColorPalettes.background1TransactionItem,
      ),
      margin: EdgeInsets.only(bottom: ScreenUtil().setSp(30)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ScreenUtil().setSp(100),
            child: CircleAvatar(
              radius: ScreenUtil().setSp(50),
              child: Image.asset(Assets.placeholderProfile),
            ),
          ),
          PageHelper.buildGap(20, Axis.horizontal),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      transaction?.relative?.personalData?.name ?? "-",
                      fontWeight: FontWeight.bold,
                    ),
                    if (!previewMode)
                      InkWell(
                        onTap: () =>
                            c.removeTransaction(transaction?.relative?.id),
                        child: Icon(
                          Icons.highlight_off,
                          color: ColorPalettes.textInputClear,
                        ),
                      ),
                  ],
                ),
                Column(
                  children: [
                    ...?transaction?.items
                        .map(
                          (item) => previewMode
                              ? _buildPreviewItem(item: item)
                              : _buildCheckupItem(item: item),
                        )
                        .toList(),
                  ],
                ),
                if (showTotalPrice) _buildTotalPrice(transaction?.items)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice(Set<TransactionItem>? items) {
    if (items == null || items.isEmpty) {
      return Container();
    }

    var totalPrice = items
        .map((item) => c.calculateCheckoutItem(item.price3))
        .reduce((value, element) => value + element);

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppText(
            PageHelper.currencyFormat(totalPrice),
            fontSize: 10,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}
