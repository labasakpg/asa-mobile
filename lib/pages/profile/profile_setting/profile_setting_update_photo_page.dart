import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/profile_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_photo_profile.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class ProfileSettingUpdatePhotoPage extends StatelessWidget {
  final c = Get.put(ProfilePageController());

  ProfileSettingUpdatePhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    c.init();

    return AppContentWrapper(
      title: "Perbarui Photo Profile",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    var photoSize = ScreenUtil().setSp(400);

    return Column(
      children: [
        PageHelper.buildGap(60),
        AppPhotoProfile(
          hideName: true,
          width: photoSize,
          height: photoSize,
          circleRadiusSU: 200,
        ),
        PageHelper.buildGap(60),
        _buildUploadButton(context),
      ],
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    const double radius = 30;
    var borderRadius = Radius.circular(ScreenUtil().setSp(radius));

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: borderRadius,
      dashPattern: const [3],
      strokeWidth: 0.5,
      color: ColorPalettes.dotBorder,
      child: InkWell(
        onTap: c.selectAndUploadPhotoProfile,
        child: ClipRRect(
          borderRadius: BorderRadius.all(borderRadius),
          child: Ink(
            decoration: PageHelper.buildRoundBox(
              radius: radius,
              color: Colors.white,
            ),
            child: SizedBox(
              width: double.infinity,
              height: ScreenUtil().setSp(100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.drive_folder_upload_outlined),
                  PageHelper.buildGap(30, Axis.horizontal),
                  const AppText("Pilih atau ambil Gambar", fontSize: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
