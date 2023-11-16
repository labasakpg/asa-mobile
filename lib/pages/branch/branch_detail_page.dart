import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/branch_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BranchDetailPage extends StatelessWidget {
  final c = Get.put(BranchController());

  final String code;
  final String? title;

  BranchDetailPage({
    super.key,
    required this.code,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      appbarBackgroundColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: "",
      extendBodyBehindAppBar: true,
      padding: EdgeInsets.zero,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMap(context),
          _buildItems(),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    var radius = Radius.circular(ScreenUtil().setSp(50));
    return SizedBox(
      height: ScreenUtil().setSp(700),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: radius,
          bottomRight: radius,
        ),
        child: Obx(() {
          final latLng = c.selectedData.value.location?.toLatLng();
          double mapZoom = 17;
          if (latLng == null) {
            return const Center(
              child: AppText("Loading map ⌛️"),
            );
          }
          return IgnorePointer(
            child: FlutterMap(
              mapController: c.mapController,
              options: MapOptions(
                center: latLng,
                zoom: mapZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.anugerah.app',
                  // overrideTilesWhenUrlChanges: true,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: latLng,
                      width: 150,
                      height: 150,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.only(bottom: 35),
                        child: Icon(
                          Icons.place_rounded,
                          size: ScreenUtil().setSp(125),
                          color: Colors.blue,
                          shadows: const [
                            Shadow(color: Colors.black45, blurRadius: 7)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildItem({
    IconData? icon,
    String? label,
    bool bold = false,
    bool header = false,
    Color? color,
    String? headerLabel,
    bool asLink = false,
  }) {
    var paddingH = ScreenUtil().setSp(30);
    var paddingV = ScreenUtil().setSp(10);

    return InkWell(
      onTap: () {
        if (asLink && label != null) PageHelper.openUrl(label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: header
                  ? SvgPicture.asset(AssetsSVG.anugerah)
                  : Icon(
                      icon,
                      color: ColorPalettes.textHint,
                    ),
            ),
            PageHelper.buildGap(20, Axis.horizontal),
            Flexible(
              flex: 5,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (headerLabel != null)
                      AppText(
                        headerLabel,
                        fontWeight: FontWeight.bold,
                      ),
                    AppText(
                      label ?? "-",
                      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                      color: color,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItems() {
    c.fetchBranch(code);

    return Obx(
      () {
        var branch = c.selectedData.value;
        return Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: Column(
            children: [
              _buildItem(header: true, label: branch.name, bold: true),
              _buildItem(icon: Icons.place_outlined, label: branch.address),
              _buildItem(
                  icon: Icons.public,
                  label: "https://www.labanugerah.com",
                  color: ColorPalettes.appPrimary,
                  asLink: true),
              _buildItem(icon: Icons.phone, label: branch.phoneNumber),
              _buildItem(icon: Icons.phone_android, label: branch.phoneNumber),
              _buildItem(
                  icon: Icons.watch_later_outlined,
                  label: branch.description,
                  headerLabel: "Jam Kerja"),
            ],
          ),
        );
      },
    );
  }
}
