import 'package:flutter/cupertino.dart';
import 'package:sro/global_widgets/special_listing_widget.dart';

import 'get_images.dart';

class CircleImage extends StatelessWidget {
  final Color? circleColor;
  final EventType? eventType;
  final double? size;
  final AppImages? icon;
  final BoxFit? iconFit;
  final EdgeInsets? iconPadding;
  const CircleImage(
      {Key? key,
      this.circleColor,
      this.eventType,
      this.icon,
      this.size,
      this.iconFit,
      this.iconPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: circleColor ??
            (eventType == EventType.BT
                ? const Color(0xfff16324)
                : eventType == EventType.WSB
                    ? const Color(0xff4b9242)
                    : eventType == EventType.avatar
                        ? const Color(0xffECEDEE)
                        : eventType == EventType.walking
                            ? const Color(0xff4b9242)
                            : const Color(0xff612672)),
        borderRadius: const BorderRadius.all(Radius.circular(200)),
      ),
      height: size ?? 40,
      width: size ?? 40,
      child: Padding(
        padding: iconPadding ?? EdgeInsets.zero,
        child: GetImages(
          height: size,
          fit: iconFit,
          width: size,
          image: eventType != null
              ? eventType == EventType.BT
                  ? AppImages.bike
                  : eventType == EventType.WSB
                      ? AppImages.bus
                      : eventType == EventType.avatar
                          ? AppImages.avatar
                          : eventType == EventType.walking
                              ? AppImages.walking
                              : AppImages.car
              : icon,
        ),
      ),
    );
  }
}
