import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/bases/app_home_base.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/app_home_controller.dart';
import 'package:anugerah_mobile/controllers/faqs_controller.dart';
import 'package:anugerah_mobile/pages/faqs/faqs_list_page.dart';
import 'package:anugerah_mobile/pages/register/register_agreement_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_bottom_navigation_bar.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/home_page/faqs_section_home_page.dart';

class FaqsPage extends StatelessWidget implements AppHomeBase {
  FaqsPage({super.key});

  final c = Get.put(FaqsController());
  final appHomeController = Get.put(AppHomeController());

  @override
  Widget actionButton() => Container();

  @override
  Widget appBar() => Container();

  @override
  Color? backgroundColor() => Colors.white;

  @override
  List<Widget> children(BuildContext context) => [];

  @override
  double expandedHeight() => 0;

  @override
  double? hPrefeeredSize() => 0;

  @override
  String? pageName() => "Faqs";

  @override
  bool? removeAppBar() => null;

  List<Widget> _buildChildren(BuildContext context) {
    c.init();

    return [
      _buildSearchbar(),
      PageHelper.buildGap(15),
      _buildCustomSection(),
      FaqsSectionHomePage(
        showViewAllButton: true,
        popularItems: c.getPopularList(),
        onPressedViewAll: () =>
            Get.to(() => FaqsListPage(listData: c.listData)),
      ),
    ];
  }

  Widget _buildSearchbar() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: FormBuilder(
          key: c.searchFormKey.value,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(30)),
                child: FocusScope(
                  child: AppFormInputText(
                    params: AppFormInputParams(
                      "",
                      "search",
                    ),
                    prefixWidget: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: "Masukkan Kata Kunci",
                    margin: EdgeInsets.zero,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(3),
                    ]),
                    onEditingComplete: c.onEditingComplete,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setSp(30),
        bottom: ScreenUtil().setSp(30),
      ),
      child: Column(
        children: [
          AppContentWrapper.buildTitle(title: "Frequently Asked Questions"),
          const AppText(
            "Apa yang dapat Kami bantu?",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget _buildCustomSection() {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setSp(30),
        right: ScreenUtil().setSp(30),
        top: ScreenUtil().setSp(30),
        bottom: ScreenUtil().setSp(50),
      ),
      height: ScreenUtil().setSp(350),
      child: Row(
        children: [
          _buildItemSection(
            label: "Cara Penggunaan",
            icon: Icons.notifications_none,
            color: ColorPalettes.faq1,
            iconColor: ColorPalettes.homeIconSelected,
            onTap: () => Get.to(() => FaqsListPage(
                  listData: c.listData,
                  id: 7,
                )),
          ),
          _buildItemSection(
            label: "Syarat & Ketentuan",
            icon: Icons.chrome_reader_mode_outlined,
            color: ColorPalettes.faq2,
            iconColor: ColorPalettes.tileWarningIcon,
            onTap: () => Get.to(() => const RegisterAgreementPage(
                  agreementType: AgreementType.tnc,
                  previewMode: true,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildItemSection({
    required String label,
    required Color color,
    required Color iconColor,
    required IconData icon,
    GestureTapCallback? onTap,
  }) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(15)),
            padding: EdgeInsets.all(ScreenUtil().setSp(30)),
            decoration: PageHelper.buildRoundBox(
              radius: 30,
              color: color,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: ScreenUtil().setSp(100),
                ),
                PageHelper.buildGap(30),
                AppText(
                  "Pertanyaan Tentang",
                  fontSize: 11,
                  color: ColorPalettes.textInputClear,
                ),
                AppText(label),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget? contentWrapper(BuildContext context) {
    // double expandedHeight = 450;
    // double hPrefeeredSize = 100;
    // if (Platform.isIOS) {
    //   expandedHeight = 0;
    //   hPrefeeredSize = 0;
    // }

    return AppContentWrapper(
      titleWidget: _buildTitle(context),
      hideLeading: true,
      padding: EdgeInsets.zero,
      bottomNavigationBar: AppBottomNavigationBar(),
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return SingleChildScrollView(
      controller: appHomeController.scrollController,
      child: Column(
        children: _buildChildren(context),
      ),
    );
  }
}
