import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/inquiry_controller.dart';
import 'package:anugerah_mobile/models/thread.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';

class HealthCheckupInquiryInfoPage extends StatelessWidget {
  final c = Get.put(InquiryController());

  final Thread thread;

  HealthCheckupInquiryInfoPage({
    super.key,
    required this.thread,
  });

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Data Konsultasi",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildThreadOverview(context),
    );
  }

  Widget _buildThreadOverview(BuildContext context) {
    return Column(
      children: [
        PageHelper.buildGap(),
        _wrapperThreadOverviewItem(
          label: "Nama Pasien",
          value: thread.user?.personalData?.name,
        ),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: _wrapperThreadOverviewItem(
                label: "Tanggal Konsultasi",
                value: PageHelper.formatDate(thread.createdAt),
              ),
            ),
            PageHelper.buildGap(20, Axis.horizontal),
            Flexible(
              flex: 1,
              child: _wrapperThreadOverviewItem(
                label: "Status",
                value: thread.status,
              ),
            ),
          ],
        ),
        _wrapperThreadOverviewItem(
          label: "Judul",
          value: thread.title,
        ),
        _wrapperThreadOverviewItem(
          label: "Deskripsi",
          value: thread.description,
        ),
        PageHelper.buildGap(50),
      ],
    );
  }

  Widget _wrapperThreadOverviewItem({String label = "-", String? value}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setSp(15)),
      child: AppFormInputText(
        params: AppFormInputParams(label, ""),
        enabled: false,
        initialValue: value,
        margin: EdgeInsets.only(top: ScreenUtil().setSp(15)),
        multiLine: true,
        customeInputDecoration: PageHelper.inputDecoration().copyWith(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setSp(15),
            horizontal: ScreenUtil().setSp(30),
          ),
        ),
      ),
    );
  }
}
