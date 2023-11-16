import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    this.label,
    this.horizontal = 20,
    this.vertical = 10,
    this.iconSize = 75,
    this.radius = 50,
    this.fontSize = 10,
    this.fontWeight = FontWeight.normal,
  });

  final double fontSize;
  final FontWeight fontWeight;
  final double horizontal;
  final double iconSize;
  final String? label;
  final double radius;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: PageHelper.buildRoundBox(
        radius: radius,
        color: ColorPalettes.tileWarningBackground,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(horizontal),
        vertical: ScreenUtil().setSp(vertical),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(30)),
              child: Icon(
                Icons.info_outline_rounded,
                color: ColorPalettes.tileWarningIcon,
                size: ScreenUtil().setSp(iconSize),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
              child: MarkdownBody(
                data: label ?? "",
                styleSheet: style(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static MarkdownStyleSheet style(
    BuildContext context, {
    double lineHeight = 1.2,
    double textScaleFactor = 0.9,
  }) =>
      MarkdownStyleSheet.fromTheme(
        Theme.of(context),
      ).copyWith(
        textScaleFactor: textScaleFactor,
        p: TextStyle(height: lineHeight),
        pPadding: EdgeInsets.zero,
      );
}
