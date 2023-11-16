import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/health_checkup_inquiry_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';

class HealthCheckupInquiryCreatePage extends StatelessWidget {
  final c = Get.put(HealthCheckupInquiryController());

  HealthCheckupInquiryCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      childPaddingHorizontal: 30,
      title: "Buat Konsultasi Baru",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Obx(
      () => PageHelper.buildBasicWrapperContainer(
        child: FormBuilder(
          key: c.formKey.value,
          child: Column(
            children: [
              AppFormInputText(
                params: AppFormInputParams(
                  "Judul",
                  "title",
                ),
                validator: PageHelper.basicValidator(),
                textInputAction: TextInputAction.done,
              ),
              AppFormInputText(
                params: AppFormInputParams(
                  "Deskripsi",
                  "description",
                ),
                maxLines: 2,
                multiLine: true,
                validator: PageHelper.basicValidator(maxLength: 120),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => c.onPressedCreateThreadButton(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalettes.homeIconSelected),
                  child: const Text("Buat"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
