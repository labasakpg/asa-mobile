import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/controllers/patient_controller.dart';
import 'package:anugerah_mobile/models/relative.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/utils/page_helper.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_date.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_dropdown.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_radio_group.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:anugerah_mobile/widgets/divider_with_label.dart';

class ProfilePatientsFormPage extends StatefulWidget {
  const ProfilePatientsFormPage({
    super.key,
    this.relative,
  });

  final Relative? relative;

  @override
  State<ProfilePatientsFormPage> createState() =>
      _ProfilePatientsFormPageState();
}

class _ProfilePatientsFormPageState extends State<ProfilePatientsFormPage> {
  final c = Get.put(PatienController());

  @override
  void initState() {
    super.initState();

    c.updateFormByPersonalData(widget.relative?.personalData, widget.relative);
  }

  Widget _buildForms(BuildContext context) {
    return FormBuilder(
      key: c.formKey.value,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildPatientForm(context),
            Obx(() {
              if (c.isLoadingTitles.isTrue) {
                return PageHelper.simpleCircularLoading();
              }

              return Column(
                children: [
                  _buildSectionTitle("Data Pasien"),
                  AppFormInputText(
                    params: AppFormInputParams(
                      "Nomor Identitas",
                      "ktp",
                    ),
                    validator: PageHelper.basicValidatorNumeric(false),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  if (c.isUser.isTrue)
                    AppFormInputText(
                      params: AppFormInputParams(
                        "Email",
                        "email",
                      ),
                      validator: PageHelper.basicValidatorEmail(),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                  SizedBox(
                    height: ScreenUtil().setSp(c.heightNameInput()),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: AppFormInputDropDown(
                            params: AppFormInputParams("Sapaan", "title"),
                            options: c.titleOptions,
                            validator: PageHelper.basicValidatorRequired(),
                          ),
                        ),
                        PageHelper.buildGap(20, Axis.horizontal),
                        Flexible(
                          flex: 8,
                          child: AppFormInputText(
                            params: AppFormInputParams(
                              "Nama Lengkap",
                              "name",
                            ),
                            validator: PageHelper.basicValidator(),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppFormInputRadioGroup(
                    params: AppFormInputParams(
                      "Jenis Kelamin",
                      "gender",
                    ),
                    options: AppConfiguration.genderOptions,
                    validator: PageHelper.basicValidatorRequired(),
                  ),
                  AppFormInputDate(
                    params: AppFormInputParams(
                      "Tanggal Lahir",
                      "dateOfBirth",
                    ),
                    validator: PageHelper.basicValidatorRequired(),
                  ),
                  AppFormInputText(
                    params: AppFormInputParams(
                      "Nomor Handphone",
                      "phoneNumber",
                    ),
                    validator: PageHelper.basicValidatorNumeric(),
                    keyboardType: TextInputType.number,
                    prefix: "+62",
                    textInputAction: TextInputAction.next,
                  ),
                  AppFormInputText(
                    params: AppFormInputParams(
                      "Pekerjaan",
                      "job",
                    ),
                    validator: PageHelper.basicValidator(),
                    textInputAction: TextInputAction.next,
                  ),
                  _buildSectionTitle("Detail Alamat"),
                  AppFormInputText(
                    params: AppFormInputParams(
                      "Kota",
                      "city",
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => c.onPressedSubmit(widget.relative),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalettes.homeIconSelected),
                      child: const Text("Simpan Data Pasien"),
                    ),
                  ),
                  PageHelper.buildGap(50),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String label) => DividerWithLabel(
        label: label,
        height: 1,
        horizontalPadding: 1,
        color: Colors.black38,
        fontSize: 11,
      );

  List<Widget> _buildPatientForm(BuildContext context) {
    String buttonLabel = "Check";
    Function onPressed = () => c.onPressedCheckPatientData(context);

    // bool hidePinInput = false;
    // if (relative?.patient != null) {
    //   hidePinInput = true;
    // }

    if (widget.relative?.personalData != null) {
      buttonLabel = "Connect";
      onPressed =
          () => c.onPressedConnectPatientData(context, widget.relative?.id);
    }

    return [
      PageHelper.buildGap(),
      _buildSectionTitle("Optional: Hubungkan dengan No. Reg."),
      // if (!hidePinInput)
      Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
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
              title: const AppText(
                "No Reg dan Pin dapat ditemukan di Nota Pembayaran setelah melalukan pemeriksaan di Lab. Hubungi Cabang Lab anugerah terdekat untuk info lebih lanjut.",
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
      Obx(() => AppFormInputText(
            params: AppFormInputParams(
              "No. Reg.",
              "noReg",
            ),
            initialValue: widget.relative?.patient?.id,
            // enabled: widget.relative?.patient?.id == null,
            validator:
                PageHelper.basicValidatorNumeric(c.noRegValue.isNotEmpty),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onChanged: c.noRegValue,
          )),
      // if (!hidePinInput)
      Obx(
        () => Row(
          children: [
            Flexible(
              flex: 2,
              child: AppFormInputText(
                params: AppFormInputParams(
                  "PIN",
                  "pin",
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
                validator:
                    c.noRegValue.isEmpty ? null : PageHelper.basicValidator(),
                textInputAction: TextInputAction.done,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: ScreenUtil().setSp(25)),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => onPressed(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalettes.homeIconSelected),
                  child: Text(buttonLabel),
                ),
              ),
            ),
          ],
        ),
      ),
      const Divider(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      title: "Form Pasien",
      useSecondaryBackground: true,
      appbarBackgroundColor: ColorPalettes.homePageBackgroundSecondary,
      backgroundColor: ColorPalettes.homePageBackgroundSecondary,
      child: _buildForms(context),
    );
  }
}
