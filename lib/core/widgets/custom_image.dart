import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;

  const CustomImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.color,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Image.asset(
      path,
      width: width,
      height: height,
      color: color,
      cacheHeight: height != null ? (height! * pixelRatio).toInt() : null,
      cacheWidth: width != null ? (width! * pixelRatio).toInt() : null,
      fit: fit ?? BoxFit.contain,
    );
  }
}
