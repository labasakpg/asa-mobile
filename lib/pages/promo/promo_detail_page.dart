import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/models/promo.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class PromoDetailPage extends StatelessWidget {
  final int? id;
  final Promo? promo;

  const PromoDetailPage({
    super.key,
    this.id,
    this.promo,
  });

  @override
  Widget build(BuildContext context) {
    if (id == null && promo == null) {
      return PageHelper.emptyDataResponse();
    }

    return AppContentWrapper(
      appbarBackgroundColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: "",
      extendBodyBehindAppBar: true,
      padding: EdgeInsets.zero,
      child: _buildChild(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    var radius = Radius.circular(ScreenUtil().setSp(50));
    return SizedBox(
      height: ScreenUtil().setSp(650),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: radius,
          bottomRight: radius,
        ),
        child: AppImageNetwork(
          slug: promo!.banner?.slug,
          fit: BoxFit.contain,
          radius: 0,
          marginAll: 0,
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          PageHelper.buildGap(30),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    const int paddingH = 50;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(paddingH)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            promo?.title ?? "-",
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          PageHelper.buildGap(15),
          AppText(
            PageHelper.formatDate(promo?.updatedAt),
            fontSize: 14,
            color: ColorPalettes.homeIconSelected,
            fontWeight: FontWeight.bold,
          ),
          buildPromoValueSection(promo),
          PageHelper.buildGap(15),
          const AppText(
            "Deskripsi",
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          Html(data: promo?.description),
          const AppText(
            "Syarat dan Ketentuan",
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          Html(data: promo?.tnc),
          // if (promo?.promo != null)
          PageHelper.buildGap(30),
        ],
      ),
    );
  }

  Widget buildPromoValueSection(Promo? promo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const AppText(
          "Kode Promo: ",
          fontSize: 14,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              PromoDetailPage.buildPromoCodeInfo(promo),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              iconSize: ScreenUtil().setSp(70),
              onPressed: () async {
                var promoCode = promo?.code ?? '-';
                await Clipboard.setData(ClipboardData(text: promoCode));
                await EasyLoading.showToast(
                    "Kode Promo\n$promoCode\nberhasil di-copy");
              },
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  static String buildPromoCodeInfo(Promo? promo) {
    String promoValue = "-";
    if (promo?.type == "AMOUNT") {
      promoValue = PageHelper.currencyFormat(promo?.value);
    } else if (promo?.type == "PERCENTAGE") {
      promoValue = "${promo?.value?.toInt()}%";
    }

    return "${promo?.code} | $promoValue";
  }
}
