import 'package:flutter/material.dart';
import 'package:sro/globals.dart';

import '../services/global_functions.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? widthh;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final BorderRadius? radius;
  final TextStyle? textStyle;
  final String? text;
  const CustomButton(
      {Key? key,
      this.height,
      this.widthh,
      this.color,
      this.textColor,
      this.text,
      this.onTap,
      this.textStyle,
      this.radius,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getSizeWrtHeight(height ?? 55),
      width: widthh ?? (width - getSize(30)),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor ?? const Color(0xff164B9B),
          backgroundColor: color ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: radius ?? BorderRadius.circular(18.0),
            side: BorderSide(color: borderColor ?? const Color(0xff164B9B)),
          ),
        ),
        child: Text(
          text ?? '',
          style: textStyle,
        ),
      ),
    );
  }
}
