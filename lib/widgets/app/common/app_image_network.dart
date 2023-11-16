import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/widgets/app_content_wrapper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../cons/constant.dart';

class AppImageNetwork extends StatelessWidget {
  final String? slug;
  final double width;
  final double height;
  final double radius;
  final double marginAll;
  final Widget? placeholder;
  final BoxFit? fit;
  final Alignment? alignment;

  const AppImageNetwork({
    super.key,
    this.slug,
    this.placeholder,
    this.width = double.infinity,
    this.height = double.infinity,
    this.radius = 30,
    this.marginAll = 30,
    this.fit = BoxFit.fitHeight,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    var child = _buildPlaceholder();
    String newSlug = slug ?? "";
    if (newSlug.isNotEmpty) {
      child = FadeInImage.memoryNetwork(
        fit: fit,
        placeholder: kTransparentImage,
        image: buildImageUrl(path: newSlug),
      );
    }

    return InkWell(
      onTap: _onTapHandler,
      child: Container(
        height: height,
        width: width,
        alignment: alignment,
        margin: EdgeInsets.all(_buildMarginAll()),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_buildRadius()),
          child: child,
        ),
      ),
    );
  }

  double _buildRadius() => ScreenUtil().setSp(radius);

  double _buildMarginAll() => ScreenUtil().setSp(marginAll);

  Widget _buildPlaceholder() {
    return placeholder ?? const Placeholder();
  }

  static String buildImageUrl({String? path}) =>
      "${Constant.baseAPI}/files/$path";

  void _onTapHandler() {
    if (slug == null) {
      return;
    }

    Get.to(() => ImageViewer(
          urlPath: AppImageNetwork.buildImageUrl(path: slug),
        ));
  }
}

class ImageViewer extends StatelessWidget {
  final String urlPath;

  const ImageViewer({Key? key, required this.urlPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      appbarBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      title: "",
      extendBodyBehindAppBar: true,
      padding: EdgeInsets.zero,
      child: PhotoView(
        imageProvider: NetworkImage(urlPath),
      ),
    );
  }
}
