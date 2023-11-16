import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';

class AppFormInputRadioGroup extends AppFormInput {
  AppFormInputRadioGroup({
    super.key,
    required this.options,
    this.params,
    this.validator,
    this.onChanged,
    this.margin,
    this.customeInputDecoration,
    this.initialValue,
  });

  final EdgeInsets? margin;
  final ValueChanged<String?>? onChanged;
  final List<String> options;
  final AppFormInputParams? params;
  final FormFieldValidator<String>? validator;
  final InputDecoration? customeInputDecoration;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return buildFormItem(
      label: params?.label ?? "",
      margin: margin,
      formBuilderitem: FormBuilderRadioGroup<String>(
        decoration: customeInputDecoration ?? inputDecoration,
        name: params?.name ?? "",
        initialValue: initialValue,
        options: options
            .map((lang) => FormBuilderFieldOption(
                  value: lang,
                  child: Text(lang),
                ))
            .toList(growable: false),
        controlAffinity: ControlAffinity.leading,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
