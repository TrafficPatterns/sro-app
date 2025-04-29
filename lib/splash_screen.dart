import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'global_widgets/get_images.dart';
import 'globals.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Future.delayed(const Duration(seconds: 3), () async {
      prefs = await SharedPreferences.getInstance();
      final String token = prefs!.getString('token') ?? '';
      if (token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.offAllNamed(AppRoutes.welcome);
      }
    });
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// logo widget
                GetImages(
                  height: getSizeWrtHeight(100),
                  width: getSize(200),
                  image: AppImages.appLogoBlack,
                  hasColor: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
