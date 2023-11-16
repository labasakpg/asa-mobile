import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/promo_controller.dart';
import 'package:anugerah_mobile/pages/promo/promo_detail_page.dart';
import 'package:anugerah_mobile/pages/promo/promo_list_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/home_page/section_home_page.dart';

class PromoSectionHomePage extends SectionHomePage {
  PromoSectionHomePage({
    super.key,
    this.hideLabel = true,
  });

  final c = Get.put(PromoController());
  final bool hideLabel;

  @override
  Widget build(BuildContext context) {
    c.fetchPromoCarousel();

    return _buildCarousel(context);
  }

  Widget _buildCarousel(BuildContext context) {
    double hCarousel = 430;

    return Column(
      children: [
        if (!hideLabel)
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setSp(15),
              left: ScreenUtil().setSp(100),
              right: ScreenUtil().setSp(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildSectionTitle("Promo Berlangsung"),
                PageHelper.viewAllButton(
                  onPressed: () => Get.to(() => const PromoListPage()),
                )
              ],
            ),
          ),
        Obx(() {
          if (c.isLoadingPromoCarouselData.isTrue) {
            return SizedBox(
              height: ScreenUtil().setSp(hCarousel),
              child: Center(
                child: PageHelper.simpleCircularLoading(),
              ),
            );
          }

          return CarouselSlider(
            options: CarouselOptions(
              height: ScreenUtil().setSp(hCarousel),
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
            ),
            items: c.promoCarouselData.map((data) {
              var radius = Radius.circular(ScreenUtil().setSp(50));
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () => Get.to(() => PromoDetailPage(promo: data)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: radius,
                        bottomRight: radius,
                      ),
                      child: AbsorbPointer(
                        child: AppImageNetwork(
                          slug: data.banner?.slug,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
