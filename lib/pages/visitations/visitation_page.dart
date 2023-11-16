import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/controllers/visitation_controller.dart';
import 'package:anugerah_mobile/models/visitation.dart';
import 'package:anugerah_mobile/pages/visitations/visitation_detail_page.dart';
import 'package:anugerah_mobile/utils/employee_stake_holder_state_converter.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_bar_builder.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';

class VisitationPage extends StatelessWidget {
  final EmployeeStakeHolderState state;
  final c = Get.put(VisitationsController());

  VisitationPage({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    c.setEmployeeMenuState(state);
    return AppbarWrapper(
      topSafeArea: false,
      useDashboardAppbar: true,
      useCustomeAppbar: true,
      customeAppBarFlexibleSpace: AppBarBuilder.buildBasicAppbar(
        label:
            "Kunjungan ${EmployeeStakeHolderStateConverter.toLabel(state)}",
        withBackground: false,
        textColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      iconMargin: 40,
      iconSize: 18,
      expandedHeight: 0,
      hPrefeeredSize: 0,
      pinned: true,
      scrollController: c.scrollControllerVisitationsPage,
      actions: _buildActions(context),
      children: _buildChildren(context),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      _buildSearchbar(),
      PageHelper.buildGap(),
      _buildSearchResult(context),
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
                  child: Focus(
                    onFocusChange: c.onFocusChange,
                    child: AppFormInputText(
                      params: AppFormInputParams(
                        "",
                        "search",
                      ),
                      prefixWidget: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixWidget: Obx(
                        () => !c.isSearchVisitations
                            ? Container()
                            : InkWell(
                                onTap: c.clearSearch,
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      hintText: "Cari",
                      margin: EdgeInsets.zero,
                      onEditingComplete: c.onEditingComplete,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResult(BuildContext context) {
    var paddingTop = ScreenUtil().setSp(50);
    return Obx(
      () {
        if (c.isLoading.isTrue) {
          return PageHelper.simpleCircularLoading();
        }

        if (c.listData.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: paddingTop),
            child: PageHelper.emptyDataResponse(),
          );
        }

        return Column(
          children: c.listData
              .map((visitation) => _buildItem(context, visitation))
              .toList(),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, Visitation visitation) {
    double height = ScreenUtil().setSp(350);
    double gap = ScreenUtil().setSp(30);
    double radius = ScreenUtil().setSp(30);
    double paddingH = ScreenUtil().setSp(30);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingH),
      child: SizedBox(
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          color: Colors.black12,
          elevation: 0,
          child: InkWell(
            onTap: () => Get.to(() => VisitationDetailPage(
                  visitation: visitation,
                  employeeMenu: state,
                )),
            child: SizedBox(
              width: double.infinity,
              height: height,
              child: Container(
                height: double.infinity,
                margin: EdgeInsets.all(gap),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppText(
                            "Cabang    : ${visitation.branch?.name ?? "-"}",
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            fontSize: 12,
                          ),
                          const Divider(),
                          AppText(
                            "Marketing : ${visitation.user?.personalData?.name ?? "-"}",
                            overflow: TextOverflow.ellipsis,
                            fontSize: 11,
                            lineHeight: 1.2,
                          ),
                          AppText(
                            "${EmployeeStakeHolderStateConverter.toTileLabel(state)} : ${visitation.name ?? "-"}",
                            overflow: TextOverflow.ellipsis,
                            fontSize: 11,
                            lineHeight: 1.2,
                          ),
                          const Divider(),
                          AppText(
                            PageHelper.formatDate(
                                visitation.createdAt, 'hh:mm aaa, dd MMMM yy'),
                            overflow: TextOverflow.ellipsis,
                            fontSize: 10,
                            lineHeight: 1.2,
                            fontStyle: FontStyle.italic,
                          ),
                        ],
                      ),
                    ),
                    PageHelper.buildGap(20, Axis.horizontal),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setSp(30)),
                child: InkWell(
                  onTap: c.isEligibleToDownloadResult ? c.downloadResult : null,
                  child: Icon(
                    Icons.download_for_offline,
                    color: c.isEligibleToDownloadResult
                        ? ColorPalettes.appPrimary
                        : Colors.black45,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setSp(30)),
                child: InkWell(
                  onTap: c.onPressFilter,
                  child: Icon(
                    c.rangeDateQuery.isNotEmpty
                        ? Icons.filter_alt_off_outlined
                        : Icons.filter_alt,
                    color: ColorPalettes.appPrimary,
                  ),
                ),
              ),
            ],
          )),
    ];
  }
}
