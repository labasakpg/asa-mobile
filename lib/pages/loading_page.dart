import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorPalettes.primary,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.appSplashScreen),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(
          top: ScreenUtil().setSp(1300),
        ),
        child: PageHelper.simpleCircularLoading(color: Colors.white70),
      ),
    );
  }
}
