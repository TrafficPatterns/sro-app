import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/header_widget.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/globals.dart';
import 'package:sro/pages/login/login_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/themes/app_fonts.dart';

class LoginPage extends GetView<LoginCOntroller> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackScaffold(
      hasAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: HeaderWidget(
              head: 'Welcome Back!',
              subHead: 'Login into your account',
            ),
          ),
          SizedBox(
            height: getSizeWrtHeight(145),
          ),
          Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                    textController: controller.emailController.value,
                    focusNode: controller.emailFocus.value,
                    label: 'Email',
                    error: (controller.errorEmail.value.isEmpty ||
                            !controller.hasWrittenEmail.value)
                        ? null
                        : controller.errorEmail.value,
                    required: true,
                    onChanged: (value) {
                      controller.onChnagedEmail(value);
                      if (controller.errorEmail
                          .toLowerCase()
                          .contains('user')) {
                        controller.errorEmail.value = '';
                      }
                    },
                    onSubmit: (value) {
                      controller.onChnagedEmail(value);
                      controller.passwordFocus.value.requestFocus();
                    },
                  ),
                  SizedBox(height: getSizeWrtHeight(18)),
                  CustomTextField(
                      textController: controller.passwordController.value,
                      focusNode: controller.passwordFocus.value,
                      label: 'Password',
                      isPass: true,
                      hasShowHide: true,
                      required: true,
                      error: controller.errorPass.value,
                      onChanged: (value) {
                        controller.onChnagedPass(value);
                        controller.errorPass.value = null;
                      },
                      onSubmit: (value) {
                        controller.onChnagedPass(value);
                        // Get.offAllNamed(AppRoutes.dashboard);
                      }),
                  SizedBox(
                    height: getSizeWrtHeight(10),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text(
                        'Forgot Password',
                        style: AppFonts.poppinsMedium14blue,
                      ),
                      onPressed: () {
                        controller.resetLevel.value = 1;
                        controller.reset();
                        Get.toNamed(AppRoutes.forgotPassword);
                      },
                    ),
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(10),
                  ),
                  CustomButton(
                    height: getSizeWrtHeight(65),
                    widthh: width - getSize(30),
                    onTap: () {
                      if (controller.checkValidationOfFields) {
                        controller.login(
                            controller.email!, controller.password!);
                      }
                    },
                    text: 'Login',
                    textStyle: AppFonts.poppinsMedium16White,
                    color: (controller.errorEmail.value.isEmpty) ||
                            (!controller.hasWrittenEmail.value &&
                                !controller.hasWrittenPass.value)
                        ? const Color(0xff164B9B)
                        : const Color.fromARGB(255, 201, 199, 199),
                    textColor: Colors.white,
                    borderColor: (controller.errorEmail.value.isEmpty) ||
                            (!controller.hasWrittenEmail.value &&
                                !controller.hasWrittenPass.value)
                        ? const Color(0xff164B9B)
                        : const Color.fromARGB(255, 201, 199, 199),
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(18),
                  ),
                  CustomButton(
                    height: getSizeWrtHeight(65),
                    widthh: width - getSize(30),
                    onTap: () {
                      isGuest = true;
                      Get.toNamed(AppRoutes.school, arguments: true);
                    },
                    text: 'Continue As Guest',
                    textStyle: AppFonts.poppinsMedium16blue,
                    textColor: const Color(0xff164B9B),
                    color: Colors.white,
                    borderColor: const Color(0xff164B9B),
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: AppFonts.poppins16Black,
                      ),
                      TextButton(
                          onPressed: () {
                            Get.offAndToNamed(AppRoutes.register);
                          },
                          child: Text(
                            'Register',
                            style: AppFonts.poppinsMedium16blue,
                          )),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
