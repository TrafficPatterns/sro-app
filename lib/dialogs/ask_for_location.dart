import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/pages/account/account_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/themes/app_fonts.dart';

class AskLocation extends GetView<AccountController> {
  const AskLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showD = false;
        return true;
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          width: getSize(355),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Your school would like to track your location during specific hours if the app is opened. Your location will not be accessed in the background.",
                  textAlign: TextAlign.center,
                  style: AppFonts.poppins14BlackBold,
                ),
                SizedBox(
                  height: getSizeWrtHeight(10),
                ),
                Text(
                  'Your location will be logged if the app is active from:',
                  textAlign: TextAlign.center,
                  style: AppFonts.poppins14Black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '7 am - 9 am',
                  textAlign: TextAlign.center,
                  style: AppFonts.poppins14Black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '11 am - 1 pm',
                  textAlign: TextAlign.center,
                  style: AppFonts.poppins14Black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '2 pm - 4 pm',
                  textAlign: TextAlign.center,
                  style: AppFonts.poppins14Black,
                ),
                SizedBox(
                  height: getSizeWrtHeight(10),
                ),
                SizedBox(
                  height: getSizeWrtHeight(10),
                ),
                Text(
                  "Would you like to participate?",
                  textAlign: TextAlign.center,
                  style: AppFonts.poppins14Black,
                ),
                SizedBox(
                  height: getSizeWrtHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                        onTap: () async {
                          Get.back();
                          if (await checkLocationPermissions()) {
                            var sp = await SharedPreferences.getInstance();
                            sp.setBool(LOCATION_KEY, true);
                            showD = false;
                            controller.isLocTrackingActive.value = true;
                            startLocationTracking();
                            scheduleLocationUpload();
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
                        onTap: () async {
                          var sp = await SharedPreferences.getInstance();
                          sp.setBool(LOCATION_KEY, false);
                          Get.back();
                          showD = false;
                        },
                        text: "No",
                        height: getSizeWrtHeight(40),
                        radius: BorderRadius.circular(5),
                        widthh: getSize(60),
                        borderColor: const Color(0xff164B9B)),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
