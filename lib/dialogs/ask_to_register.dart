import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/themes/app_fonts.dart';

import '../route/app_routes.dart';

class AskRegister extends StatelessWidget {
  const AskRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Attention!',
                style: AppFonts.poppins14RedBold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'To View and Create School Depot Station Events - Registration is Required',
                style: AppFonts.poppins14BlackBold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                      onTap: () async {
                        isGuest = false;
                        Get.offAllNamed(AppRoutes.welcome);
                        Get.toNamed(AppRoutes.register);
                      },
                      text: "Register",
                      height: getSizeWrtHeight(40),
                      radius: BorderRadius.circular(5),
                      widthh: getSize(120),
                      color: const Color(0xff164B9B),
                      textStyle: AppFonts.poppins14White,
                      borderColor: const Color(0xff164B9B)),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomButton(
                      onTap: Get.back,
                      text: "Dismiss",
                      height: getSizeWrtHeight(40),
                      radius: BorderRadius.circular(5),
                      widthh: getSize(120),
                      borderColor: const Color(0xff164B9B)),
                ],
              ),
            ],
          )),
    );
  }
}
