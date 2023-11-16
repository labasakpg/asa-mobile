import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_home.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class OrderFinishPaymentPage extends StatelessWidget {
  final c = Get.put(OrderController());

  OrderFinishPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Konfirmasi Pembayaran",
      useSecondaryBackground: true,
      padding: EdgeInsets.zero,
      hideLeading: true,
      child: _buildChildren(context),
    );
  }

  Widget _buildChildren(BuildContext context) {
    return Container(
      height: PageHelper.fullHeightOfScreen(),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: ScreenUtil().setSp(700),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.orderComplete),
                  ),
                ),
              ),
            ),
            const AppText(
              "Terima Kasih atas\nKonfirmasi Pembayaran",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            AppText(
              "Konfirmasi pembayaran telah sukses. anda juga dapat melihat pada email dan nomor Whatsapp Anda. "
              "Team kami akan segera memproses transaksi anda.",
              textAlign: TextAlign.center,
              color: ColorPalettes.textHint,
              fontSize: 12,
            ),
            PageHelper.buildGap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onPressBackCallback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalettes.homeIconSelected,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(30)),
                  ),
                ),
                child: const Text("Kembali ke Beranda"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressBackCallback() {
    c.init();
    Get.offAll(() => AppHome());
  }
}
