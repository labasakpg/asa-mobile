import 'package:anugerah_mobile/bases/app_home_base.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/app_controller.dart';
import 'package:anugerah_mobile/models/about_us.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AboutUsPage extends StatelessWidget implements AppHomeBase {
  AboutUsPage({super.key});

  final _appController = Get.put(AppController());

  @override
  Widget actionButton() {
    return Container();
  }

  @override
  Widget appBar() => Container();

  @override
  Color? backgroundColor() {
    return Colors.white;
  }

  @override
  List<Widget> children(BuildContext context) {
    return [
      _buildHeader(),
      _buildChildren(),
    ];
  }

  @override
  double expandedHeight() {
    return 0;
  }

  @override
  double? hPrefeeredSize() => null;

  @override
  String? pageName() {
    return "About Us";
  }

  @override
  bool? removeAppBar() => true;

  Widget _buildHeader() {
    return SizedBox(
      height: ScreenUtil().setSp(750),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: AppConfiguration.radiusCircular50,
          bottomRight: AppConfiguration.radiusCircular50,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Assets.mainAppAboutUs),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildren() {
    AboutUs? aboutUs = _appController.aboutUs;

    if (aboutUs == null) {
      return const Center(
        child: AppText("Cannot load data"),
      );
    }

    return Padding(
      padding: AppConfiguration.horizontalPadding50,
      child: Column(
        children: [
          Padding(
            padding: AppConfiguration.verticalPadding30,
            child: const AppText(
              "Lab Anugerah Pusat - Kabanjahe",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorPalettes.simpleBox1Fill,
              borderRadius: BorderRadius.all(AppConfiguration.radiusCircular30),
            ),
            child: Column(
              children: [
                _buildPrimaryItem(
                    title: aboutUs.introduction.title,
                    body: aboutUs.introduction.body),
                _buildPrimaryItem(
                    title: aboutUs.tagline.title, body: aboutUs.tagline.body),
                _buildPrimaryItem(
                    title: aboutUs.vision.title, body: aboutUs.vision.body),
                _buildPrimaryItem(
                    title: aboutUs.mission.title,
                    body: aboutUs.mission.body,
                    hideDivider: true),
              ],
            ),
          ),
          PageHelper.buildGap(),
          Column(
            children: [
              _buildSecondaryItem(
                  icon: Icons.place_outlined, body: aboutUs.address.body),
              _buildSecondaryItem(
                  icon: Icons.public, body: aboutUs.website.body, asLink: true),
              _buildSecondaryItem(icon: Icons.phone, body: aboutUs.phone.body),
              _buildSecondaryItem(
                  icon: Icons.phone_android, body: aboutUs.whatsapp.body),
            ],
          ),
          _buildFooter(aboutUs),
        ],
      ),
    );
  }

  Widget _buildPrimaryItem(
      {required String title, required String body, bool hideDivider = false}) {
    return Column(
      children: [
        Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: ColorPalettes.textSecodary,
            collapsedIconColor: ColorPalettes.textSecodary,
            textColor: ColorPalettes.textSecodary,
            collapsedTextColor: ColorPalettes.textSecodary,
            expandedAlignment: Alignment.centerLeft,
            title: AppText(title, fontWeight: FontWeight.bold),
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AppConfiguration.horizontalPadding50.horizontal,
                  right: AppConfiguration.horizontalPadding50.horizontal,
                  bottom: AppConfiguration.verticalPadding30.vertical,
                ),
                // child: AppText(content),
                child: MarkdownBody(data: body),
              )
            ],
          ),
        ),
        if (!hideDivider)
          Padding(
            padding: AppConfiguration.horizontalPadding50,
            child: Divider(
              height: ScreenUtil().setSp(15),
            ),
          ),
      ],
    );
  }

  Widget _buildSecondaryItem(
      {required IconData icon, required String body, bool asLink = false}) {
    final padding = ScreenUtil().setSp(30);
    final iconSize = ScreenUtil().setSp(63);

    return InkWell(
      onTap: () {
        if (asLink) {
          PageHelper.openUrl(body);
        }
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Icon(
                icon,
                color: ColorPalettes.textHint,
                size: iconSize,
              ),
            ),
            PageHelper.buildGap(20, Axis.horizontal),
            Flexible(
              flex: 5,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      body,
                      color: ColorPalettes.tileContent,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(AboutUs aboutUs) {
    return Padding(
      padding: AppConfiguration.verticalPadding30,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Divider(color: Colors.black)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: AppText("Our Social Media", fontSize: 12),
              ),
              Expanded(child: Divider(color: Colors.black)),
            ],
          ),
          PageHelper.buildGap(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterItem(
                  assetPath: AssetsSVG.socialMediaTiktok,
                  link: aboutUs.tiktok.body),
              PageHelper.buildGap(20, Axis.horizontal),
              _buildFooterItem(
                  assetPath: AssetsSVG.socialMediaInstagram,
                  link: aboutUs.instagram.body),
              PageHelper.buildGap(20, Axis.horizontal),
              _buildFooterItem(
                  assetPath: AssetsSVG.socialMediaFacebook,
                  link: aboutUs.facebook.body),
            ],
          ),
          PageHelper.buildGap(),
        ],
      ),
    );
  }

  _buildFooterItem({required String assetPath, required String link}) {
    return InkWell(
      onTap: () => PageHelper.openUrl(link),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        child: SizedBox.square(
          dimension: ScreenUtil().setSp(85),
          child: SvgPicture.asset(assetPath),
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
}
