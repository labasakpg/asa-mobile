import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/models/category.dart';
import 'package:anugerah_mobile/pages/orders/checkup_items_category_page.dart';
import 'package:anugerah_mobile/pages/orders/orders_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_cart_badge.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_search.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/home_page/promo_section_home_page.dart';
import 'package:anugerah_mobile/widgets/shared/checkup_items_category/checkup_item_category.dart';

class OrderSelectCheckupItemPage extends StatelessWidget {
  OrderSelectCheckupItemPage({super.key});

  final c = Get.put(OrderController());
  final double radius = 25;

  Widget _buildChildren(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PromoSectionHomePage(),
          PageHelper.buildGap(15),
          _categoriesCheckupItems(context),
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setSp(120),
      child: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {
            c.init();
            Get.back();
            Get.to(() => const OrdersPage());
          },
          backgroundColor: ColorPalettes.appPrimary,
          label: const AppText("Ganti Cabang", fontSize: 12),
        ),
      ),
    );
  }

  Widget _tabHeaderWrapper({required String label}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: PageHelper.buildRoundBoxOnly(
        color: Colors.white,
        radius: radius,
        topLeft: true,
        topRight: true,
      ),
      margin: const EdgeInsets.only(right: 5),
      child: Center(
        child: AppText(
          label,
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _categoriesCheckupItems(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(child: _tabHeaderWrapper(label: "Kategori")),
      Tab(child: _tabHeaderWrapper(label: "Pemeriksaan")),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      child: DefaultTabController(
        length: tabs.length,
        child: Builder(
          builder: (BuildContext contextBuilder) {
            final controller = DefaultTabController.of(contextBuilder);
            controller.addListener(() {
              if (!controller.indexIsChanging) {
                c.onClearSearch();
              }
            });
            return _buildTabChild(contextBuilder, tabs);
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      children: [
        AppSearch(
          hintText: "Cari Kategori",
          onClear: c.onClearSearchCategory,
          onSubmitted: c.onSearchCategory,
        ),
        Expanded(
          child: Obx(() {
            if (c.filteredCategories.isEmpty) {
              return PageHelper.emptyDataResponse();
            }

            return ListView(
              children: [
                ...c.filteredCategories.map(_buildCategoryItem).toList(),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCheckupItemsSection(BuildContext context) {
    return Column(
      children: [
        AppSearch(
          hintText: "Cari Pemeriksaan",
          onClear: c.onClearSearchCategoryItem,
          onSubmitted: c.onSearchCategoryItem,
        ),
        Expanded(
          child: Obx(() {
            if (c.isLoading.isTrue) {
              return PageHelper.simpleCircularLoading(fullHeight: true);
            }

            return ListView(
              children: [
                if (c.isLoading.isFalse &&
                    c.checkupItemsByBranchCode.isEmpty) ...[
                  PageHelper.emptyDataResponse(),
                ],
                ...c.filteredItems
                    .map((item) => CheckupItemCategory(
                          item: item,
                          isHidePrice: c.isHidePrice.value,
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
                  PageHelper.buildGap(100),
                ],
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(Category data) {
    return InkWell(
      onTap: () => _onOpenCategoryItem(data),
      child: Container(
        decoration: PageHelper.buildRoundBox(
          radius: 30,
          color: ColorPalettes.cardBackground,
        ),
        padding: EdgeInsets.all(ScreenUtil().setSp(25)),
        margin: EdgeInsets.only(bottom: ScreenUtil().setSp(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText("${data.name}"),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: ScreenUtil().setSp(50),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    c.initFetch();

    return AppContentWrapper(
      titleWidget: Obx(() => AppContentWrapper.buildTitle(
            title: "Daftar Layanan ${c.selectedBranch.value?.name}",
            color: Colors.white,
          )),
      useSecondaryBackground: true,
      padding: EdgeInsets.zero,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      actions: [AppCartBadge()],
      floatingActionButton: _buildFab(context),
      child: _buildChildren(context),
    );
  }

  Widget _buildTabChild(BuildContext context, List<Tab> tabs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ScreenUtil().screenWidth / 1.5,
          child: TabBar(
            tabs: tabs,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
          ),
        ),
        Container(
          decoration: PageHelper.buildRoundBoxOnly(
            radius: radius,
            color: Colors.white,
            topRight: true,
          ),
          height: ScreenUtil().screenHeight - ScreenUtil().setSp(950),
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: TabBarView(
            children: [
              _buildCategoriesSection(context),
              _buildCheckupItemsSection(context),
            ],
          ),
        )
      ],
    );
  }

  void _onOpenCategoryItem(Category data) async {
    await c.onClearSearchCategoryItem();
    c.selectedSubGroup(data.code);
    await Get.to(() => CheckupItemsCategoryPage(
          categoryName: data.name,
          isHidePrice: c.isHidePrice.value,
        ));
    await c.onClearSearchCategoryItem();
  }
}
