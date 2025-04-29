import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/header_widget.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/pages/login/login_controller.dart';
import 'package:sro/services/global_functions.dart';

import '../../global_widgets/custom_button.dart';
import '../../global_widgets/text_field.dart';
import '../../globals.dart';
import '../../themes/app_fonts.dart';

class ForgotPassword extends GetView<LoginCOntroller> {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.emailForgotController.value.clear();
        controller.resetLevel.value = 1;
        controller.emailForgotError.value = null;
        return true;
      },
      child: BackScaffold(
          hasAppBar: true,
          onBackPress: () {
            Get.back();
            controller.emailForgotController.value.clear();
            controller.resetLevel.value = 1;
            controller.emailForgotError.value = null;
          },
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => HeaderWidget(
                  head: 'Reset Your Password!',
                  subHead:
                      controller.resetPhrases[controller.resetLevel.value - 1],
                ),
              ),
              SizedBox(
                height: getSizeWrtHeight(245),
              ),
              Obx(() {
                return Column(
                  children: [
                    CustomTextField(
                      textController: controller.emailForgotController.value,
                      focusNode: controller.emailFocusForgit.value,
                      error: controller.resetLevel.value == 3
                          ? controller.emailForgotError.value
                          : null,
                      label: controller.resetLevel.value == 1
                          ? 'Email'
                          : controller.resetLevel.value == 2
                              ? 'Code'
                              : 'New Password',
                      required: true,
                      onChanged: controller.resetLevel.value == 1
                          ? controller.onChnagedEmailForgot
                          : controller.resetLevel.value == 2
                              ? controller.onChnagedCodeForgot
                              : controller.onChnagedPassForgot,
                      onSubmit: controller.onChnagedEmailForgot,
                    ),
                    SizedBox(height: getSizeWrtHeight(40)),
                    CustomButton(
                      height: getSizeWrtHeight(65),
                      widthh: width - getSize(30),
                      onTap: () async {
                        if (controller
                            .emailForgotController.value.text.isNotEmpty) {
                          if (await controller.forgotPassword()) {
                            if (controller.resetLevel.value == 3) {
                              Get.back();
                              controller.emailForgotController.value.clear();
                              controller.resetLevel.value = 1;
                              controller.emailForgotError.value = null;
                              return;
                            }
                            controller.resetLevel.value++;
                            controller.emailForgotController.value.clear();
                          }
                        } else {
                          controller.emailFocusForgit.value.requestFocus();
                        }
                      },
                      text: controller.resetLevel.value == 1
                          ? 'Send Code'
                          : controller.resetLevel.value == 2
                              ? 'Validate Code'
                              : 'Submit Password',
                      textStyle: AppFonts.poppinsMedium16White,
                      color: const Color(0xff164B9B),
                      textColor: Colors.white,
                      borderColor: const Color(0xff164B9B),
                    ),
                  ],
                );
              }),
            ],
          )),
    );
  }
}
