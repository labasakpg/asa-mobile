import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/checkup_result_controller.dart';
import 'package:anugerah_mobile/models/checkup_result.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class CheckupResultsPage extends StatelessWidget {
  CheckupResultsPage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  final c = Get.put(CheckupResultController());
  final String patientId;
  final String patientName;

  Widget _buildData(BuildContext context) {
    return Obx(() {
      if (c.isLoadingInit.isTrue) {
        return PageHelper.simpleCircularLoading();
      }

      if (c.listData.isEmpty) {
        return PageHelper.emptyDataResponse();
      }

      return SingleChildScrollView(
        child: Column(
          children: c.listData.map((data) => _buildItem(data)).toList(),
        ),
      );
    });
  }

  Widget _buildItem(CheckupResult checkupResult) {
    return Container(
      decoration: PageHelper.buildRoundBox(
        radius: AppConfiguration.radiusAllPlain30,
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(25)),
      padding: EdgeInsets.all(ScreenUtil().setSp(50)),
      child: Column(
        children: [
          _buildLabelSection(
            label: "Nama",
            value: checkupResult.patient?.name ?? "-",
          ),
          _buildLabelSection(
            label: "Tgl Transaksi",
            value: PageHelper.formatDate(
              checkupResult.checkUpDate,
              "EEE, d MMM yyyy",
            ),
          ),
          _buildLabelSection(label: "No LAB", value: checkupResult.id),
          const Divider(),
          _buildFileSection(
            id: checkupResult.id,
            label: "${checkupResult.description}",
            date: PageHelper.formatDate(
              checkupResult.checkUpDate,
              'yyyy-MM-dd hh:mm',
            ),
            checkupResult: checkupResult,
          ),
        ],
      ),
    );
  }

  Widget _buildLabelSection({
    required String label,
    String? value,
  }) {
    return Row(
      children: [
        SizedBox(
          width: ScreenUtil().setSp(275),
          child: AppText(label, fontWeight: FontWeight.bold),
        ),
        AppText(": $value", fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget _buildFileSection({
    String? label,
    String? date,
    String? id,
    CheckupResult? checkupResult,
  }) {
    return Container(
      decoration: PageHelper.buildRoundBox(
        radius: AppConfiguration.radiusAllPlain30,
        color: ColorPalettes.checkupResultBackground,
      ),
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setSp(30),
        horizontal: ScreenUtil().setSp(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => c.previewHandler(
              id: id,
              patientId: patientId,
              doctorId: checkupResult?.doctorId,
              description: checkupResult?.description,
            ),
            child: SvgPicture.asset(AssetsSVG.iconPDF),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () => c.previewHandler(
                id: id,
                patientId: patientId,
                doctorId: checkupResult?.doctorId,
                description: checkupResult?.description,
              ),
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(25)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      label ?? "",
                      fontSize: 12,
                      color: Colors.black54,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    AppText(
                      date ?? "",
                      fontSize: 12,
                      color: Colors.black54,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // InkWell(
          //   onTap: () => c.downloadHandler(
          //     id: id,
          //     patientId: patientId,
          //     doctorId: checkupResult?.doctorId,
          //     description: checkupResult?.description,
          //     label: label,
          //     patientName: checkupResult?.patient?.name ?? patientName,
          //   ),
          //   child: Icon(Icons.download, color: ColorPalettes.homeIconSelected),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Hasil Online",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    c.init(patientId);

    return _buildData(context);
  }
}
