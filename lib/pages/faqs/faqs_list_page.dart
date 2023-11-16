import 'package:flutter/material.dart';
import 'package:anugerah_mobile/models/faq.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/home_page/faqs_section_home_page.dart';

class FaqsListPage extends StatelessWidget {
  const FaqsListPage({
    super.key,
    required this.listData,
    this.query,
    this.id,
  });

  final List<Faq> listData;
  final String? query;
  final int? id;

  @override
  Widget build(BuildContext context) {
    List<Faq> filtered = _filterListData(listData, query);

    return AppContentWrapper(
      title: _buildLabel(query),
      padding: EdgeInsets.zero,
      child: ListView(
        children: [FaqsSectionHomePage.buildList(context, filtered)],
      ),
    );
  }

  List<Faq> _filterListData(List<Faq> listData, String? query) {
    if (id != null) {
      return listData.where((element) => element.id == id).toList();
    }

    if (query == null || query.isEmpty) {
      return listData;
    }

    return listData
        .where(
          (element) =>
              element.question!.toLowerCase().contains(query.toLowerCase()) ||
              element.answer!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  String _buildLabel(String? query) {
    if (query == null || query.length < 3 || id != null) {
      return "Frequently Asked Questions";
    }

    return query;
  }
}
