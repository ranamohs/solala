import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  const VerticalSpace(
      this.height, {
        super.key,
        this.child,
      });

  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: child,
    );
  }
}


class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace(
      this.width, {
        super.key,
        this.child,
      });

  final double width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: child,
    );
  }
}