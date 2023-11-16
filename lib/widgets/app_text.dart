import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final Color? color;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final double? width;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? lineHeight;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;

  const AppText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight,
    this.letterSpacing,
    this.padding,
    this.backgroundColor,
    this.color,
    this.textAlign,
    this.width,
    this.overflow,
    this.maxLines,
    this.lineHeight,
    this.decoration,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      color: backgroundColor,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        style: defaultTextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          color: color,
          lineHeight: lineHeight,
          decoration: decoration,
          fontStyle: fontStyle,
        ),
        maxLines: maxLines,
      ),
    );
  }

  static TextStyle defaultTextStyle({
    double fontSize = 14,
    FontWeight? fontWeight,
    double? letterSpacing,
    Color? color,
    double? lineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: ScreenUtil().setSp(fontSize * 3),
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: color,
      height: lineHeight,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
}
