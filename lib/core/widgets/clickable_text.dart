import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  const ClickableText({
    super.key,
    required this.onTap,
    required this.text, required this.textStyle,
  });

  final void Function() onTap;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: textStyle
      ),
    );
  }
}