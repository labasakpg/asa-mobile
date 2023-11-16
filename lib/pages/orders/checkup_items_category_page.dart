import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/models/transaction_item.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_cart_badge.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_search.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/shared/checkup_items_category/checkup_item_category.dart';

class CheckupItemsCategoryPage extends StatelessWidget {
  CheckupItemsCategoryPage({
    super.key,
    this.categoryName,
    this.isHidePrice = false,
  });

  final c = Get.put(OrderController());
  final String? categoryName;
  final bool isHidePrice;

  Widget buildCheckupItemWithRemoveButton(TransactionItem item) {
    return Container(
      decoration: PageHelper.buildRoundBox(radius: 50, color: Colors.white),
      margin: EdgeInsets.only(bottom: ScreenUtil().setSp(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: c.checkupItemsSelected[item.testCode],
                  onChanged: (value) =>
                      c.toggleCheckupItemsSelected(item.testCode),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.name ?? "-",
                    fontSize: 12,
                  ),
                  if (!isHidePrice)
                    AppText(
                      PageHelper.currencyFormat(item.price3),
                      fontSize: 10,
                      color: Colors.red,
                    ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () => c.removeCheckupItem(item),
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_outlined,
                  size: ScreenUtil().setSp(65),
                  color: Colors.red[300],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildren(BuildContext context) {
    return Column(
      children: [
        AppSearch(
          hintText: "Cari di $categoryName",
          onClear: () async {
            var subGroup = c.selectedSubGroup.value;
            await c.onClearSearchCategoryItem();
            c.selectedSubGroup(subGroup);
          },
          onSubmitted: c.onSearchCategoryItem,
        ),
        Expanded(
          child: Obx(() {
            if (c.isLoading.isTrue) {
              return PageHelper.simpleCircularLoading(fullHeight: true);
            }

            return ListView(
              children: [
                if (c.isLoading.isFalse && c.filteredItems.isEmpty) ...[
                  PageHelper.emptyDataResponse(),
                ],
                ...c.filteredItems
                    .map((item) => CheckupItemCategory(
                          item: item,
                          isHidePrice: isHidePrice,
                        ))
                    .toList(),
                if (c.checkupItemsLastPage.isFalse) ...[
                  ElevatedButton(
                    onPressed: () {
                      c.updateSearchCategoryItem(
                        null,
                        page: c.checkupItemsPage.value + 1,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalettes.appPrimary,
                    ),
                    child: const AppText("Load more"),
                  ),
                ],
                PageHelper.buildGap(50),
              ],
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (c.selectedSubGroup.value.isEmpty) {
      Get.back();
    }

    return AppContentWrapper(
      title: "Daftar Layanan $categoryName",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      actions: [AppCartBadge()],
      child: Container(
        margin: EdgeInsets.only(top: ScreenUtil().setSp(50)),
        child: _buildChildren(context),
      ),
    );
  }
}
