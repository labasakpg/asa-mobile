import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDivider extends StatelessWidget {
  final double height;
  const AppDivider({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: ScreenUtil().setSp(height));
  }
}
