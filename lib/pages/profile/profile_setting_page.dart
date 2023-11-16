import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/app_home_controller.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/pages/orders/orders_page.dart';
import 'package:anugerah_mobile/pages/profile/profile_page.dart';
import 'package:anugerah_mobile/pages/profile/profile_setting/profile_setting_delete_account_page.dart';
import 'package:anugerah_mobile/pages/profile/profile_setting/profile_setting_password_page.dart';
import 'package:anugerah_mobile/services/api_service.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/services/location_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

enum SettingOptions {
  changeBranch,
  transactionHistory,
  updatePassword,
  deleteAccount,
  logout,
}

class ProfileSettingPage extends StatelessWidget {
  final _authService = Get.put(AuthService());
  final _locationService = Get.put(LocationService());
  final _apiService = Get.put(ApiService());
  final _appHomeController = Get.put(AppHomeController());
  final _orderController = Get.put(OrderController());

  ProfileSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: ProfilePage().backgroundColor(),
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setSp(400),
                child: ProfilePage(
                  activeAppBarButton: AppBarButton.setting,
                  hideEditIcon: true,
                ).appBar(),
              ),
              ..._buildChildren(context),
            ],
          ),
        ),
        ProfilePage.buildBackButton(context),
      ],
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    var asPatient = _authService.authData.value?.user?.asPatient;
    return [
      PageHelper.buildGap(50),
      if (asPatient != null && asPatient)
        _buildMenuItem(
          icon: Icons.store,
          label: "Ubah Cabang",
          onTap: () => _onTapHandler(SettingOptions.changeBranch),
        ),
      _buildMenuItem(
        icon: Icons.notifications_outlined,
        label: "History Transaksi",
        onTap: () => _onTapHandler(SettingOptions.transactionHistory),
      ),
      _buildMenuItem(
        icon: Icons.lock_outline,
        label: "Perbarui Password",
        onTap: () => _onTapHandler(SettingOptions.updatePassword),
      ),
      _buildMenuItem(
        icon: Icons.logout,
        label: "Logout",
        onTap: () => _onTapHandler(SettingOptions.logout),
      ),
      const Divider(),
      _buildMenuItem(
        icon: Icons.no_accounts_outlined,
        color: ColorPalettes.delete,
        textColor: Colors.white,
        label: "Hapus Akun",
        onTap: () => _onTapHandler(SettingOptions.deleteAccount),
      ),
    ];
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
    Color? textColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(50),
      ),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: ListTile(
            leading: Icon(icon, color: textColor),
            title: AppText(label, color: textColor),
            trailing: Icon(Icons.chevron_right, color: textColor),
          ),
        ),
      ),
    );
  }

  void _onTapHandler(SettingOptions options) async {
    switch (options) {
      case SettingOptions.changeBranch:
        var orderController = Get.put(OrderController());
        orderController.init();
        Get.back();
        _appHomeController.onChangePage(0);
        Future.delayed(
          const Duration(milliseconds: 100),
          () => Get.to(() => const OrdersPage()),
        );
        break;
      case SettingOptions.transactionHistory:
        Get.back();
        _appHomeController.onChangePage(3);
        break;
      case SettingOptions.updatePassword:
        Get.to(() => ProfileSettingPasswordPage());
        break;
      case SettingOptions.deleteAccount:
        Get.to(() => ProfileSettingDeleteAccountPage());
        break;
      case SettingOptions.logout:
        Get.defaultDialog(
          onConfirm: onConfirmLogout,
          textConfirm: "Yes",
          confirmTextColor: Colors.white,
          onCancel: () {},
          textCancel: "No",
          middleText: "Apakah anda yakin akan keluar?",
          title: "Logout",
        );
        break;
    }
  }

  void onConfirmLogout() async {
    try {
      EasyLoading.show(status: 'Loading', maskType: EasyLoadingMaskType.black);
      Map<String, dynamic> payload = {};
      if (!_authService.asPatient) {
        payload = await _locationService.constructToTrack();
      }
      await _apiService.signOut(payload: payload);

      EasyLoading.dismiss();
      _orderController.init();
      await _authService.removeAuthData();
    } finally {
      EasyLoading.dismiss();
    }
  }
}
