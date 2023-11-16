import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/pages/branch/branch_list_page.dart';
import 'package:anugerah_mobile/pages/consultations/health_checkup_inquiry_list_page.dart';
import 'package:anugerah_mobile/pages/news/news_page.dart';
import 'package:anugerah_mobile/pages/orders/orders_page.dart';
import 'package:anugerah_mobile/pages/profile/profile_patients/profile_patients_list_page.dart';
import 'package:anugerah_mobile/pages/sponsorship-submission/sponsorship_submission_create_doctor_page.dart';
import 'package:anugerah_mobile/pages/sponsorship-submission/sponsorship_submission_create_institute_page.dart';
import 'package:anugerah_mobile/pages/sponsorship-submission/sponsorship_submission_page.dart';
import 'package:anugerah_mobile/pages/visitations/visitation_create_page.dart';
import 'package:anugerah_mobile/pages/visitations/visitation_page.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class SectionHomePage extends StatelessWidget {
  final double gap = 25;

  const SectionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget containerWrapper({
    required Widget child,
    double hMargin = 50,
    double vMargin = 0,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(hMargin),
        vertical: ScreenUtil().setSp(vMargin),
      ),
      child: child,
    );
  }

  Widget columnWrapper({required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget rowWrapper({required List<Widget> children}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget buildSectionTitle(String title) {
    return AppText(
      title,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
  }

  void onPressedMenu(HomePageMenu homePageMenu) {
    switch (homePageMenu) {
      case HomePageMenu.branch:
        Get.to(() => BranchListPage());
        break;
      case HomePageMenu.news:
        Get.to(() => NewsPage());
        break;
      case HomePageMenu.healthCheckupInquiry:
        Get.to(() => HealthCheckupInquiryListPage());
        break;
      case HomePageMenu.checkupResult:
        Get.to(() => ProfilePatientsListPage());
        break;
      case HomePageMenu.order:
        Get.to(() => const OrdersPage());
        break;
      case HomePageMenu.doctorVisitation:
        Get.to(() => VisitationPage(state: EmployeeStakeHolderState.doctor));
        break;
      case HomePageMenu.instituteVisitation:
        Get.to(() => VisitationPage(state: EmployeeStakeHolderState.institute));
        break;
      case HomePageMenu.createVisitation:
        Get.to(() => VisitationCreatePage());
        break;
      case HomePageMenu.doctorSponsorshipSubmission:
        Get.to(() =>
            SponsorshipSubmissionPage(state: EmployeeStakeHolderState.doctor));
        break;
      case HomePageMenu.instituteSponsorshipSubmission:
        Get.to(() => SponsorshipSubmissionPage(
            state: EmployeeStakeHolderState.institute));
        break;
      case HomePageMenu.createDoctorSponsorshipSubmission:
        Get.to(() => SponsorshipSubmissionCreateDoctorPage());
        break;
      case HomePageMenu.createInstituteSponsorshipSubmission:
        Get.to(() => SponsorshipSubmissionCreateInstitutePage());
        break;
      default:
        break;
    }
  }
}
