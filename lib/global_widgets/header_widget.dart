import 'package:flutter/material.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class HeaderWidget extends StatelessWidget {
  final String? head;
  final String? subHead;
  final TextStyle? headStyle;
  final TextStyle? subHeadStyle;
  const HeaderWidget(
      {Key? key,
      @required this.head,
      this.subHead,
      this.headStyle,
      this.subHeadStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head ?? '',

          style: headStyle ?? AppFonts.poppinsSemiBold28Black,
        ),
        if (subHead != null)
        SizedBox(
          height: getSizeWrtHeight(17),
        ),
        if (subHead != null)
          Text(
            subHead ?? '',
            style: subHeadStyle ?? AppFonts.poppinsRegular16Grey,
          ),
      ],
    );
  }
}
