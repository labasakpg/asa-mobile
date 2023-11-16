import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/news_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/home_page/news_section_home_page.dart';

class NewsListPage extends StatefulWidget {

  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final c = Get.put(NewsController());


  @override
  void initState() {
    super.initState();
    c.init();
  }

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Berita",
      childPaddingHorizontal: 0.0,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {

    return Obx(
      () {
        if (c.listData.isEmpty && c.isLoadingInit.isFalse) {
          return PageHelper.emptyDataResponse();
        }

        return SingleChildScrollView(
          controller: c.scrollControllerListNewsPage,
          child: Column(
            children: [
              ...c.listData
                  .map((news) =>
                      NewsSectionHomePage.buildNewsItem(context, news))
                  .toList(),
              if (c.isLoadingInit.isTrue)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: PageHelper.simpleCircularLoading(),
                ),
            ],
          ),
        );
      },
    );
  }
}
