import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConfiguration {
  AppConfiguration._();

  static String get usernameGreetings => "Guest";
  static String get invalidFormInputValue => "Data tidak lengkap\natau tidak valid.\nMohon cek kembali";

  static List<String> get genderOptions => ["Laki - laki", "Perempuan"];
  static List<String> get employeeStakeHolderOptions => ["Dokter", "Perusahaan"];

  static Radius get radiusCircular75 => Radius.circular(ScreenUtil().setSp(75));
  static Radius get radiusCircular50 => Radius.circular(ScreenUtil().setSp(50));
  static Radius get radiusCircular30 => Radius.circular(ScreenUtil().setSp(30));

  static double get radiusAllPlain30 => 30;
  static double get radiusAll100 => ScreenUtil().setSp(100);

  static double get heightScreenWithoutHeader => ScreenUtil().screenHeight - ScreenUtil().setHeight(325);

  static EdgeInsets get horizontalPadding50 => EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(50),
      );

  static EdgeInsets get verticalPadding30 => EdgeInsets.symmetric(
        vertical: ScreenUtil().setSp(30),
      );
}
