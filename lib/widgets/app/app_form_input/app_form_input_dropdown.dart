import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class AppFormInputDropDown extends AppFormInput {
  AppFormInputDropDown({
    super.key,
    required this.params,
    required this.options,
    this.validator,
    this.onChanged,
  });

  final List<String> options;
  final AppFormInputParams params;
  final FormFieldValidator<String>? validator;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return buildFormItem(
      label: params.label,
      formBuilderitem: FormBuilderDropdown<String>(
        decoration: inputDecoration,
        name: params.name,
        items: options
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: AppText(item),
                ))
            .toList(),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
