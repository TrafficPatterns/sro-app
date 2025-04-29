import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/pages/account/account_controller.dart';
import 'package:workmanager/workmanager.dart';

import '../global_widgets/custom_button.dart';
import '../services/global_functions.dart';
import '../services/globals/global_user_variables.dart';
import '../themes/app_fonts.dart';

class ConfirmDisable extends GetView<AccountController> {
  const ConfirmDisable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: getSize(250),
            child: Text(
              "Are you sure you want to disable location tracking?",
              style: AppFonts.poppins14BlackBold,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                  onTap: () {
                    Get.back();
                    showToas("Location Tracking has been disabled");
                    controller.isLocTrackingActive.value = false;
                    SharedPreferences.getInstance()
                        .then((value) => value.setBool(LOCATION_KEY, false));
                    Workmanager().cancelAll();
                    if (stream != null) {
                      stream!.cancel();
                    }
                  },
                  text: "Yes",
                  height: getSizeWrtHeight(40),
                  radius: BorderRadius.circular(5),
                  widthh: getSize(60),
                  color: const Color(0xff164B9B),
                  textStyle: AppFonts.poppins14White,
                  borderColor: const Color(0xff164B9B)),
              SizedBox(
                width: getSize(20),
              ),
              CustomButton(
                  onTap: () {
                    Get.back();
                  },
                  text: "No",
                  height: getSizeWrtHeight(40),
                  radius: BorderRadius.circular(5),
                  widthh: getSize(60),
                  borderColor: const Color(0xff164B9B)),
            ],
          )
        ],
      ),
    );
  }
}
