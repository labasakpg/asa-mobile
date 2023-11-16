import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInWrapper extends StatelessWidget {
  final String appBarBackgroundAssetPath;
  final List<Widget> children;

  const SignInWrapper({
    super.key,
    required this.appBarBackgroundAssetPath,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(appBarBackgroundAssetPath),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setSp(100)),
            child: ElevatedButton(
              onPressed: Get.back,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.only(top: ScreenUtil().setSp(400)),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(50),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
