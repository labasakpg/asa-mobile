import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/models/transaction_item.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class CheckupItemCategory extends StatefulWidget {
  final TransactionItem item;
  final bool isHidePrice;

  const CheckupItemCategory({
    Key? key,
    required this.item,
    this.isHidePrice = false,
  }) : super(key: key);

  @override
  State<CheckupItemCategory> createState() => _CheckupItemCategoryState();
}

class _CheckupItemCategoryState extends State<CheckupItemCategory> {
  final c = Get.put(OrderController());

  bool isOpenDetail = false;

  @override
  Widget build(BuildContext context) {
    return _buildCheckupItem(super.widget.item);
  }

  Widget _buildCheckupItem(TransactionItem item) {
    return Obx(
      () => Container(
        color: item.isEven ? Colors.white : const Color(0xffF5F5F5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: c.isAdded(item.testCode),
                      onChanged: (value) => c.addCheckupItem(item),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ScreenUtil().setSp(550),
                          child: AppText(
                            item.name ?? "-",
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!widget.isHidePrice)
                          AppText(
                            PageHelper.currencyFormat(item.price3),
                            fontSize: 10,
                            color: Colors.red,
                          ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.abbreviation != null) ...[
                      if (item.abbreviation!.isNotEmpty)
                        PageHelper.buildGap(25),
                      AppText(
                        item.abbreviation ?? "-",
                        fontSize: 9,
                        color: Colors.red,
                      ),
                    ],
                    Padding(
                      padding: EdgeInsets.only(right: ScreenUtil().setSp(30)),
                      child: InkWell(
                        onTap: _onPressedDetail,
                        child: Row(
                          children: [
                            AppText(
                              "Detail",
                              fontSize: 10,
                              color: isOpenDetail
                                  ? ColorPalettes.appPrimary
                                  : Colors.black54,
                            ),
                            Icon(
                              isOpenDetail
                                  ? Icons.arrow_circle_up_outlined
                                  : Icons.arrow_circle_down_outlined,
                              color: isOpenDetail
                                  ? ColorPalettes.appPrimary
                                  : Colors.black54,
                              size: ScreenUtil().setSp(40),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isOpenDetail)
              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(30),
                  right: ScreenUtil().setSp(30),
                  bottom: ScreenUtil().setSp(30),
                ),
                child: AppText(
                  item.description ?? "-",
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onPressedDetail() {
    setState(() {
      isOpenDetail = !isOpenDetail;
    });
  }
}
