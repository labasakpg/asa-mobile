import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/services/api_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class CheckupResultDetailPage extends StatelessWidget {
  CheckupResultDetailPage({
    super.key,
    required this.checkupResultId,
    required this.patientId,
    required this.doctorId,
    required this.description,
  });

  final apiService = Get.put(ApiService());
  final String checkupResultId;
  final String patientId;
  final String doctorId;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Detail Hasil Online",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    var url = "${apiService.baseUrl}/checkup-results/$checkupResultId/"
        "$patientId/$doctorId/$description/file";
    printInfo(info: "CheckupResult Preview url: $url");

    return SizedBox(
      height: ScreenUtil().screenHeight,
      width: double.infinity,
      child: FutureBuilder<File>(
        future: DefaultCacheManager().getSingleFile(url),
        builder: (context, snapshot) => snapshot.hasData
            ? PdfViewer.openFile(snapshot.data!.path)
            : Center(
                child: PageHelper.simpleCircularLoading(),
              ),
      ),
    );
  }
}
