import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';

class AppFormInputDate extends AppFormInput {
  AppFormInputDate({
    super.key,
    this.params,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onReset,
    this.onFieldSubmitted,
    this.inputType = InputType.date,
    this.margin,
    this.firstDate,
    this.format,
    this.style,
    this.fontSize,
    this.customeInputDecoration,
  });

  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<DateTime?>? onFieldSubmitted;
  final VoidCallback? onReset;
  final FormFieldSetter<DateTime>? onSaved;
  final AppFormInputParams? params;
  final FormFieldValidator<DateTime>? validator;
  final InputType inputType;
  final DateFormat? format;
  final EdgeInsets? margin;
  final InputDecoration? customeInputDecoration;
  final TextStyle? style;
  final double? fontSize;
  final DateTime? firstDate;

  @override
  Widget build(BuildContext context) {
    return buildFormItem(
      label: params?.label ?? "",
      margin: margin,
      formBuilderitem: FormBuilderDateTimePicker(
        name: params?.name ?? "",
        initialEntryMode: DatePickerEntryMode.calendar,
        timePickerInitialEntryMode: TimePickerEntryMode.dialOnly,
        inputType: inputType,
        firstDate: firstDate,
        decoration: customeInputDecoration ?? inputDecoration,
        format: format ?? DateFormat.yMMMMd("id_ID"),
        validator: validator,
        onChanged: onChanged,
        onSaved: onSaved,
        onReset: onReset,
        onFieldSubmitted: onFieldSubmitted,
        style: fontSize == null
            ? null
            : TextStyle(fontSize: ScreenUtil().setSp(fontSize ?? 40)),
      ),
    );
  }

  static DateTime get firstDateBeforeToday =>
      DateTime.now().subtract(const Duration(days: 0));
}
