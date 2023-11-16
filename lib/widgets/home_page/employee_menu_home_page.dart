import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/controllers/attendance_controller.dart';
import 'package:anugerah_mobile/services/auth_service.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/home_page/section_home_page.dart';

class EmployeeMenuHomePage extends SectionHomePage {
  final c = Get.put(AuthService());
  final _attendanceController = Get.put(AttendanceController());

  EmployeeMenuHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAllowToAccessMenu = c.authData.value?.user?.roles
            .map((e) => e.name)
            .where((element) =>
                element == "MARKETING" || element == "BRANCH_MANAGER")
            .isNotEmpty ??
        false;

    return containerWrapper(
      child: columnWrapper(
        children: [
          buildSectionTitle("Attendance"),
          PageHelper.buildGap(gap),
          rowWrapper(
            children: [
              _buildMenu(
                context,
                title: "Clock In",
                icon: Icons.timer,
                homePageMenu: HomePageMenu.doctorVisitation,
                colors: [ColorPalettes.appPrimary],
                onPressed: _attendanceController.clockInHandler,
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Clock Out",
                icon: Icons.timer_off,
                homePageMenu: HomePageMenu.createVisitation,
                colors: [ColorPalettes.appPrimary],
                onPressed: _attendanceController.clockOutHandler,
              ),
            ],
          ),
          PageHelper.buildGap(gap),
          buildSectionTitle("Kunjungan"),
          PageHelper.buildGap(gap),
          rowWrapper(
            children: [
              _buildMenu(
                context,
                title: "Kunjungan\nDokter",
                icon: Icons.calendar_month_outlined,
                homePageMenu: HomePageMenu.doctorVisitation,
                colors: [ColorPalettes.appPrimary],
                disabled: !isAllowToAccessMenu,
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Kunjungan\nPerusahaan",
                icon: Icons.calendar_month_outlined,
                homePageMenu: HomePageMenu.instituteVisitation,
                colors: [ColorPalettes.appPrimary],
                disabled: !isAllowToAccessMenu,
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Buat\nKunjungan",
                icon: Icons.add_location_alt,
                homePageMenu: HomePageMenu.createVisitation,
                colors: [ColorPalettes.appPrimary],
                disabled: !isAllowToAccessMenu,
              ),
            ],
          ),
          PageHelper.buildGap(gap),
          buildSectionTitle("Penyerahan Sponsor"),
          PageHelper.buildGap(gap),
          rowWrapper(
            children: [
              _buildMenu(
                context,
                title: "Sponsor\nDokter\n",
                icon: Icons.wallet_outlined,
                homePageMenu: HomePageMenu.doctorSponsorshipSubmission,
                colors: [ColorPalettes.appPrimary],
                disabled: !isAllowToAccessMenu,
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Sponsor\nPerusahaan\n",
                icon: Icons.wallet_outlined,
                homePageMenu: HomePageMenu.instituteSponsorshipSubmission,
                colors: [ColorPalettes.appPrimary],
                disabled: !isAllowToAccessMenu,
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Buat\nSponsor\nDokter",
                icon: Icons.add_moderator_rounded,
                homePageMenu: HomePageMenu.createDoctorSponsorshipSubmission,
                colors: [ColorPalettes.appPrimary],
                disabled: !isAllowToAccessMenu,
              ),
              PageHelper.buildGap(gap, Axis.horizontal),
              _buildMenu(
                context,
                title: "Buat\nSponsor\nPerusahaan",
                icon: Icons.add_card_rounded,
                homePageMenu: HomePageMenu.createInstituteSponsorshipSubmission,
                colors: [ColorPalettes.appPrimary],
                disabled: !isAllowToAccessMenu,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildMenu(
    BuildContext context, {
    required String title,
    required HomePageMenu homePageMenu,
    required List<Color> colors,
    required IconData icon,
    bool disabled = false,
    Color borderColor = Colors.transparent,
    Color titleColor = Colors.white,
    double iconSize = 75,
    double titleSize = 12,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          if (onPressed != null) {
            onPressed();
            return;
          }
          if (disabled) {
            EasyLoading.showToast("Tidak memiliki akses untuk menu ini");
          } else {
            onPressedMenu(homePageMenu);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: colors.length == 1
                ? (disabled ? Colors.black26 : colors.first)
                : null,
            gradient: colors.length > 1
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: colors,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PageHelper.buildGap(),
              AppText(
                title,
                fontSize: titleSize,
                color: titleColor,
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(color: Colors.white),
              ),
              Icon(
                icon,
                size: ScreenUtil().setSp(iconSize),
                color: titleColor,
              ),
              PageHelper.buildGap(),
            ],
          ),
        ),
      ),
    );
  }
}
