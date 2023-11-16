import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/promo.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/promos_service.dart';

class PromoController extends BaseController {
  final _service = Get.put(PromosService());
  var promoData = RxList<Promo>.empty(growable: true);
  var promoCarouselData = RxList<Promo>.empty(growable: true);
  var isLoadingPromoData = RxBool(false);
  var filterPromo = RxString("");
  var isLoadingPromoCarouselData = RxBool(false);
  var scrollControllerListNewsPage = ScrollController();

  Future<void> onSearchSubmit(String? val) async {
    filterPromo(val ?? "");
    fetchData(skipInitLoading: false);
  }

  void onSearchClear({bool skipInitLoading = false}) {
    filterPromo("");
    fetchData(skipInitLoading: skipInitLoading);
  }

  void fetchData({bool skipInitLoading = true}) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (isLoadingPromoData.isTrue) {
          return null;
        }
        isLoadingPromoData(true);

        wrapperApiCall(
          Future(() async {
            final res = await _service.getAll(
              QueryService(
                useQuery: true,
                page: 1,
                take: 150,
                search: filterPromo.value,
                customeQuery: {
                  "sortBy": "desc",
                  "includes": "banner",
                  "isExpired": false,
                },
              ),
            );

            final resData = Promo.toList(res.data['data']);
            promoData.clear();
            promoData.addAll(resData);
          }),
          finallyCallback: () => isLoadingPromoData(false),
          showSuccess: false,
          skipInitLoading: skipInitLoading,
        );
      },
    );
  }

  void fetchPromoCarousel() {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (isLoadingPromoCarouselData.isTrue) {
          return null;
        }
        isLoadingPromoCarouselData(true);

        return wrapperApiCall(
          Future(() async {
            final res = await _service.getAll(
              QueryService(
                useQuery: true,
                page: 1,
                take: 3,
                customeQuery: {
                  "sortBy": "desc",
                  "includes": "banner",
                  "isExpired": false,
                },
              ),
            );

            final resData = Promo.toList(res.data['data']);
            promoCarouselData.clear();
            promoCarouselData.addAll(resData);
          }),
          showSuccess: false,
          skipInitLoading: true,
          finallyCallback: () => isLoadingPromoCarouselData(false),
        );
      },
    );
  }
}
