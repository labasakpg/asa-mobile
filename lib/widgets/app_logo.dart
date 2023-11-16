import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/text_styles.dart';

class AppLogo extends StatelessWidget {
  final bool onlyLogo;
  final bool fullLogo;

  const AppLogo({super.key, this.onlyLogo = false, this.fullLogo = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: ScreenUtil().setSp(500),
            child: Image.asset(!fullLogo ? Assets.appLogo : Assets.appLogoFull),
          ),
          if (!onlyLogo) ...[
            Text("anugerah App", style: TextStyles.h4),
            SizedBox(height: ScreenUtil().setSp(25)),
            Text(
              "Laboratorium klinik",
              style: TextStyles.h4.copyWith(fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(35)),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
