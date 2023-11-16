import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/pages/profile/profile_page.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileQrCodePage extends StatelessWidget {
  const ProfileQrCodePage({
    super.key,
    this.qrCodeData,
  });

  final String? qrCodeData;

  onPressBackButton(BuildContext context) {}

  List<Widget> _buildChildren(BuildContext context) {
    String label = qrCodeData == null
        ? "No Reg belum terhubung.\nMasukkan No Reg melalui menu Hasil Online. Mohon hubungi Cabang Laboratorium Anugerah terdekat untuk info lebih lanjut."
        : "No REG $qrCodeData";
    return [
      Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(50)),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: ColorPalettes.tileWarningBackground,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
            child: ListTile(
              leading: Icon(
                Icons.info_outline_rounded,
                color: ColorPalettes.tileWarningIcon,
              ),
              minLeadingWidth: ScreenUtil().setSp(30),
              title: AppText(
                label,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
      _buildQrCode(context),
    ];
  }

  Widget _buildQrCode(BuildContext context) {
    if (qrCodeData == null) return Container();

    return SizedBox(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(5),
        child: QrImageView(
          data: qrCodeData!,
          version: QrVersions.auto,
          size: 300.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: ProfilePage().backgroundColor(),
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setSp(400),
                child: ProfilePage(
                  activeAppBarButton: AppBarButton.qrCode,
                  hideEditIcon: true,
                ).appBar(),
              ),
              ..._buildChildren(context),
            ],
          ),
        ),
        ProfilePage.buildBackButton(context),
      ],
    );
  }
}
