import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class AppFormInputCheckbox extends AppFormInput {
  AppFormInputCheckbox({
    super.key,
    this.params,
    this.validator,
    this.onChanged,
    this.margin,
    this.title,
    this.customeInputDecoration,
    this.initialValue,
  });

  final String? title;
  final EdgeInsets? margin;
  final ValueChanged<bool?>? onChanged;
  final AppFormInputParams? params;
  final FormFieldValidator<String>? validator;
  final InputDecoration? customeInputDecoration;
  final bool? initialValue;

  @override
  Widget build(BuildContext context) {
    return buildFormItem(
      label: params?.label ?? "",
      margin: margin,
      formBuilderitem: FormBuilderCheckbox(
        title: AppText(title ?? "-"),
        decoration: customeInputDecoration ?? inputDecoration,
        name: params?.name ?? "",
        onChanged: onChanged,
        initialValue: initialValue,
      ),
    );
  }
}
