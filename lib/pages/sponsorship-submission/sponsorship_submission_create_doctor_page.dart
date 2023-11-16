import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/cons/enums.dart';
import 'package:anugerah_mobile/controllers/sponsorship_create_controller.dart';
import 'package:anugerah_mobile/pages/app/app_signature_drawer_page.dart';
import 'package:anugerah_mobile/utils/employee_stake_holder_state_converter.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_dropdown.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app/common/app_image_network.dart';
import 'package:anugerah_mobile/widgets/app_bar_builder.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/appbar_wrapper.dart';
import 'package:anugerah_mobile/widgets/divider_with_label.dart';

class SponsorshipSubmissionCreateDoctorPage extends StatelessWidget {
  final c = Get.put(SponsorshipCreateController());

  SponsorshipSubmissionCreateDoctorPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    c.init(EmployeeStakeHolderStateConverter.toLabel(
      EmployeeStakeHolderState.doctor,
    ));

    return AppbarWrapper(
      topSafeArea: false,
      useDashboardAppbar: true,
      useCustomeAppbar: true,
      backgroundColor: Colors.white,
      customeAppBarFlexibleSpace: AppBarBuilder.buildBasicAppbar(
        label: "Buat Sponsorship Dokter",
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

  List<Widget> _buildChildren(BuildContext context) {
    return [
      _buildFormsDoctor(context),
    ];
  }

  Widget _buildFormsDoctor(BuildContext context) {
    return Obx(
      () {
        return PageHelper.buildBasicWrapperContainer(
          marginH: 50,
          child: FormBuilder(
            key: c.formKey.value,
            child: Column(
              children: [
                _buildSectionTitle("Data Penyusun"),
                AppFormInputDropDown(
                  params: AppFormInputParams("Cabang", "branchCode"),
                  options: c.branchsOptions
                      .map((val) => "${val.code}-${val.name}")
                      .toList(),
                  validator: PageHelper.basicValidatorRequired(),
                ),
                _buildSectionTitle("Formulir"),
                AppFormInputText(
                  params: AppFormInputParams(
                    "Nomor Kuitansi",
                    "receiptNumber",
                  ),
                  validator: PageHelper.basicValidator(),
                  textInputAction: TextInputAction.next,
                ),
                AppFormInputText(
                  params: AppFormInputParams(
                    "Nomor Proses",
                    "processNumber",
                  ),
                  validator: PageHelper.basicValidator(),
                  textInputAction: TextInputAction.next,
                ),
                AppFormInputText(
                  params: AppFormInputParams(
                    "Nominal",
                    "nominal",
                  ),
                  validator: PageHelper.basicValidatorNumeric(),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  prefix: "Rp",
                ),
                AppFormInputText(
                  params: AppFormInputParams(
                    "Nama",
                    "name",
                  ),
                  validator: PageHelper.basicValidator(),
                  textInputAction: TextInputAction.next,
                ),
                AppFormInputText(
                  params: AppFormInputParams(
                    "Alamat",
                    "address",
                  ),
                  maxLines: 2,
                  multiLine: true,
                  validator: PageHelper.basicValidator(maxLength: 120),
                  textInputAction: TextInputAction.next,
                ),
                AppFormInputText(
                  params: AppFormInputParams(
                    "Kota",
                    "city",
                  ),
                  validator: PageHelper.basicValidator(),
                  textInputAction: TextInputAction.done,
                ),
                _buildSectionTitle("Media"),
                _buildUploadButton(
                  c.picPhotoSlug,
                  label:
                      "Foto ${EmployeeStakeHolderStateConverter.toLabel2(c.currentType.value)}",
                ),
                _buildPreview(c.picPhotoSlug),
                _buildCustomDivider(),
                _buildSignature(),
                _buildPreview(c.signatureSlug),
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: c.onPressedSubmit,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalettes.homeIconSelected),
                    child: const Text("Simpan"),
                  ),
                ),
                PageHelper.buildGap(50),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String label) => DividerWithLabel(
        label: label,
        height: 1,
        horizontalPadding: 1,
        color: Colors.black38,
        fontSize: 11,
      );

  Widget _buildUploadButton(
    RxString val, {
    required String label,
  }) {
    const double radius = 30;
    var borderRadius = Radius.circular(ScreenUtil().setSp(radius));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: borderRadius,
        dashPattern: const [3],
        strokeWidth: 0.5,
        color: ColorPalettes.dotBorder,
        child: InkWell(
          onTap: () => c.selectFile(val),
          child: ClipRRect(
            borderRadius: BorderRadius.all(borderRadius),
            child: Ink(
              decoration: PageHelper.buildRoundBox(
                radius: radius,
                color: ColorPalettes.uploadPaymentConfirmation,
              ),
              child: SizedBox(
                width: double.infinity,
                height: ScreenUtil().setSp(100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.drive_folder_upload_outlined),
                    PageHelper.buildGap(30, Axis.horizontal),
                    AppText("Upload $label", fontSize: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(RxString val) {
    return Obx(
      () {
        if (val.isEmpty) {
          return Container();
        }

        return SizedBox(
          height: ScreenUtil().setSp(300),
          width: double.infinity,
          child: AppImageNetwork(slug: val.value),
        );
      },
    );
  }

  Widget _buildCustomDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      child: const Divider(),
    );
  }

  Widget _buildSignature() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(100)),
      child: ElevatedButton(
        onPressed: () => Get.to(() => AppSignatureDrawer(
              callback: callbackSignature,
            )),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.draw_rounded),
            AppText("Tambahkan Tanda Tangan"),
          ],
        ),
      ),
    );
  }

  callbackSignature(String signatureUrl) {
    c.signatureSlug(signatureUrl);
  }
}
