import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:anugerah_mobile/cons/assets.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class PageHelper {
  PageHelper._();

  static Future<ImageSource?> getImageSourceWithDialog(
      BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Ambil gambar dari?"),
        actions: [
          TextButton(
            child: const Text("Kamera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: const Text("Galeri"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  static Widget buildGap([double height = 20, Axis axis = Axis.vertical]) {
    return SizedBox(
      height: axis == Axis.vertical ? ScreenUtil().setSp(height) : null,
      width: axis == Axis.horizontal ? ScreenUtil().setSp(height) : null,
    );
  }

  static TextStyle textStyle() {
    return TextStyle(
      fontSize: ScreenUtil().setSp(18 * 3),
      fontWeight: FontWeight.bold,
    );
  }

  static Widget disableVerticalDrag({required Widget child}) {
    return GestureDetector(
      onVerticalDragUpdate: (_) => {},
      child: child,
    );
  }

  static InputDecoration inputDecoration({double? contentPaddingVal}) {
    const double radius = 25;
    EdgeInsetsGeometry? contentPadding = contentPaddingVal == null
        ? null
        : EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(contentPaddingVal),
          );

    return InputDecoration(
      filled: true,
      hintStyle: TextStyle(
        color: ColorPalettes.textHint,
        fontWeight: FontWeight.normal,
      ),
      fillColor: ColorPalettes.textInputOTP,
      focusColor: ColorPalettes.textInputFocus,
      contentPadding: contentPadding,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().radius(radius))),
        borderSide: BorderSide(color: ColorPalettes.textInputFocus),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().radius(radius))),
        borderSide: BorderSide(color: ColorPalettes.textInputClear),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().radius(radius))),
        borderSide: BorderSide(color: ColorPalettes.textInputFocus),
      ),
    );
  }

  static InputDecoration inputDecorationV2() => inputDecoration().copyWith(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(35),
          vertical: ScreenUtil().setSp(25),
        ),
        fillColor: Colors.white,
      );

  static InputDecoration inputDecorationDisabledV2() =>
      inputDecorationV2().copyWith(
        fillColor: ColorPalettes.background1TransactionItem,
        disabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().radius(25))),
          borderSide:
              BorderSide(color: ColorPalettes.background1TransactionItem),
        ),
      );

  static Widget? suffixIcon(
      {required bool isEmpty, required VoidCallback callback}) {
    if (isEmpty) return null;

    return IconButton(
      icon: Icon(
        Icons.cancel,
        color: ColorPalettes.textInputClear,
      ),
      onPressed: callback,
    );
  }

  static Widget buildBasicWrapperContainer({
    required Widget child,
    double marginTop = 50,
    double marginBottom = 0,
    double marginH = 35,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setSp(marginTop),
        bottom: ScreenUtil().setSp(marginBottom),
      ),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(marginH)),
      child: child,
    );
  }

  static Widget viewAllButton({required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: AppText(
        "Lihat Semua",
        color: ColorPalettes.homeIconSelected,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.right,
        fontSize: 10,
        // style: TextStyle(color: ColorPalettes.homeIconSelected),
      ),
    );
  }

  static BoxDecoration buildRoundBox({
    required double radius,
    Color borderColor = Colors.transparent,
    Color? color,
    double width = 1.0,
  }) {
    return BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: width,
      ),
      color: color,
      borderRadius: BorderRadius.circular(ScreenUtil().setSp(radius)),
    );
  }

  static BoxDecoration buildRoundBoxOnly({
    required double radius,
    Color borderColor = Colors.transparent,
    Color? color,
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    var useRadius = Radius.circular(ScreenUtil().setSp(radius));
    return BoxDecoration(
      border: Border.all(color: borderColor),
      color: color,
      borderRadius: BorderRadius.only(
        topLeft: topLeft ? useRadius : Radius.zero,
        topRight: topRight ? useRadius : Radius.zero,
        bottomLeft: bottomLeft ? useRadius : Radius.zero,
        bottomRight: bottomRight ? useRadius : Radius.zero,
      ),
    );
  }

  static void showInvalidInput() {
    EasyLoading.showError(AppConfiguration.invalidFormInputValue);
  }

  static FormFieldValidator basicValidator({
    int minLength = 2,
    int maxLength = 50,
    bool isRequired = true,
  }) {
    return FormBuilderValidators.compose([
      if (isRequired) FormBuilderValidators.required(),
      FormBuilderValidators.minLength(minLength),
      FormBuilderValidators.maxLength(maxLength),
    ]);
  }

  static FormFieldValidator<String> basicValidatorEmail() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.email(),
    ]);
  }

  static FormFieldValidator<String> basicValidatorNumeric(
      [bool isRequired = true]) {
    return FormBuilderValidators.compose([
      if (isRequired) basicValidator(),
      FormBuilderValidators.numeric(),
    ]);
  }

  static FormFieldValidator basicValidatorRequired() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
    ]);
  }

  static Widget simpleCircularLoading({
    Color? color,
    bool fullHeight = false,
    bool withoutPadding = false,
  }) {
    return Container(
      height: fullHeight ? AppConfiguration.heightScreenWithoutHeader : null,
      padding: withoutPadding ? null : EdgeInsets.all(ScreenUtil().setSp(30)),
      child: Center(
        child: CircularProgressIndicator(
          color: color ?? ColorPalettes.homeIconSelected,
        ),
      ),
    );
  }

  static Widget emptyDataResponse({
    bool fullHeight = false,
    bool withoutPadding = false,
  }) {
    return Container(
      height: fullHeight ? AppConfiguration.heightScreenWithoutHeader : null,
      padding: withoutPadding
          ? null
          : EdgeInsets.symmetric(vertical: ScreenUtil().setSp(50)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AssetsSVG.dataEmpty),
            AppText(
              "Tidak ada yang ditemukan",
              fontSize: 16,
              textAlign: TextAlign.center,
              color: ColorPalettes.textHint,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              "Pencarian tidak dapat ditemukan,\nsilakan periksa ejaan atau tulis kata lain.",
              fontSize: 12,
              textAlign: TextAlign.center,
              color: ColorPalettes.textHint,
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> openUrl(String link) async {
    var url = Uri.parse(link);

    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  static String formatDate(String? date, [String format = 'yMMMEd']) {
    if (date == null) return "-";

    var parse = DateTime.parse(date).toLocal();
    return DateFormat(format, 'id_ID').format(parse);
  }

  static String convertGenderTo(String? val) {
    if (val == null) return "";

    return val == 'Laki - laki' ? 'Male' : 'Female';
  }

  static String sanitize(String? val) => val ?? "";

  static String convertGenderFrom(String? val) {
    if (val == null) return "";

    return val == 'Male' ? 'Laki - laki' : 'Perempuan';
  }

  static String convertArrivalConfirmationFrom(String? val) {
    if (val == null) return "";
    return val == "patients_come_to_the_lab_sakura"
        ? "Datang ke Lab"
        : "Home Services";
  }

  static String currencyFormat(num? val) {
    val ??= 0;

    final formatCurrency = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp. ",
      decimalDigits: 0,
    );
    return formatCurrency.format(val);
  }

  static Widget paddingWrapper({
    required Widget child,
    double top = 20,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil().setSp(50),
          right: ScreenUtil().setSp(50),
          top: ScreenUtil().setSp(top),
        ),
        child: child,
      );

  static double fullHeightOfScreen({double heightOffSet = 170}) {
    return ScreenUtil().screenHeight -
        ScreenUtil().statusBarHeight -
        ScreenUtil().setSp(heightOffSet);
  }
}
