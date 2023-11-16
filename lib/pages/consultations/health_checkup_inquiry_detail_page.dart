import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/inquiry_controller.dart';
import 'package:anugerah_mobile/models/message.dart';
import 'package:anugerah_mobile/models/thread.dart';
import 'package:anugerah_mobile/pages/consultations/health_checkup_inquiry_info_page.dart';
import 'package:anugerah_mobile/pages/consultations/health_checkup_inquiry_reply_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_photo_profile.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HealthCheckupInquiryDetailPage extends StatelessWidget {
  final double paddingItemMessage = 25;

  final c = Get.put(InquiryController());

  final Thread thread;

  HealthCheckupInquiryDetailPage({
    super.key,
    required this.thread,
  });

  @override
  Widget build(BuildContext context) {
    c.init(thread.id);

    return AppContentWrapper(
      title: "Data Konsultasi",
      padding: EdgeInsets.zero,
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      actions: [_buildActions(context)],
      floatingActionButton: _buildFAB(context),
      child: _buildMessageList(context),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenHeight,
      child: SmartRefresher(
        enablePullDown: true,
        onRefresh: c.onRefresh,
        controller: c.refreshController,
        reverse: true,
        child: SingleChildScrollView(
          child: _buildMessages(context),
        ),
      ),
    );
  }

  Widget _buildMessages(BuildContext context) {
    return Obx(
      () {
        if (c.isLoadingInit.isTrue) {
          return _wrapperEmptyData(child: PageHelper.simpleCircularLoading());
        }

        if (c.isLoadingInit.isFalse && c.listData.isEmpty) {
          return _wrapperEmptyData(child: PageHelper.emptyDataResponse());
        }

        return Column(
          children: [
            PageHelper.buildGap(),
            ...c.listData.map((message) => _buildMessageItem(message)).toList(),
            _buildMessageAnchor(),
          ],
        );
      },
    );
  }

  Widget _wrapperEmptyData({required Widget child}) {
    return SizedBox(
      height: ScreenUtil().screenHeight - ScreenUtil().setSp(300),
      child: child,
    );
  }

  Widget _buildMessageItem(Message message) {
    var isAdmin =
        message.user?.roles.any((element) => element.name == "SUPER_ADMIN") ??
            false;
    var slugFile = message.file?.slug ?? "";

    var sender = isAdmin ? "Admin Anugerah" : "You";
    var createdAt =
        PageHelper.formatDate(message.createdAt, 'd-MM-y hh:mm aaa');
    var photoSize = ScreenUtil().setSp(125);
    var backgroundColor =
        isAdmin ? ColorPalettes.buttonSecondary : Colors.white;

    Widget leadingWidget = isAdmin
        ? SizedBox.fromSize(
            size: Size.fromRadius(ScreenUtil().setSp(55)),
            child: SvgPicture.asset(AssetsSVG.anugerahActive),
          )
        : AppPhotoProfile(
            hideName: true,
            mainAxisAlignment: MainAxisAlignment.center,
            width: photoSize,
            height: photoSize,
          );
    List<Widget> senderAndDate = [sender, createdAt]
        .map((val) => AppText(
              val,
              color: ColorPalettes.textInputClear,
              fontSize: 10,
            ))
        .toList(growable: false);
    if (isAdmin) {
      senderAndDate = senderAndDate.reversed.toList(growable: false);
    }

    return Container(
      decoration: PageHelper.buildRoundBoxOnly(
        radius: 30,
        color: backgroundColor,
        topLeft: !isAdmin,
        topRight: true,
        bottomLeft: true,
        bottomRight: !!isAdmin,
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(50),
        vertical: ScreenUtil().setSp(10),
      ),
      padding: EdgeInsets.all(ScreenUtil().setSp(paddingItemMessage)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setSp(35),
              right: ScreenUtil().setSp(55),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: senderAndDate,
            ),
          ),
          PageHelper.buildGap(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isAdmin) ...[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                    child: leadingWidget,
                  ),
                ),
                PageHelper.buildGap(20, Axis.horizontal),
              ],
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: ScreenUtil().setSp(paddingItemMessage)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: isAdmin ? ScreenUtil().setSp(35) : 0.0,
                        ),
                        child: AppText(message.body ?? "-"),
                      ),
                      if (slugFile.isNotEmpty)
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setSp(15)),
                          alignment: Alignment.centerLeft,
                          height: ScreenUtil().setSp(300),
                          child: AppImageNetwork(
                            slug: slugFile,
                            alignment: Alignment.centerLeft,
                            marginAll: 0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isAdmin) ...[
                PageHelper.buildGap(20, Axis.horizontal),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setSp(10),
                      right: ScreenUtil().setSp(10),
                    ),
                    child: leadingWidget,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return IconButton(
      onPressed: () =>
          Get.to(() => HealthCheckupInquiryInfoPage(thread: thread)),
      icon: const Icon(Icons.info_outline),
    );
  }

  Widget? _buildFAB(BuildContext context) {
    if (thread.isClosed) return null;

    return FloatingActionButton(
      onPressed: () =>
          Get.to(() => HealthCheckupInquiryReplyPage(thread: thread)),
      backgroundColor: ColorPalettes.homeIconSelected,
      child: const Icon(Icons.message_outlined),
    );
  }

  Widget _buildMessageAnchor() {
    if (thread.isClosed) {
      return Container(
        decoration: PageHelper.buildRoundBox(
          radius: 20,
          color: ColorPalettes.inTransaction,
        ),
        margin: EdgeInsets.only(
          top: ScreenUtil().setSp(30),
          bottom: ScreenUtil().setSp(50),
        ),
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),
        child: const AppText(
          "~ Konsultasi telah berakhir ~",
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }

    return PageHelper.buildGap(120);
  }
}
