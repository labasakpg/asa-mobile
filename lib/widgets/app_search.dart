import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_params.dart';
import 'package:anugerah_mobile/widgets/app/app_form_input/app_form_input_text.dart';

class AppSearch extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onClear;
  final Key? formKey;
  final String hintText;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<String?>? onSubmitted;

  const AppSearch({
    Key? key,
    this.onSubmitted,
    this.formKey,
    this.hintText = "Masukkan Kata Kunci",
    this.onFocusChange,
    this.onClear,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppSearch> createState() => _AppSearchState();
}

class _AppSearchState extends State<AppSearch> {
  final TextEditingController _controller = TextEditingController();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setSp(30),
      ),
      child: FormBuilder(
        key: widget.formKey,
        child: Column(
          children: [
            FocusScope(
              child: Focus(
                onFocusChange: widget.onFocusChange,
                child: AppFormInputText(
                  params: AppFormInputParams(
                    "",
                    widget.formKey.toString(),
                  ),
                  controller: _controller,
                  prefixWidget: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffixWidget: search.isEmpty
                      ? const Text("")
                      : InkWell(
                          onTap: _onTapHandler,
                          child: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                        ),
                  hintText: widget.hintText,
                  margin: EdgeInsets.zero,
                  onSubmitted: widget.onSubmitted,
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    setState(() {
                      if (value != null) {
                        search = value;
                      }
                    });
                  },
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapHandler() {
    widget.onClear!();
    _controller.clear();
    setState(() {
      search = "";
    });
  }
}
