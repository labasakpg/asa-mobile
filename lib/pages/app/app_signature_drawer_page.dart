import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/app_signature_drawer_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_bar_builder.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';
import 'package:signature/signature.dart';

class AppSignatureDrawer extends StatefulWidget {
  final Function(String) callback;

  const AppSignatureDrawer({Key? key, required this.callback})
      : super(key: key);

  @override
  State<AppSignatureDrawer> createState() => _AppSignatureDrawerState();
}

class _AppSignatureDrawerState extends State<AppSignatureDrawer> {
  final c = Get.put(AppSignatureDrawerController());

  @override
  Widget build(BuildContext context) {
    return AppbarWrapper(
      topSafeArea: false,
      useDashboardAppbar: true,
      useCustomeAppbar: true,
      backgroundColor: Colors.white,
      customeAppBarFlexibleSpace: AppBarBuilder.buildBasicAppbar(
        label: "Buat Tanda Tangan",
        withBackground: false,
        textColor: Colors.black,
      ),
      pinned: true,
      expandedHeight: 0,
      hPrefeeredSize: 0,
      iconMargin: 40,
      iconSize: 18,
      children: _buildChildren(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      Container(
        decoration: PageHelper.buildRoundBox(radius: 30, color: Colors.black12),
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        margin: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Signature(
          controller: c.signatureController,
          width: ScreenUtil().setSp(800),
          height: ScreenUtil().setSp(800),
          // backgroundColor: Colors.lightBlueAccent,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: c.clear,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalettes.orderCheckoutSubSectionTitle,
            ),
            child: const AppText("Hapus"),
          ),
          PageHelper.buildGap(20, Axis.horizontal),
          ElevatedButton(
            onPressed: onPressedSaved,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalettes.appPrimary,
            ),
            child: Row(
              children: [
                const Icon(Icons.save),
                PageHelper.buildGap(10, Axis.horizontal),
                const AppText("Simpan"),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  void onPressedSaved() async {
    await c.save();
    widget.callback(c.val.value);
    Get.back();
  }
}
