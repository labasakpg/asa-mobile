import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/inquiry_controller.dart';
import 'package:anugerah_mobile/models/thread.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class HealthCheckupInquiryReplyPage extends StatelessWidget {
  final c = Get.put(InquiryController());

  final Thread thread;

  HealthCheckupInquiryReplyPage({
    super.key,
    required this.thread,
  });

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Balas Konsultasi",
      padding: EdgeInsets.zero,
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildReply(context),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    const double radius = 30;
    var borderRadius = Radius.circular(ScreenUtil().setSp(radius));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: borderRadius,
        dashPattern: const [3],
        strokeWidth: 0.5,
        color: ColorPalettes.dotBorder,
        child: InkWell(
          onTap: c.selectFile,
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
      ),
    );
  }

  Widget _buildReply(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      child: Column(
        children: [
          _buildUploadButton(context),
          _buildPreview(context),
          FormBuilder(
            key: c.formKey.value,
            child: AppFormInputText(
              params: AppFormInputParams(
                "Pesan",
                "body",
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              margin: EdgeInsets.only(bottom: ScreenUtil().setSp(15)),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(5),
                FormBuilderValidators.maxLength(190),
              ]),
              multiLine: true,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: c.submitReply,
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalettes.homeIconSelected),
              child: const Text("Kirim"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Obx(
      () {
        if (c.uploadedSlug.isEmpty) {
          return Container();
        }

        return SizedBox(
          height: ScreenUtil().setSp(300),
          width: double.infinity,
          child: AppImageNetwork(slug: c.uploadedSlug.value),
        );
      },
    );
  }
}
