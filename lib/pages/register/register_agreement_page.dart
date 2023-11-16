import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/register_controller.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';

enum AgreementType { tnc, privacyPolicy }

class RegisterAgreementPage extends StatefulWidget {
  final AgreementType agreementType;
  final bool previewMode;
  final bool popup;

  const RegisterAgreementPage({
    super.key,
    required this.agreementType,
    this.previewMode = false,
    this.popup = false,
  });

  @override
  State<RegisterAgreementPage> createState() => _RegisterAgreementPageState();
}

class _RegisterAgreementPageState extends State<RegisterAgreementPage> {
  final c = Get.put(RegisterController());
  final _controller = ScrollController();
  bool isAtTheBottom = false;

  @override
  void initState() {
    super.initState();
    if (!widget.previewMode) {
      _controller.addListener(() {
        if (_controller.position.atEdge) {
          bool isTop = _controller.position.pixels == 0;
          if (!isTop) {
            setState(() {
              isAtTheBottom = true;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    c.fetchAgreementData(widget.agreementType);

    return AppContentWrapper(
      title: _buildText(),
      child: _buildChild(context),
    );
  }

  String _buildText() {
    return widget.agreementType == AgreementType.tnc
        ? "Terms & Conditions"
        : "Privacy Policy";
  }

  Widget _buildChild(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().radius(25))),
              border: Border.all(color: ColorPalettes.simpleBox1Stroke),
            ),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: SingleChildScrollView(
              controller: _controller,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Obx(() => Html(data: c.agreementData.value)),
                ],
              ),
            ),
          ),
        ),
        if (!widget.previewMode) ...[
          PageHelper.buildGap(50),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: !isAtTheBottom
                  ? null
                  : () => c.onPressAgreeButton(widget.agreementType),
              child: const Text("Setuju"),
            ),
          ),
        ],
        PageHelper.buildGap(50),
      ],
    );
  }
}
