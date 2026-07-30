import 'package:flutter/material.dart';

class CustomPadding extends StatelessWidget {
  const CustomPadding({
    super.key,
    this.start = 20,
    this.end = 20,
    this.top = 0,
    this.bottom = 0,
    required this.child,
  });
  final double? start, end, top, bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        bottom: bottom!,
        end: end!,
        start: start!,
        top: top!,
      ),
      child: child,
    );
  }
}
