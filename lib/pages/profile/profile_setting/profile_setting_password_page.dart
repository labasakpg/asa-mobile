import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/profile_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class ProfileSettingPasswordPage extends StatelessWidget {
  final c = Get.put(ProfilePageController());

  ProfileSettingPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    c.init();

    return AppContentWrapper(
      title: "Perbarui Password",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildForms(context),
    );
  }

  Widget _buildForms(BuildContext context) {
    return Obx(
      () {
        if (c.isEmailNull.isTrue) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(50)),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: ColorPalettes.tileWarningBackground,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
                child: ListTile(
                  leading: Icon(
                    Icons.info_outline_rounded,
                    color: ColorPalettes.tileWarningIcon,
                  ),
                  minLeadingWidth: ScreenUtil().setSp(30),
                  title: const AppText(
                    "Mohon tambahkan Email terlebih dahulu di halaman Profile",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        return FormBuilder(
          key: c.updatePasswordFormKey.value,
          child: Column(
            children: [
              PageHelper.buildGap(30),
              if (c.isPasswordNull.isFalse)
                AppFormInputText(
                  params: AppFormInputParams(
                    "Password Lama",
                    "currentPassword",
                  ),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(5),
                  ]),
                ),
              AppFormInputText(
                params: AppFormInputParams(
                  "Password Baru",
                  "newPassword",
                ),
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(5),
                ]),
              ),
              AppFormInputText(
                params: AppFormInputParams(
                  "Konfirmasi Password Baru",
                  "confirmPassword",
                ),
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(5),
                ]),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => c.onPressedChangePasswordButton(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalettes.homeIconSelected),
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
