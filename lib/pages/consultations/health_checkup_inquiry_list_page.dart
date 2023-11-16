import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/health_checkup_inquiry_controller.dart';
import 'package:anugerah_mobile/models/thread.dart';
import 'package:anugerah_mobile/pages/consultations/health_checkup_inquiry_create_page.dart';
import 'package:anugerah_mobile/pages/consultations/health_checkup_inquiry_detail_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_photo_profile.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class HealthCheckupInquiryListPage extends StatelessWidget {
  final double paddingW = 50;

  final c = Get.put(HealthCheckupInquiryController());

  HealthCheckupInquiryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Riwayat Konsultasi",
      padding: EdgeInsets.zero,
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      actions: [
        IconButton(
          onPressed: c.init,
          icon: const Icon(Icons.refresh),
        ),
      ],
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setSp(paddingW)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCreateInquiryButton(context),
            PageHelper.buildGap(40),
            _buildChildren(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChildren(BuildContext context) {
    c.init();

    return Obx(
      () {
        if (c.isLoadingInit.isTrue) {
          return SizedBox(
            height: ScreenUtil().screenHeight / 2,
            child: PageHelper.simpleCircularLoading(),
          );
        }

        return Column(
          children: [
            const Divider(),
            ...c.listData.map((data) => _buildInquiryItem(data)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildInquiryItem(Thread thread) {
    var photoSize = ScreenUtil().setSp(120);

    return badges.Badge(
      showBadge: !thread.isRead,
      // badgeColor: const Color.fromARGB(255, 204, 58, 55),
      badgeContent: Icon(
        Icons.mark_chat_unread_outlined,
        color: Colors.white,
        size: ScreenUtil().setSp(40),
      ),
      // shape: BadgeShape.circle,
      position: badges.BadgePosition.topEnd(top: 0, end: 0),
      child: Card(
        child: InkWell(
          onTap: () => _openDetailItem(thread),
          child: ListTile(
            leading: AppPhotoProfile(
              hideName: true,
              mainAxisAlignment: MainAxisAlignment.center,
              width: photoSize,
              height: photoSize,
            ),
            trailing: Icon(
              Icons.check_circle,
              color: thread.getStatus() ? ColorPalettes.currencyLabel : null,
            ),
            title: AppText(
              thread.title ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: AppText(
              thread.description ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateInquiryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onPressedCreateInquiryButton,
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalettes.homeIconSelected),
        child: const Text("Konsultasi Baru"),
      ),
    );
  }

  void _onPressedCreateInquiryButton() {
    Get.to(() => HealthCheckupInquiryCreatePage());
  }

  void _openDetailItem(Thread thread) async {
    await Get.to(() => HealthCheckupInquiryDetailPage(thread: thread));
    c.init();
  }
}
