import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/controllers/profile_controller.dart';
import 'package:anugerah_mobile/services/api_service.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/services/location_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class ProfileSettingDeleteAccountPage extends StatelessWidget {
  final c = Get.put(ProfilePageController());
  final _authService = Get.put(AuthService());
  final _locationService = Get.put(LocationService());
  final _apiService = Get.put(ApiService());
  final _orderController = Get.put(OrderController());

  ProfileSettingDeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    c.init();

    return AppContentWrapper(
      title: "Hapus Akun",
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: ColorPalettes.tileWarningBackground,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline_rounded,
                        color: ColorPalettes.tileWarningIcon,
                      ),
                      minLeadingWidth: ScreenUtil().setSp(30),
                      title: const AppText(
                        """Dengan menghapus akun anda, berarti anda tidak bisa mengakses layanan Lab anugerah.

Jika anda ingin mengaktifkan kembali akun anda, anda bisa menghubungi atau mendatangi Cabang Lab anugerah terdekat.

Terima kasih.""",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      c.onPressedDeleteAccountButton(_processLogOut),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalettes.delete),
                  child: const Text("Konfirmasi"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _processLogOut() async {
    try {
      EasyLoading.show(status: 'Loading', maskType: EasyLoadingMaskType.black);
      if (!_authService.asPatient) {
        var track = await _locationService.constructToTrack();
        await _apiService.signOut(payload: track);
      }

      EasyLoading.dismiss();
      _orderController.init();
      await _authService.removeAuthData();
    } finally {
      EasyLoading.dismiss();
    }
  }
}
