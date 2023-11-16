import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/news_section_home_controller.dart';
import 'package:anugerah_mobile/models/news.dart';
import 'package:anugerah_mobile/pages/news/news_detail_page.dart';
import 'package:anugerah_mobile/pages/news/news_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/home_page/section_home_page.dart';

class NewsSectionHomePage extends SectionHomePage {
  final c = Get.put(NewsSectionHomeController());

  final bool showViewAllButton;
  final bool hideLabel;
  final int newsLength;

  NewsSectionHomePage({
    super.key,
    this.showViewAllButton = false,
    this.hideLabel = false,
    this.newsLength = 3,
  });

  @override
  Widget build(BuildContext context) {
    c.fetchNews(newsLength);

    double radius = 25;
    double vPadding = 50;

    return Container(
      decoration: BoxDecoration(
        color: ColorPalettes.homePageBackgroundSecondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(vPadding)),
      child: containerWrapper(
        child: columnWrapper(
          children: [
            if (!hideLabel) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSectionTitle("Berita Terbaru"),
                  if (showViewAllButton)
                    PageHelper.viewAllButton(
                      onPressed: _onPressViewAll,
                    )
                ],
              ),
              PageHelper.buildGap(gap),
            ],
            _buildNews(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNews(BuildContext context) {
    return Obx(() {
      if (c.isLoading.isTrue) {
        return SizedBox(
          height: ScreenUtil().screenHeight / 2,
          child: PageHelper.simpleCircularLoading(),
        );
      }

      if (c.isEmptyResult.isTrue) {
        return SizedBox(
          height: ScreenUtil().screenHeight / 2,
          child: PageHelper.emptyDataResponse(),
        );
      }

      return Column(
        children:
            c.listData.map((news) => buildNewsItem(context, news)).toList(),
      );
    });
  }

  static Widget buildNewsItem(BuildContext context, News news, {int gap = 25}) {
    double height = 350;
    double widthImage = 300;
    double radius = 15;
    double imageRadius = 10;
    final body =
        news.body?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim() ?? '';

    return SizedBox(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        color: Colors.white,
        elevation: 0,
        child: InkWell(
          onTap: () => Get.to(() => NewsDetailPage(news: news)),
          child: SizedBox(
            width: double.infinity,
            height: ScreenUtil().setSp(height),
            child: Row(
              children: [
                Container(
                  width: ScreenUtil().setSp(widthImage),
                  height: double.infinity,
                  margin: EdgeInsets.all(ScreenUtil().setSp(gap)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EFF3),
                    borderRadius:
                        BorderRadius.all(Radius.circular(imageRadius)),
                  ),
                  child: AppImageNetwork(
                    slug: news.banner?.slug,
                    marginAll: 0,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    margin: EdgeInsets.all(ScreenUtil().setSp(gap)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppText(
                          news.title ?? "-",
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          fontSize: 12,
                        ),
                        AppText(
                          body,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          fontSize: 11,
                          lineHeight: 1.2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressViewAll() {
    Get.to(() => NewsPage());
  }
}
