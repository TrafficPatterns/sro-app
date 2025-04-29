import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/dialog_box.dart';
import 'package:sro/pages/account/account_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class AreYouSure extends StatelessWidget {
  const AreYouSure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      dismissable: true,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: getSize(250),
                child: Text(
                  'Are you sure you want to delete your account?',
                  style: AppFonts.poppins14BlackBold,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'This action is irreversible',
                style: AppFonts.poppins14RedBold,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                      onTap: () {
                        Get.back();
                        AccountController.deleteAccount();
                      },
                      color: const Color(0xff164B9B),
                      widthh: getSize(60),
                      height: getSize(40),
                      textStyle: AppFonts.poppins12WhiteBold,
                      borderColor: Colors.white,
                      radius: BorderRadius.circular(10),
                      text: 'Yes'),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomButton(
                    onTap: Get.back,
                    color: Colors.white,
                    widthh: getSize(60),
                    height: getSize(40),
                    radius: BorderRadius.circular(10),
                    borderColor: const Color(0xff164B9B),
                    text: 'No',
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
