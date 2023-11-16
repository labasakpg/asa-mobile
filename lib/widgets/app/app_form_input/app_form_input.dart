import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class AppFormInput extends StatelessWidget {
  final double contentPaddingVal = 30;

  final inputDecoration = PageHelper.inputDecoration(
    contentPaddingVal: 30,
  ).copyWith(
    fillColor: Colors.white,
  );

  AppFormInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget buildFormItem({
    required String label,
    required Widget formBuilderitem,
    double marginBottom = 50,
    double marginTop = 20,
    EdgeInsets? margin,
  }) {
    return Column(
      children: [
        if (label.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: AppText(
              label,
              textAlign: TextAlign.left,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        Container(
          margin: margin ??
              EdgeInsets.only(
                top: ScreenUtil().setSp(marginTop),
                bottom: ScreenUtil().setSp(marginBottom),
              ),
          child: formBuilderitem,
        ),
      ],
    );
  }
}
