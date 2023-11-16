import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/news_controller.dart';
import 'package:anugerah_mobile/controllers/promo_controller.dart';
import 'package:anugerah_mobile/pages/news/news_list_page.dart';
import 'package:anugerah_mobile/pages/promo/promo_list_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_bar_builder.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';
import 'package:anugerah_mobile/widgets/home_page/news_section_home_page.dart';
import 'package:anugerah_mobile/widgets/home_page/promo_section_home_page.dart';

class NewsPage extends StatelessWidget {
  final c = Get.put(NewsController());
  final promoController = Get.put(PromoController());

  NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppbarWrapper(
      topSafeArea: false,
      useDashboardAppbar: true,
      useCustomeAppbar: true,
      customeAppBarFlexibleSpace: AppBarBuilder.buildBasicAppbar(
        label: "List Berita",
        withBackground: false,
        textColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      iconMargin: 40,
      iconSize: 18,
      expandedHeight: 0,
      hPrefeeredSize: 0,
      scrollController: c.scrollControllerNewsPage,
      children: _buildChildren(context),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      _buildSearchbar(),
      _buildSearchResult(context),
      _buildBanner(),
      _buildHighlightItems(),
    ];
  }

  Widget _buildSearchbar() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: FormBuilder(
          key: c.searchFormKey.value,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(30)),
                child: FocusScope(
                  child: Focus(
                    onFocusChange: c.onFocusChange,
                    child: AppFormInputText(
                      params: AppFormInputParams(
                        "",
                        "search",
                      ),
                      prefixWidget: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixWidget: Obx(
                        () => !c.isSearchNews
                            ? Container()
                            : InkWell(
                                onTap: c.clearSearch,
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      hintText: "Cari Berita",
                      margin: EdgeInsets.zero,
                      onEditingComplete: c.onEditingComplete,
                      onChanged: c.onSearchChanged,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Obx(
      () {
        if (c.isSearchNews) return Container();

        return Column(
          children: [
            PageHelper.buildGap(),
            _buildSectionLabel(
              label: "Promo Berlangsung",
              onPressed: () => Get.to(() => const PromoListPage()),
            ),
            PromoSectionHomePage(),
          ],
        );
      },
    );
  }

  Widget _buildHighlightItems() {
    return Obx(() {
      if (c.isSearchNews) return Container();

      return _buildHighlightSection();
    });
  }

  Widget _buildHighlightSection() {
    return Column(children: [
      _buildSectionLabel(
        label: "Berita",
        onPressed: () => Get.to(() => const NewsListPage()),
      ),
      PageHelper.buildGap(),
      NewsSectionHomePage(hideLabel: true),
    ]);
  }

  Widget _buildSectionLabel(
      {required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(35)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          PageHelper.viewAllButton(onPressed: onPressed),
        ],
      ),
    );
  }

  Widget _buildSearchResult(BuildContext context) {
    return Obx(
      () {
        if (!c.isSearchNews) return Container();

        if (c.listData.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: PageHelper.emptyDataResponse(),
          );
        }

        return Column(
          children: c.listData
              .map((news) => NewsSectionHomePage.buildNewsItem(context, news))
              .toList(),
        );
      },
    );
  }
}
