import 'package:flutter/material.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class DividerWithLabel extends StatelessWidget {
  final String label;
  final double height;
  final double horizontalPadding;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  const DividerWithLabel({
    super.key,
    required this.label,
    required this.height,
    required this.horizontalPadding,
    this.color = Colors.white,
    this.padding,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(children: <Widget>[
        Expanded(
          child: Container(
              margin: EdgeInsets.only(left: horizontalPadding, right: 15.0),
              child: Divider(
                color: color,
                height: height,
              )),
        ),
        AppText(
          label,
          color: color,
          fontSize: fontSize,
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 15.0, right: horizontalPadding),
              child: Divider(
                color: color,
                height: height,
              )),
        ),
      ]),
    );
  }
}
