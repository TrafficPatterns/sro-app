import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/global_widgets/header_widget.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/services/globals/global_user_variables.dart';

import '../../global_widgets/custom_button.dart';
import '../../globals.dart';
import '../../route/app_routes.dart';
import '../../services/global_functions.dart';
import '../../themes/app_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackScaffold(
      color: const Color(0xff004196),
      hasAppBar: false,
      body: SafeArea(
        child: SizedBox(
          height: height - getSizeWrtHeight(65),
          width: width - getSizeWrtHeight(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GetImages(
                      image: AppImages.appLogoWhite,
                      height: getSizeWrtHeight(150),
                      width: getSize(300),
                    ),
                  ),
                  GetImages(
                    image: AppImages.mapGig,
                    height: getSize(180),
                    width: getSize(200),
                  ),
                ],
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: HeaderWidget(
                      headStyle: AppFonts.headerWhite,
                      subHeadStyle: AppFonts.subHeaderWhite,
                      head: 'Welcome',
                      subHead: 'Safe Routes To School\nPrograms Modernized',
                    ),
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(25),
                  ),
                  CustomButton(
                    height: getSizeWrtHeight(65),
                    widthh: width - getSize(30),
                    onTap: () {
                      Get.toNamed(AppRoutes.login);
                    },
                    text: 'Login',
                    textStyle: AppFonts.poppinsMedium16White,
                    color: const Color(0xff164B9B),
                    textColor: Colors.white,
                    borderColor: Colors.white,
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(15),
                  ),
                  CustomButton(
                    height: getSizeWrtHeight(65),
                    widthh: width - getSize(30),
                    onTap: () {
                      Get.toNamed(AppRoutes.register);
                    },
                    text: 'Register',
                    textStyle: AppFonts.poppinsMedium16blue,
                    textColor: const Color(0xff164B9B),
                    color: Colors.white,
                    borderColor: const Color(0xff164B9B),
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(15),
                  ),
                  TextButton(
                      onPressed: () {
                        isGuest = true;
                        Get.toNamed(AppRoutes.school, arguments: true);
                      },
                      child: Text(
                        'Continue As Guest',
                        style: AppFonts.poppinsMedium16White,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
