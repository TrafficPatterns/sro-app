import 'package:flutter/material.dart';
import 'package:sro/globals.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class Listing extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final Alignment? trailingAlignment;
  final VoidCallback? onTraillingTap;
  final VoidCallback? onLeadingTap;
  final VoidCallback? onTap;
  final double? heigth;
  final double? widtth;
  final double? elevation;
  final Color? color;
  final TextStyle? titleStyle;
  final BoxBorder? boder;
  final bool? expandText;
  final TextStyle? subStyle;
  const Listing({
    Key? key,
    this.subtitle,
    this.expandText,
    this.titleStyle,
    this.title,
    this.trailing,
    this.leading,
    this.onTraillingTap,
    this.onLeadingTap,
    this.trailingAlignment,
    this.subStyle,
    this.onTap,
    this.color,
    this.heigth,
    this.elevation,
    this.widtth,
    this.boder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: boder,
        ),
        height: heigth ?? getSizeWrtHeight(120),
        width: widtth ?? width - getSize(30),
        child: Card(
          color: color ?? const Color(0xffF7F7F7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: elevation ?? 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading != null)
                      InkWell(
                        onTap: onLeadingTap,
                        child: Padding(
                            padding: EdgeInsets.only(right: getSize(10)),
                            child: leading),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (title != null)
                            SizedBox(
                              width: getSize(
                                  ((leading != null && trailing != null))
                                      ? !(expandText ?? false)
                                          ? 170
                                          : 240
                                      : 240),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  title ?? '',
                                  style: titleStyle ?? AppFonts.poppins18Black,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          if (subtitle != null)
                            SizedBox(
                              width:
                                  getSize((leading != null && trailing != null)
                                      ? !(expandText ?? false)
                                          ? 170
                                          : 240
                                      : 240),
                              child: Text(
                                subtitle ?? '',
                                style: subStyle ?? AppFonts.poppins13Grey,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (trailing != null)
                  Align(
                    alignment: trailingAlignment ?? Alignment.centerRight,
                    child: InkWell(
                      onTap: onTraillingTap ?? () {},
                      child: trailing,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
