// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sro/global_widgets/circle_container_with_image.dart';
import 'package:sro/themes/app_fonts.dart';

import '../services/global_functions.dart';
import 'get_images.dart';
import 'listing.dart';

enum EventType { BT, WSB, IC, avatar, walking }

class SListing extends StatelessWidget {
  final Color? color;
  final Color? circleColor;
  final AppImages? icon;
  final String? heading;
  final double? width;
  final Widget? leading;
  final bool? expandText;
  final String? sub;
  final VoidCallback? onTap;
  final EventType? evntType;
  final bool? hasBorder;
  final double? height;
  final TextStyle? headingStyle;
  final TextStyle? subHeadingStyle;
  final int? notification;
  const SListing(
      {Key? key,
      this.color,
      this.circleColor,
      this.icon,
      this.heading,
      this.sub,
      this.onTap,
      this.evntType,
      this.hasBorder = true,
      this.height,
      this.notification,
      this.headingStyle,
      this.subHeadingStyle,
      this.leading,
      this.width,
      this.expandText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listing(
        expandText: expandText,
        title: heading,
        titleStyle: headingStyle,
        subtitle: sub,
        subStyle: subHeadingStyle,
        onTap: onTap,
        trailing: leading ??
            Row(
              children: [
                if (notification != null && notification! > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      height: getSize(23),
                      width: getSize(23),
                      decoration: const BoxDecoration(
                        color: Color(0xff164B9B),
                        borderRadius: BorderRadius.all(Radius.circular(200)),
                      ),
                      child: Center(
                        child: Text('$notification',
                            style: AppFonts.poppins12WhiteBold),
                      ),
                    ),
                  ),
                const GetImages(
                  image: AppImages.arrow,
                ),
              ],
            ),
        heigth: height ?? getSizeWrtHeight(95),
        color: color ?? Colors.white,
        widtth: width ?? getSize(400),
        boder: (hasBorder ?? true)
            ? const Border(
                bottom: BorderSide(color: Color.fromARGB(255, 207, 206, 206)))
            : null,
        leading: CircleImage(
          circleColor: circleColor,
          eventType: evntType,
          icon: icon,
        ));
  }
}
