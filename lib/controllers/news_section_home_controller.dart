import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/base_controller.dart';
import 'package:anugerah_mobile/models/news.dart';
import 'package:anugerah_mobile/services/base_service.dart';
import 'package:anugerah_mobile/services/news_service.dart';

class NewsSectionHomeController extends BaseController {
  final NewsService _service = Get.put(NewsService());

  RxBool isLoading = RxBool(true);
  RxBool isEmptyResult = RxBool(false);
  RxList<News> listData = RxList.empty(growable: true);

  void fetchNews([int take = 1]) {
    wrapperApiCall(
      Future(() async {
        listData.clear();
        isLoading(true);

        final res = await _service.getAll(QueryService(
          useQuery: true,
          page: 1,
          take: take,
          orderBy: 'createdAt',
          sortBy: 'desc',
          selects: ['id', 'title', 'body', 'banner', 'createdAt'],
          customeQuery: {
            "hasPromo": false,
          },
        ));
        final resData = News.toList(res.data['data']);

        if (resData.isEmpty) {
          isEmptyResult(true);
        } else {
          listData.addAll(resData);
        }
      }),
      finallyCallback: () => isLoading(false),
      skipInitLoading: true,
      showSuccess: false,
    );
  }
}
