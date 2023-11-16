import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/utils/app_configuration.dart';
import 'package:anugerah_mobile/utils/service_helper.dart';
import 'package:anugerah_mobile/widgets/app_text.dart';

class AppContentWrapper extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget child;
  final bool hideLeading;
  final Color titleColor;
  final Color backgroundColor;
  final Color appbarBackgroundColor;
  final double childPaddingHorizontal;
  final EdgeInsets? padding;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final VoidCallback? onPressBackCallback;
  final TextStyle? titleTextStyle;
  final bool useSecondaryBackground;
  final bool extendBodyBehindAppBar;
  final Widget? bottomNavigationBar;

  const AppContentWrapper({
    Key? key,
    this.title,
    required this.child,
    this.hideLeading = false,
    this.titleColor = Colors.black87,
    this.backgroundColor = Colors.white,
    this.appbarBackgroundColor = Colors.white,
    this.useSecondaryBackground = false,
    this.childPaddingHorizontal = 50,
    this.actions,
    this.onPressBackCallback,
    this.titleTextStyle,
    this.padding,
    this.titleWidget,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingBottomNavBar = Platform.isIOS
        ? EdgeInsets.only(bottom: ScreenUtil().setSp(40))
        : EdgeInsets.zero;
    final bottomNavBar = bottomNavigationBar == null
        ? null
        : MediaQuery(
            data: MediaQueryData(padding: paddingBottomNavBar),
            child: bottomNavigationBar ?? Container(),
          );
    final paddingBody = padding ??
        EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(childPaddingHorizontal),
        );

    return SafeArea(
      top: false,
      bottom: false,
      child: GestureDetector(
        onTap: () => _onTapHandler(context),
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: _buildAppBar(context),
          bottomNavigationBar: bottomNavBar,
          floatingActionButton: floatingActionButton,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          body: Container(
            padding: paddingBody,
            child: child,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    final flexibleSpace = !useSecondaryBackground
        ? null
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: AppConfiguration.radiusCircular50,
                bottomRight: AppConfiguration.radiusCircular50,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFF019EFF),
                  Color(0xFF0770FB),
                ],
              ),
            ),
          );

    final leading = hideLeading ? null : _buildBasicLeadingButton(context);

    return AppBar(
      title: titleWidget ??
          buildTitle(
            title: title ?? "Title",
            color: useSecondaryBackground ? Colors.white : titleColor,
          ),
      centerTitle: true,
      titleTextStyle: titleTextStyle,
      backgroundColor: appbarBackgroundColor,
      elevation: 0,
      leadingWidth: ScreenUtil().setSp(150),
      actions: actions,
      automaticallyImplyLeading: !hideLeading,
      leading: leading,
      flexibleSpace: flexibleSpace,
    );
  }

  Widget _buildBasicLeadingButton(BuildContext context) {
    double iconMargin = 30;
    double iconSize = 22;

    Color backgroundColor =
        useSecondaryBackground ? Colors.white : ColorPalettes.homeIconSelected;
    Color iconColor =
        useSecondaryBackground ? ColorPalettes.homeIconSelected : Colors.white;

    return Container(
      margin: EdgeInsets.all(ScreenUtil().setSp(iconMargin)),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: _backButtonStyle(),
        padding: EdgeInsets.zero,
        onPressed: () => _onPressBackButton(context),
        icon: const Icon(Icons.arrow_back_rounded),
        color: iconColor,
        iconSize: ScreenUtil().setSp(iconSize * 3),
      ),
    );
  }

  ButtonStyle _backButtonStyle() {
    Color color =
        useSecondaryBackground ? Colors.white : ColorPalettes.homeIconSelected;
    return ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      backgroundColor: color,
    );
  }

  void _onPressBackButton(BuildContext context) {
    ServiceHelper.unfocus(context);
    if (onPressBackCallback != null) {
      onPressBackCallback?.call();
      return;
    }
    Get.back();
  }

  void _onTapHandler(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Widget buildTitle({
    required String title,
    Color color = Colors.black87,
  }) {
    return AppText(
      title,
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: color,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }
}
