import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/controllers/profile_controller.dart';
import 'package:anugerah_mobile/pages/profile/profile_setting/profile_setting_update_photo_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class AppPhotoProfile extends StatelessWidget {
  AppPhotoProfile({
    super.key,
    this.hideEditIcon = true,
    this.hideName = false,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.circleRadiusSU = 100,
    this.width,
    this.height,
    this.customSlug,
    this.forceCustomSlug = false,
  });

  final c = Get.put(ProfilePageController());
  final bool hideEditIcon;
  final bool hideName;
  final MainAxisAlignment mainAxisAlignment;
  final double circleRadiusSU;
  final double? width;
  final double? height;
  final String? customSlug;
  final bool forceCustomSlug;

  @override
  Widget build(BuildContext context) {
    return _buildProfilePlaceholder();
  }

  Widget _buildProfilePlaceholder() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setSp(25),
      ),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      ScreenUtil().radius(circleRadiusSU),
                    ),
                  ),
                ),
                padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                height: height,
                width: width,
                child: CircleAvatar(
                  radius: ScreenUtil().setSp(circleRadiusSU),
                  child: Obx(() {
                    String? urlSlug = "";
                    if (c.photoUrlSlug.isNotEmpty) {
                      urlSlug = c.photoUrlSlug.value;
                    }
                    if (customSlug != null || forceCustomSlug) {
                      urlSlug = customSlug;
                    }

                    if (urlSlug != null && urlSlug.isNotEmpty) {
                      return AppImageNetwork(
                        slug: urlSlug,
                        fit: BoxFit.fill,
                        radius: circleRadiusSU,
                        marginAll: 0,
                      );
                    }

                    return Image.asset(Assets.placeholderProfile);
                  }),
                ),
              ),
              InkWell(
                onTap: _onTapEditPhotoProfile,
                child: Visibility(
                  visible: !hideEditIcon,
                  child: Stack(
                    children: [
                      Container(
                        width: ScreenUtil().setSp(75),
                        height: ScreenUtil().setSp(75),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              ScreenUtil().radius(50),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setSp(75),
                        height: ScreenUtil().setSp(75),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit_outlined,
                          size: ScreenUtil().setSp(40),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!hideName) ...[
            PageHelper.buildGap(5),
            SizedBox(
              width: ScreenUtil().setSp(400),
              child: Obx(() => AppText(
                    c.userName.value,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
          ]
        ],
      ),
    );
  }

  void _onTapEditPhotoProfile() {
    Get.to(() => ProfileSettingUpdatePhotoPage());
  }
}
