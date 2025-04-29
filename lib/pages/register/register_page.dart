import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/header_widget.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/school_picker.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/globals.dart';
import 'package:sro/pages/register/register_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/themes/app_fonts.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import '../school/school_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackScaffold(
      hasAppBar: true,
      // clear: true,
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: HeaderWidget(
                head: 'Hello!',
                subHead: 'Register a new account',
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            SlidingSwitch(
              value: false,
              width: width - getSize(40),
              onChanged: (value) {
                controller.student.value = !controller.student.value;
                controller.clearfilters();
              },
              height: getSizeWrtHeight(60),
              animationDuration: const Duration(milliseconds: 150),
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              textOff: "Parent",
              textOn: "Student",
              colorOn: const Color(0xff164B9B),
              colorOff: const Color(0xff164B9B),
              background: const Color(0xffe4e5eb),
              buttonColor: Colors.white,
              inactiveColor: const Color(0xff212529),
            ),
            SizedBox(
              height: getSizeWrtHeight(20),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: controller.student.value
                  ? Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color(0xffFFF6D1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18))),
                          height: getSizeWrtHeight(90),
                          width: getSize(350),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Registration for middle and high school students only.',
                                style: AppFonts.poppins14BlackBold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getSizeWrtHeight(20),
                        )
                      ],
                    )
                  : const SizedBox(),
            ),
            CustomTextField(
              isName: true,
              focusNode: controller.nameFocus,
              label: 'First Name',
              textController: controller.nameController.value,
              error: controller.getErrorName,
              onChanged: controller.onChnagedName,
              required: true,
              onSubmit: (_) => controller.lastNameFocus.requestFocus(),
            ),
            SizedBox(
              height: getSizeWrtHeight(20),
            ),
            CustomTextField(
              isName: true,
              focusNode: controller.lastNameFocus,
              label: 'Last Name',
              textController: controller.lastNameController.value,
              error: controller.getErrorLastName,
              onChanged: controller.onChnagedLastName,
              required: true,
              onSubmit: (_) => controller.phoneFocus.requestFocus(),
            ),
            SizedBox(
              height: getSizeWrtHeight(20),
            ),
            CustomTextField(
                focusNode: controller.phoneFocus,
                formatters: [
                  PhoneInputFormatter(
                    allowEndlessPhone: false,
                    defaultCountryCode: "US",
                  )
                ],
                textController: controller.phoneController.value,
                label: 'Mobile Phone',
                textInputType: TextInputType.phone,
                error: controller.errorPhone.value,
                onChanged: controller.onChnagedPhone,
                required: controller.student.value ? false : true,
                onSubmit: (_) => controller.emailFocus.requestFocus()),
            SizedBox(
              height: getSizeWrtHeight(20),
            ),
            CustomTextField(
              focusNode: controller.emailFocus,
              label: 'Email',
              textController: controller.emailController.value,
              error: controller.getErrorEmail,
              onChanged: controller.onChnagedEmail,
              onSubmit: !controller.student.value
                  ? (_) => controller.passwordFocus.requestFocus()
                  : null,
              required: true,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: controller.student.value
                  ? SchoolPicker(
                      cities: controller.cities
                          .map((element) => DropdownMenuItem(
                                value: element.name!,
                                child: Text(element.name!),
                              ))
                          .toList(),
                      schools:
                          SchoolController.getSchoolSearch(controller.schools)
                              .map((element) => DropdownMenuItem(
                                    value: element.name!,
                                    child: Text(element.name!),
                                  ))
                              .toList(),
                      onChangeType: controller.onChnagedType,
                      onChangeSchool: controller.onChnagedSchool,
                      onChangeCity: controller.onChnagedCity,
                      cityValue: controller.cityController.value,
                      schoolValue: controller.schoolController.value,
                      typeValue: controller.typeController.value,
                      schoolError: controller.schoolError.value,
                    )
                  : SizedBox(
                      height: getSizeWrtHeight(20),
                    ),
            ),
            CustomTextField(
              focusNode: controller.passwordFocus,
              label: 'Password',
              isPass: true,
              textController: controller.passwordController.value,
              error: controller.getErrorPass,
              hasShowHide: true,
              required: true,
              onSubmit: (_) => controller.confirmFocus.requestFocus(),
              onChanged: controller.onChnagedPass,
            ),
            SizedBox(
              height: getSizeWrtHeight(20),
            ),
            CustomTextField(
              focusNode: controller.confirmFocus,
              label: 'Confirm Password',
              isPass: true,
              error: controller.getErrorConfirm,
              onChanged: controller.onChnagedConfirm,
              hasShowHide: true,
              required: true,
            ),
            SizedBox(
              height: getSizeWrtHeight(20),
            ),
            Text(
              'By clicking on “${controller.student.value ? 'Register' : 'Continue'}”, you accept',
              style: AppFonts.poppinsBold14Grey,
            ),
            TextButton(
                onPressed: () {
                  launchUrl(Uri.parse(privacyPolicyUrl));
                },
                child: Text(
                  'Our Privacy Policy',
                  style: AppFonts.poppinsMedium16blue,
                )),
            SizedBox(
              height: getSizeWrtHeight(18),
            ),
            CustomButton(
              height: getSizeWrtHeight(65),
              widthh: width - getSize(30),
              onTap: !controller.checkValidationOfFields
                  ? () {
                      controller.shiftFocus();
                    }
                  : () async {
                      if (controller.student.value) {
                        await controller.submitFunction();
                      } else {
                        if (!(await controller.checkEmail())) {
                          Get.toNamed(AppRoutes.registerAddStudents);
                        }
                      }
                    },
              text: controller.student.value ? 'Register' : 'Continue',
              textStyle: AppFonts.poppinsMedium16White,
              color: const Color(0xff164B9B),
              textColor: controller.checkValidationOfFields
                  ? Colors.white
                  : const Color(0xff164B9B),
              borderColor: const Color(0xff164B9B),
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
                  "Already have an account?",
                  style: AppFonts.poppins16Black,
                ),
                TextButton(
                    onPressed: () {
                      Get.offAndToNamed(AppRoutes.login);
                    },
                    child: Text(
                      'Login',
                      style: AppFonts.poppinsMedium16blue,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
