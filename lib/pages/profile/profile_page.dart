import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/bases/app_home_base.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/profile_controller.dart';
import 'package:anugerah_mobile/pages/profile/profile_qr_code_page.dart';
import 'package:anugerah_mobile/pages/profile/profile_setting_page.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_date.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_radio_group.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_photo_profile.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

enum AppBarButton {
  qrCode,
  profile,
  setting,
}

class ProfilePage extends StatelessWidget implements AppHomeBase {
  ProfilePage({
    super.key,
    this.activeAppBarButton,
    this.hideEditIcon = true,
  });

  final AppBarButton? activeAppBarButton;
  final c = Get.put(ProfilePageController());
  final bool hideEditIcon;

  @override
  Widget actionButton() {
    return Container();
  }

  @override
  Widget appBar() => PageHelper.disableVerticalDrag(
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(Assets.mainAppBarBackground),
              ),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: _buildButton(
                        "MY QR CODE",
                        alignment: Alignment.centerRight,
                        path: AssetsSVG.iconQRCode,
                        appBarButton: AppBarButton.qrCode,
                        onTap: () => _onTapAppBarButton(AppBarButton.qrCode),
                      )),
                  Expanded(
                      flex: 4,
                      child: AppPhotoProfile(hideEditIcon: hideEditIcon)),
                  Expanded(
                      flex: 2,
                      child: _buildButton(
                        "SETTING",
                        alignment: Alignment.centerLeft,
                        path: AssetsSVG.iconSetting,
                        appBarButton: AppBarButton.setting,
                        onTap: () => _onTapAppBarButton(AppBarButton.setting),
                      )),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Color? backgroundColor() => ColorPalettes.homePageBackgroundSecondary;

  @override
  List<Widget> children(BuildContext context) {
    c.init();

    return [
      _buildForms(context),
    ];
  }

  @override
  double expandedHeight() => 325;

  @override
  double? hPrefeeredSize() => null;

  @override
  String pageName() {
    return "profile";
  }

  @override
  bool? removeAppBar() => null;

  Widget _buildButton(
    String label, {
    Alignment? alignment,
    String path = "",
    VoidCallback? onTap,
    AppBarButton? appBarButton,
  }) {
    Color backgroundColor =
        activeAppBarButton != null && activeAppBarButton == appBarButton
            ? Colors.white
            : Colors.transparent;

    Color? iconColor =
        activeAppBarButton != null && activeAppBarButton == appBarButton
            ? Colors.blue
            : null;
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        margin: EdgeInsets.only(bottom: ScreenUtil().setSp(25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              backgroundColor: backgroundColor,
              child: SvgPicture.asset(path, color: iconColor),
            ),
            AppText(label, fontSize: 8, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _validateWhenTapAppBarButton() {
    if (Get.currentRoute == "/ProfileQrCodePage" ||
        Get.currentRoute == "/ProfileSettingPage") {
      Get.close(1);
    }
  }

  void _onTapAppBarButton(AppBarButton appBarButton) {
    switch (appBarButton) {
      case AppBarButton.qrCode:
        if (Get.currentRoute == "/ProfileQrCodePage") return;
        _validateWhenTapAppBarButton();
        Get.to(() => ProfileQrCodePage(qrCodeData: c.patientId));
        break;
      case AppBarButton.setting:
        if (Get.currentRoute == "/ProfileSettingPage") return;
        _validateWhenTapAppBarButton();
        Get.to(() => ProfileSettingPage());
        break;
      default:
        break;
    }
  }

  Widget _buildForms(BuildContext context) {
    return Obx(
      () => PageHelper.buildBasicWrapperContainer(
        child: FormBuilder(
          key: c.formKey.value,
          child: Column(
            children: [
              AppFormInputText(
                params: AppFormInputParams(
                  "Nama Lengkap",
                  "name",
                ),
                validator: PageHelper.basicValidator(),
                textInputAction: TextInputAction.done,
              ),
              AppFormInputDate(
                params: AppFormInputParams(
                  "Tanggal Lahir",
                  "dateOfBirth",
                ),
                validator: PageHelper.basicValidatorRequired(),
              ),
              AppFormInputRadioGroup(
                params: AppFormInputParams(
                  "Jenis Kelamin",
                  "gender",
                ),
                options: AppConfiguration.genderOptions,
                validator: PageHelper.basicValidatorRequired(),
              ),
              AppFormInputText(
                params: AppFormInputParams(
                  "Email",
                  "email",
                ),
                validator: PageHelper.basicValidatorEmail(),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              AppFormInputText(
                params: AppFormInputParams(
                  "Nomor Handphone",
                  "phoneNumber",
                ),
                validator: PageHelper.basicValidatorNumeric(),
                keyboardType: TextInputType.number,
                prefix: "+62",
              ),
              AppFormInputText(
                params: AppFormInputParams(
                  "Alamat",
                  "address",
                ),
                maxLines: 2,
                multiLine: true,
                validator: PageHelper.basicValidator(maxLength: 120),
                textInputAction: TextInputAction.done,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => c.onPressedSaveButton(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalettes.homeIconSelected),
                      child: const Text("Simpan"),
                    ),
                  ),
                  PageHelper.buildGap(20, Axis.horizontal),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: c.onPressedPatientsList,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalettes.secondaryButton),
                      child: const Text("Daftar Pasien"),
                    ),
                  ),
                ],
              ),
              PageHelper.buildGap(50),
              AppText(
                "** Jika anda sebagai pasien dan ingin "
                "mendaftarkan keluarga Anda, klik tombol “Tambah Pasien”",
                textAlign: TextAlign.center,
                color: ColorPalettes.textInputClear,
              ),
              PageHelper.buildGap(50),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Widget? contentWrapper(BuildContext context) => null;

  static Widget buildBackButton(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color iconColor = ColorPalettes.homeIconSelected;

    return Container(
      height: ScreenUtil().setSp(90),
      margin: EdgeInsets.only(
        top: ScreenUtil().setSp(100),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: backgroundColor,
        ),
        padding: EdgeInsets.zero,
        onPressed: () => Get.close(1),
        icon: const Icon(Icons.arrow_back_rounded),
        color: iconColor,
        iconSize: ScreenUtil().setSp(18 * 3),
      ),
    );
  }
}
