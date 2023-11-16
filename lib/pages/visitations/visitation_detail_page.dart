import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/models/visitation.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';

class VisitationDetailPage extends StatelessWidget {
  final Visitation visitation;
  final EmployeeStakeHolderState employeeMenu;

  VisitationDetailPage({
    Key? key,
    required this.visitation,
    required this.employeeMenu,
  }) : super(key: key);

  final paddingH = ScreenUtil().setSp(30);
  final paddingV = ScreenUtil().setSp(10);

  @override
  Widget build(BuildContext context) {
    return AppbarWrapper(
      topSafeArea: false,
      useDashboardAppbar: true,
      useCustomeAppbar: true,
      backgroundColor: Colors.white,
      customeAppBarFlexibleSpace: _buildMap(context),
      expandedHeight: 550,
      iconMargin: 40,
      iconSize: 18,
      children: _buildChildren(context),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      _buildItems(),
    ];
  }

  Widget _buildMap(BuildContext context) {
    var radius = Radius.circular(ScreenUtil().setSp(50));
    final latLng = visitation.location!.toLatLng();
    double mapZoom = 17;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: radius,
        bottomRight: radius,
      ),
      child: FlutterMap(
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
  }

  Widget _buildItem({
    IconData? icon,
    String? label,
    bool bold = false,
    bool header = false,
    Color? color,
    String? headerLabel,
    bool asLink = false,
    bool asImage = false,
  }) {
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
                    if (!asImage)
                      AppText(
                        label ?? "-",
                        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                        color: color,
                      ),
                    if (asImage)
                      SizedBox(
                        height: ScreenUtil().setSp(300),
                        width: double.infinity,
                        child: AppImageNetwork(slug: label),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
      child: Column(
        children: [
          _buildItem(
            headerLabel: "Cabang",
            label: visitation.branch?.name,
          ),
          const Divider(),
          _buildItem(
            headerLabel: employeeMenu == EmployeeStakeHolderState.doctor
                ? "Dokter"
                : "PIC",
            label: visitation.name,
          ),
          const Divider(),
          _buildItem(
            headerLabel: "Marketing",
            label: visitation.user?.personalData?.name,
          ),
          const Divider(),
          _buildItem(
            headerLabel: "Tujuan Kunjungan",
            label: visitation.visitingReason,
          ),
          const Divider(),
          _buildItem(
            headerLabel: "Feedback",
            label: visitation.feedback,
          ),
          const Divider(),
          _buildItem(
            headerLabel: "Lampiran",
            label: visitation.attachment?.slug,
            asImage: true,
          ),
          const Divider(),
          _buildItem(
            headerLabel: "Foto Dokter",
            label: visitation.picPhoto?.slug,
            asImage: true,
          ),
          const Divider(),
          _buildItem(
            headerLabel: "Tanda Tangan",
            label: visitation.signature?.slug,
            asImage: true,
          ),
        ],
      ),
    );
  }
}
