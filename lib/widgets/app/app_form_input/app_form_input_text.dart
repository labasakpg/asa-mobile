import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class AppFormInputText extends AppFormInput {
  AppFormInputText({
    super.key,
    this.params,
    this.fontSize,
    this.textInputAction,
    this.keyboardType,
    this.initialValue,
    this.prefix,
    this.prefixWidget,
    this.suffix,
    this.suffixWidget,
    this.hintText,
    this.hintStyle,
    this.validator,
    this.customeInputDecoration,
    this.obscureText = false,
    this.onEditingComplete,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.padding,
    this.margin,
    this.multiLine = false,
    this.enabled = true,
    this.maxLines,
    this.minLines,
  });

  final TextEditingController? controller;
  final InputDecoration? customeInputDecoration;
  final bool enabled;
  final double? fontSize;
  final TextStyle? hintStyle;
  final String? hintText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final EdgeInsets? margin;
  final bool multiLine;
  final bool obscureText;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String?>? onSubmitted;
  final EdgeInsets? padding;
  final AppFormInputParams? params;
  final String? prefix;
  final Widget? prefixWidget;
  final String? suffix;
  final Widget? suffixWidget;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? minLines;

  Widget _iconWrapp({Widget? child, String? label}) {
    return Padding(
      padding: padding ??
          EdgeInsets.only(
            left: ScreenUtil().setSp(contentPaddingVal),
            right: ScreenUtil().setSp(contentPaddingVal / 2),
            bottom: ScreenUtil().setSp(4),
          ),
      child: child ??
          AppText(
            label ?? "",
            fontSize: 15,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = prefixWidget == null && prefix == null
        ? inputDecoration
        : inputDecoration.copyWith(
            // TODO: use suffixText and prefixText instead
            suffixIcon: _iconWrapp(child: suffixWidget, label: suffix),
            prefixIcon: _iconWrapp(child: prefixWidget, label: prefix),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          );

    decoration = decoration.copyWith(
      hintText: hintText,
      hintStyle: hintStyle,
    );

    return buildFormItem(
      margin: margin,
      label: params?.label ?? "",
      formBuilderitem: FormBuilderTextField(
        initialValue: initialValue,
        enabled: enabled,
        controller: controller,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        name: params?.name ?? "",
        style: fontSize == null ? null : TextStyle(fontSize: ScreenUtil().setSp(fontSize ?? 40)),
        textInputAction: textInputAction,
        decoration: customeInputDecoration ?? decoration,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        maxLines: obscureText ? 1 : (multiLine ? null : maxLines),
        minLines: minLines,
        // expands: multiLine ? true : false,
      ),
    );
  }
}
