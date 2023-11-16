import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/models/news.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class NewsDetailPage extends StatelessWidget {
  final int? id;
  final News? news;

  const NewsDetailPage({
    super.key,
    this.id,
    this.news,
  });

  @override
  Widget build(BuildContext context) {
    if (id == null && news == null) {
      return PageHelper.emptyDataResponse();
    }

    return AppContentWrapper(
      appbarBackgroundColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: "",
      extendBodyBehindAppBar: true,
      padding: EdgeInsets.zero,
      child: _buildChild(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    var radius = Radius.circular(ScreenUtil().setSp(50));
    return SizedBox(
      height: ScreenUtil().setSp(650),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: radius,
          bottomRight: radius,
        ),
        child: AppImageNetwork(
          slug: news!.banner?.slug,
          fit: BoxFit.contain,
          radius: 0,
          marginAll: 0,
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          PageHelper.buildGap(30),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    const int paddingH = 50;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(paddingH)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            news?.title ?? "-",
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          PageHelper.buildGap(30),
          AppText(
            PageHelper.formatDate(news?.createdAt),
            fontSize: 14,
            color: ColorPalettes.homeIconSelected,
            fontWeight: FontWeight.bold,
          ),
          if (news?.promo != null)
            Column(
              children: [
                const Divider(),
                PageHelper.buildGap(),
                Row(
                  children: [
                    const AppText(
                      "Kode Promo: ",
                      fontSize: 14,
                    ),
                    AppText(
                      news?.promo?.code ?? "-",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                PageHelper.buildGap(),
                const Divider(),
              ],
            ),
          Html(
            data: news?.body,
          ),
          PageHelper.buildGap(30),
        ],
      ),
    );
  }
}
