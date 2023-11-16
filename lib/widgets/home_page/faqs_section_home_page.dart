import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/models/faq.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/home_page/section_home_page.dart';

class FaqsSectionHomePage extends SectionHomePage {
  const FaqsSectionHomePage({
    super.key,
    this.showViewAllButton = false,
    this.hideLabel = false,
    this.newsLength = 3,
    this.popularItems = const [],
    this.onPressedViewAll,
  });

  final bool hideLabel;
  final int newsLength;
  final VoidCallback? onPressedViewAll;
  final List<Faq> popularItems;
  final double radius = 25;
  final bool showViewAllButton;

  static Widget buildItem(BuildContext context, Faq data) {
    final double paddingH = ScreenUtil().setSp(50);
    final double paddingV = ScreenUtil().setSp(30);

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50))),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(15)),
        child: Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: ColorPalettes.textSecodary,
            collapsedIconColor: ColorPalettes.textSecodary,
            textColor: ColorPalettes.textSecodary,
            collapsedTextColor: ColorPalettes.textSecodary,
            expandedAlignment: Alignment.centerLeft,
            title: AppText(data.question ?? "-", fontWeight: FontWeight.bold),
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: paddingH,
                  right: paddingH,
                  bottom: paddingV,
                ),
                // child: AppText(content),
                child: MarkdownBody(data: data.answer ?? "-"),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildList(BuildContext context, List<Faq> items) {
    if (items.isEmpty) {
      return SizedBox(
        height: ScreenUtil().setSp(850),
        child: PageHelper.emptyDataResponse(),
      );
    }

    return Column(
        children: items.map((data) => buildItem(context, data)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorPalettes.homePageBackgroundSecondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      child: containerWrapper(
        vMargin: 30,
        child: columnWrapper(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSectionTitle("Pertanyaan Terpopuler"),
                  PageHelper.viewAllButton(
                    onPressed: onPressedViewAll ?? () => {},
                  )
                ],
              ),
            ),
            PageHelper.buildGap(),
            buildList(context, popularItems),
          ],
        ),
      ),
    );
  }
}
