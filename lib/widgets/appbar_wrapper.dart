import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/cons/color_palettes.dart';
import 'package:anugerah_mobile/utils/service_helper.dart';

class AppbarWrapper extends StatelessWidget {
  final double appbarHeight;
  final bool withoutTopMargin;
  final bool backButtonBackgroundWhite;
  final bool extendBodyBehindAppBar;
  final List<Widget> children;
  final Widget? child;
  final Widget? title;
  final bool? centerTitle;
  final bool topSafeArea;
  final bool hideLeading;
  final TextStyle? titleTextStyle;
  final ScrollPhysics? physics;
  final String? assetsPathName;
  final List<Widget>? actions;
  final double iconSize;
  final double iconMargin;
  final double hPrefeeredSize;
  final bool useDashboardAppbar;
  final bool useCustomeAppbar;
  final Widget? customeAppBarFlexibleSpace;
  final Widget? bottomNavigationBar;
  final double expandedHeight;
  final Color? backgroundColor;
  final ScrollController? scrollController;
  final bool? removeAppBar;
  final bool pinned;
  final Widget? customeBodyNestedScrollView;
  final double? heightContainer;
  final Widget? floatingActionButton;
  final VoidCallback? onPressBackCallback;

  final double childPaddingHorizontal;

  const AppbarWrapper({
    super.key,
    this.children = const [],
    this.child,
    this.title,
    this.backButtonBackgroundWhite = false,
    this.appbarHeight = 100,
    this.withoutTopMargin = false,
    this.extendBodyBehindAppBar = false,
    this.hideLeading = false,
    this.centerTitle,
    this.titleTextStyle,
    this.topSafeArea = true,
    this.physics,
    this.assetsPathName,
    this.actions,
    this.iconSize = 22,
    this.iconMargin = 30,
    this.useDashboardAppbar = false,
    this.useCustomeAppbar = false,
    this.customeAppBarFlexibleSpace,
    this.expandedHeight = 450,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.scrollController,
    this.hPrefeeredSize = 100,
    this.removeAppBar,
    this.pinned = false,
    this.customeBodyNestedScrollView,
    this.heightContainer,
    this.floatingActionButton,
    this.childPaddingHorizontal = 50,
    this.onPressBackCallback,
  });

  @override
  Widget build(BuildContext context) {
    var padding = Platform.isIOS
        ? EdgeInsets.only(bottom: ScreenUtil().setSp(40))
        : EdgeInsets.zero;

    return SafeArea(
      top: topSafeArea,
      bottom: false,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          bottomNavigationBar: bottomNavigationBar == null
              ? null
              : MediaQuery(
                  data: MediaQueryData(padding: padding),
                  child: bottomNavigationBar ?? Container(),
                ),
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          appBar: _buildAppBar(context),
          body: _buildBody(context),
          floatingActionButton: floatingActionButton,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }

  Widget _buildCustomerAppbarBackground(String name) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(name),
    );
  }

  Widget _wrapContainer({Widget? child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(childPaddingHorizontal)),
      child: child,
    );
  }

  ButtonStyle getBackButtonStyle() {
    Color color = backButtonBackgroundWhite
        ? Colors.white
        : ColorPalettes.homeIconSelected;
    return ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      backgroundColor: color,
    );
  }

  Widget getBackButtonIcon() {
    Color color = backButtonBackgroundWhite
        ? ColorPalettes.homeIconSelected
        : Colors.white;
    return Icon(Icons.arrow_back, color: color);
  }

  void onPressBackButton(BuildContext context) {
    ServiceHelper.unfocus(context);
    if (onPressBackCallback != null) {
      onPressBackCallback?.call();
      return;
    }
    Get.back();
  }

  EdgeInsets? getHeaderMargin() {
    if (withoutTopMargin) return null;

    return EdgeInsets.only(top: ScreenUtil().setSp(appbarHeight * 2));
  }

  getIconTheme() {
    Color color = backButtonBackgroundWhite
        ? Colors.white
        : ColorPalettes.homeIconSelected;
    return IconThemeData(
      color: color,
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (!useDashboardAppbar || useCustomeAppbar) {
      return null;
    }

    return AppBar(
      title: title,
      centerTitle: centerTitle,
      titleTextStyle: titleTextStyle,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: ScreenUtil().setSp(150),
      actions: actions,
      automaticallyImplyLeading: !hideLeading,
      leading: hideLeading ? null : _buildBasicLeadingButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (useDashboardAppbar) {
      return _buildSliverAppBar(context);
    }

    return _buildSingleChildScrollView(context);
  }

  Widget _buildSliverAppBar(BuildContext context) {
    if (removeAppBar != null && removeAppBar!) {
      return _buildSingleChildScrollView(context);
    }

    return SizedBox(
      height: heightContainer,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: customeAppBarFlexibleSpace,
            //  ?? const Placeholder(),
            expandedHeight: ScreenUtil().setSp(expandedHeight),
            pinned: pinned,
            actions: actions,
            bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(ScreenUtil().setSp(hPrefeeredSize)),
              child: Container(),
            ),
            leading: hideLeading || customeAppBarFlexibleSpace == null
                ? null
                : _buildBasicLeadingButton(context),
          )
        ],
        body:
            customeBodyNestedScrollView ?? _buildSingleChildScrollView(context),
      ),
    );
  }

  Widget _buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: physics,
      child: Column(
        children: [
          if (assetsPathName != null)
            _buildCustomerAppbarBackground(assetsPathName!),
          ...children,
          _wrapContainer(
            child: child,
          ),
        ],
      ),
    );
  }

  _buildBasicLeadingButton(BuildContext context) {
    Color backgroundColor = backButtonBackgroundWhite
        ? Colors.white
        : ColorPalettes.homeIconSelected;
    Color iconColor = backButtonBackgroundWhite
        ? ColorPalettes.homeIconSelected
        : Colors.white;

    return Container(
      margin: EdgeInsets.all(ScreenUtil().setSp(iconMargin)),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: getBackButtonStyle(),
        padding: EdgeInsets.zero,
        onPressed: () => onPressBackButton(context),
        icon: const Icon(Icons.arrow_back_rounded),
        color: iconColor,
        iconSize: ScreenUtil().setSp(iconSize * 3),
      ),
    );
  }
}
