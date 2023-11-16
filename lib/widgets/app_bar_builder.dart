import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class AppBarBuilder {
  static Widget buildBasicAppbar({
    required String label,
    bool withBackground = true,
    Color backgroundColor = Colors.white,
    double height = 350,
    double paddingTop = 75,
    double paddingHorizontal = 150,
    Color textColor = Colors.white,
  }) {
    if (Platform.isIOS) {
      height += 100;
      paddingTop += 75;
    }
    return PageHelper.disableVerticalDrag(
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: withBackground
              ? BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(Assets.mainAppBarBackground),
                  ),
                )
              : null,
          color: withBackground ? null : backgroundColor,
          child: SizedBox(
            height: ScreenUtil().setSp(height),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setSp(paddingTop),
                  left: ScreenUtil().setSp(paddingHorizontal),
                  right: ScreenUtil().setSp(paddingHorizontal),
                ),
                child: AppText(
                  label,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: textColor,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
