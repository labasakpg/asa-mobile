import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/models/branch.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class OrderSelectBranchPage extends StatefulWidget {
  const OrderSelectBranchPage({super.key});

  @override
  State<OrderSelectBranchPage> createState() => _OrderSelectBranchPageState();
}

class _OrderSelectBranchPageState extends State<OrderSelectBranchPage> {
  final c = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (c.branchs.isEmpty) c.fetchInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Pilih Cabang",
      useSecondaryBackground: true,
      padding: EdgeInsets.zero,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setSp(30)),
            child: AppText(
              "Tentukan dan pilih lokasi cabang terdekat dengan Anda terlebih dahulu.",
              fontSize: 12,
              color: ColorPalettes.textSecodary,
            ),
          ),
          if (c.branchs.isEmpty) PageHelper.simpleCircularLoading(),
          ...c.branchs.map((data) => _buildItem(data)).toList(),
        ],
      ),
    );
  }

  Widget _buildItem(Branch data) {
    return PageHelper.buildBasicWrapperContainer(
      marginTop: 0,
      marginBottom: 30,
      child: InkWell(
        onTap: () => c.selectBranch(data),
        child: Container(
          decoration: PageHelper.buildRoundBox(
            radius: 50,
            color: Colors.white,
          ),
          height: ScreenUtil().setSp(150),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(data.name ?? ""),
              const Icon(Icons.arrow_circle_right_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
