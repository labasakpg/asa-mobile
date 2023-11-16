import 'package:flutter/material.dart';

abstract class AppHomeBase {
  Widget actionButton();
  Widget appBar();
  List<Widget> children(BuildContext context);
  String? pageName();
  double expandedHeight();
  Color? backgroundColor();
  bool? removeAppBar();
  double? hPrefeeredSize();
  Widget? contentWrapper(BuildContext context);
}
