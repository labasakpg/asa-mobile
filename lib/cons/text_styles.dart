import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';

class TextStyles {
  TextStyles._();

  static TextStyle get h1 => TextStyle(
      color: Colors.white,
      fontSize: ScreenUtil().setSp(72),
      fontWeight: FontWeight.bold);

  static TextStyle get h2 =>
      TextStyle(color: Colors.black87, fontSize: ScreenUtil().setSp(65));

  static TextStyle get h3 =>
      TextStyle(color: Colors.black87, fontSize: ScreenUtil().setSp(55));

  static TextStyle get h4 => TextStyle(
      color: Colors.white,
      fontSize: ScreenUtil().setSp(45),
      fontWeight: FontWeight.bold);

  static TextStyle get inputWhite =>
      TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(45));

  static TextStyle get input =>
      TextStyle(color: Colors.black87, fontSize: ScreenUtil().setSp(38));

  static TextStyle get buildVerWhite =>
      TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(30));

  static TextStyle get flatButtonWhite =>
      TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(45));

  static TextStyle get flatButton =>
      TextStyle(color: ColorPalettes.primary, fontSize: ScreenUtil().setSp(45));

  static TextStyle get body1 =>
      TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(45));

  static TextStyle get body2 =>
      TextStyle(color: Colors.black87, fontSize: ScreenUtil().setSp(38));

  static TextStyle get body3 =>
      TextStyle(color: Colors.black45, fontSize: ScreenUtil().setSp(30));
}
