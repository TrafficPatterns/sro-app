import 'package:flutter/material.dart';
import 'package:sro/globals.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class CustomBottomSheet {
  static void show(BuildContext context,
      {@required Widget? child, String? label, double? height}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            height: height,
            width: width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 189, 187, 187),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 5,
                    width: getSize(50),
                  ),
                ),
                if (label != null)
                  Text(
                    label,
                    style: AppFonts.poppins18Black,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: child,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
