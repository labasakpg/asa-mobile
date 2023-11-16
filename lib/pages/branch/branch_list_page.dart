import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/branch_controller.dart';
import 'package:anugerah_mobile/models/branch.dart';
import 'package:anugerah_mobile/pages/branch/branch_detail_page.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_bar_builder.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';

class BranchListPage extends StatelessWidget {
  BranchListPage({super.key});

  final c = Get.put(BranchController());

  List<Widget> _buildChildren(BuildContext context) {
    c.init();

    return [
      _buildBranchs(),
    ];
  }

  Widget _buildBranchs() {
    return Obx(
      () {
        if (c.listData.isEmpty) {
          return SizedBox(
            height: ScreenUtil().screenHeight / 2,
            child: PageHelper.simpleCircularLoading(),
          );
        }

        return Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(50)),
          child: Column(
            children:
                c.listData.map((branch) => _buildBranchItem(branch)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBranchItem(Branch branch) {
    const heightCard = 400;
    double radius = ScreenUtil().setSp(30);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: SizedBox(
        height: ScreenUtil().setSp(heightCard),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: AppImageNetwork(slug: branch.picture?.slug),
            ),
            Flexible(
              flex: 5,
              child: Container(
                margin: EdgeInsets.only(
                  top: radius,
                  right: radius,
                  bottom: radius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      branch.name ?? '',
                      fontSize: 12,
                      lineHeight: ScreenUtil().setSp(3),
                      fontWeight: FontWeight.bold,
                    ),
                    PageHelper.buildGap(),
                    AppText(
                      branch.address ?? '',
                      fontSize: 11,
                      overflow: TextOverflow.ellipsis,
                      lineHeight: ScreenUtil().setSp(3),
                      maxLines: 2,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () => _onTapBranchItemHandler(branch.code),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalettes.homeIconSelected),
                        child: const AppText(
                          "Lihat Detail",
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapBranchItemHandler(String code) {
    Get.to(() => BranchDetailPage(code: code));
  }

  @override
  Widget build(BuildContext context) {
    return AppbarWrapper(
      topSafeArea: false,
      useDashboardAppbar: true,
      useCustomeAppbar: true,
      customeAppBarFlexibleSpace: AppBarBuilder.buildBasicAppbar(
        label: "Daftar Cabang",
      ),
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backButtonBackgroundWhite: true,
      iconMargin: 40,
      iconSize: 18,
      expandedHeight: 0,
      hPrefeeredSize: 0,
      scrollController: c.scrollController,
      children: _buildChildren(context),
    );
  }
}
