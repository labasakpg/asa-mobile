import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/patient_controller.dart';
import 'package:anugerah_mobile/models/relative.dart';
import 'package:anugerah_mobile/pages/checkup_results/checkup_results_page.dart';
import 'package:anugerah_mobile/pages/profile/profile_patients/profile_patients_form_page.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_photo_profile.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class ProfilePatientsListPage extends StatelessWidget {
  final c = Get.put(PatienController());
  final authService = Get.put(AuthService());

  ProfilePatientsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "List Data Pasien",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    c.init();

    return Obx(
      () {
        if (c.listData.isEmpty) {
          return PageHelper.simpleCircularLoading();
        }

        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: .7,
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
          children: [
            ...c.listData.map((data) => _buildItem(relative: data)).toList(),
            _buildCreateButton(),
          ],
        );
      },
    );
  }

  Widget _buildItem({required Relative relative}) {
    var photoSize = ScreenUtil().setSp(250);
    var isCurrentUser = relative.userId != authService.authData.value?.user?.id;

    return _itemWrapper(
      children: [
        AppPhotoProfile(
          hideName: true,
          mainAxisAlignment: MainAxisAlignment.center,
          circleRadiusSU: 200,
          width: photoSize,
          height: photoSize,
          customSlug: relative.personalData?.photo?.slug,
          forceCustomSlug: true,
        ),
        PageHelper.buildGap(),
        AppText(
          relative.personalData?.name ?? "-",
          fontWeight: FontWeight.bold,
          fontSize: 11,
          overflow: TextOverflow.ellipsis,
        ),
        AppText(
          "eKTP: ${relative.personalData?.ktp == null || relative.personalData?.ktp == 'null' ? '-' : relative.personalData?.ktp}",
          fontSize: 10,
          overflow: TextOverflow.ellipsis,
        ),
        Column(
          children: [
            _buildButton(
              label: "Lihat",
              width: double.infinity,
              color: Colors.white,
              backgroundColor: ColorPalettes.homeIconSelected,
              onPressed: (relative.patientId ?? relative.patient?.id) == null
                  ? null
                  : () => Get.to(() => CheckupResultsPage(
                        patientId: relative.patientId == null
                            ? relative.patient!.id!
                            : relative.patientId!,
                        patientName: relative.personalData?.name ?? "",
                      )),
            ),
            PageHelper.buildGap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(
                  label: "Edit",
                  color: ColorPalettes.tileContent,
                  backgroundColor: ColorPalettes.buttonSecondary,
                  onPressed: () => _onPressedOpenPatientFormPage(relative),
                ),
                _buildButton(
                  label: "Hapus",
                  color: Colors.white,
                  backgroundColor: ColorPalettes.delete,
                  onPressed: isCurrentUser
                      ? null
                      : () => _onPressedRemovePatientFormPage(relative),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return _itemWrapper(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () => _onPressedOpenPatientFormPage(null),
            child: Column(
              children: [
                const Icon(Icons.add_circle_outline),
                PageHelper.buildGap(),
                const AppText(
                  "Tambah Pasien",
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ],
            )),
      ],
    );
  }

  Widget _itemWrapper({
    List<Widget> children = const [],
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) {
    return Container(
      decoration: PageHelper.buildRoundBox(
        radius: 20,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(ScreenUtil().setSp(15)),
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      ),
    );
  }

  Widget _buildButton({
    VoidCallback? onPressed,
    required Color color,
    required Color backgroundColor,
    required String label,
    double width = 150,
    double height = 80,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(
          ScreenUtil().setSp(width),
          ScreenUtil().setSp(height),
        ),
      ),
      child: AppText(
        label,
        fontSize: 11,
        color: color,
      ),
    );
  }

  Future<void> _onPressedOpenPatientFormPage(Relative? relative) async {
    await Get.to(() => ProfilePatientsFormPage(relative: relative));
    c.init();
  }

  void _onPressedRemovePatientFormPage(Relative? relative) async {
    Get.defaultDialog(
      onConfirm: () {
        c.removeRelative(relative!);
        Get.back();
      },
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      textCancel: "No",
      middleText: "Apakah anda yakin untuk menghapus data?",
      title: "Hapus Relasi Pasien",
    );
  }
}
