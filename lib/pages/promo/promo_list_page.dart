import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/promo_controller.dart';
import 'package:anugerah_mobile/models/promo.dart';
import 'package:anugerah_mobile/pages/promo/promo_detail_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_search.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class PromoListPage extends StatefulWidget {
  const PromoListPage({
    super.key,
    this.showUsePromoButton = false,
    this.onSelectPromo,
  });

  final bool showUsePromoButton;
  final Function(Promo)? onSelectPromo;

  @override
  State<PromoListPage> createState() => _PromoListPageState();
}

class _PromoListPageState extends State<PromoListPage> {
  final c = Get.put(PromoController());

  @override
  void initState() {
    super.initState();
    c.fetchData();
  }

  @override
  void dispose() {
    c.onSearchClear(skipInitLoading: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "List Promo",
      childPaddingHorizontal: 0.0,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
          child: AppSearch(
            hintText: "Cari Promo",
            onClear: c.onSearchClear,
            onSubmitted: c.onSearchSubmit,
          ),
        ),
        _buildList(context),
      ],
    );
  }

  Widget _buildPromoItem(
    BuildContext context,
    Promo promo, {
    bool hideBanner = false,
  }) {
    final radius = Radius.circular(ScreenUtil().setSp(50));
    const imageH = 400;

    return Container(
      decoration: PageHelper.buildRoundBox(
        radius: 50,
        borderColor: ColorPalettes.textHint,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(50),
        vertical: ScreenUtil().setSp(25),
      ),
      child: Column(
        children: [
          if (promo.banner != null || hideBanner)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
              child: AppImageNetwork(
                slug: promo.banner?.slug,
                marginAll: 0,
                height: ScreenUtil().setSp(imageH),
                fit: BoxFit.fitWidth,
                width: double.infinity,
                radius: 0,
              ),
            ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ScreenUtil().setSp(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  promo.title ?? "-",
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  fontSize: 14,
                ),
                PageHelper.buildGap(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText("Periode Promo", fontSize: 12),
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 17),
                                PageHelper.buildGap(20, Axis.horizontal),
                                AppText(
                                  "${PageHelper.formatDate(promo.startAt, 'dd MMMM')}"
                                  " - "
                                  "${PageHelper.formatDate(promo.expiredAt, 'dd MMMM')}",
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText("Kode Promo", fontSize: 12),
                            Row(
                              children: [
                                const Icon(Icons.card_giftcard_outlined,
                                    size: 17),
                                PageHelper.buildGap(20, Axis.horizontal),
                                AppText(
                                  PromoDetailPage.buildPromoCodeInfo(promo),
                                  color: ColorPalettes.appPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        if (super.widget.showUsePromoButton)
                          SizedBox(
                            height: ScreenUtil().setSp(75),
                            child: ElevatedButton(
                              onPressed: () => onPressedUsePromo(promo),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPalettes.appPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(15)),
                                ),
                              ),
                              child: const AppText("Gunakan", fontSize: 12),
                            ),
                          ),
                        PageHelper.buildGap(30),
                        SizedBox(
                          height: ScreenUtil().setSp(75),
                          child: ElevatedButton(
                            onPressed: () => Get.to(
                              () => PromoDetailPage(promo: promo),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalettes.appPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(15)),
                              ),
                            ),
                            child: const AppText("Lihat Detail", fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Obx(() {
      if (c.isLoadingPromoData.isFalse &&
          c.promoData.isEmpty &&
          c.filterPromo.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: PageHelper.emptyDataResponse(),
        );
      }

      return Expanded(
        child: ListView(
          children: c.promoData
              .map((data) => _buildPromoItem(context, data))
              .toList(),
        ),
      );
    });
  }

  void onPressedUsePromo(Promo promo) {
    super.widget.onSelectPromo!(promo);
  }
}
