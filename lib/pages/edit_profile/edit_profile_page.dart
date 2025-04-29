import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/pages/edit_profile/edit_profile_controller.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../global_widgets/custom_button.dart';
import '../../global_widgets/school_picker.dart';
import '../../global_widgets/text_field.dart';
import '../../globals.dart';
import '../../route/app_routes.dart';
import '../../services/global_functions.dart';
import '../school/school_controller.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var sc = Get.put(SchoolController());
        sc.clearFilters();
        if (controller.change.value) {
          if (user.isStudent) {
            sc.getschools(navigateMap: true);
          }
        }
        return true;
      },
      child: HeaderScaffold(
        hasDivider: false,
        headerStyle: AppFonts.poppins16BlackBold,
        label: 'Edit Profile',
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () async {
            var sc = Get.put(SchoolController());
            sc.clearFilters();
            if (controller.change.value) {
              if (user.isStudent) {
                sc.getschools(navigateMap: true);
              }
            }
            Get.back();
          },
        ),
        child: Expanded(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => ListView(
              shrinkWrap: true,
              children: [
                CustomTextField(
                  isName: true,
                  label: 'First Name',
                  required: true,
                  textController: controller.firstNameController.value,
                  onChanged: (value) {
                    controller.change.value = true;
                    controller.onChangeName(value);
                  },
                  error: controller.namError.value,
                  onSubmit: (value) {},
                ),
                CustomTextField(
                  isName: true,
                  label: 'Last Name',
                  required: true,
                  textController: controller.lastNameController.value,
                  onChanged: (value) {
                    controller.change.value = true;
                    controller.onChangeLast(value);
                  },
                  error: controller.lastError.value,
                  onSubmit: (value) {},
                ),
                CustomTextField(
                  label: ' Mobile Phone',
                  required: true,
                  formatters: [
                    PhoneInputFormatter(
                      allowEndlessPhone: false,
                      defaultCountryCode: "US",
                    )
                  ],
                  error: controller.phoneError.value,
                  textController: controller.phoneController.value,
                  onChanged: (value) {
                    controller.change.value = true;
                    controller.onChangephone(value);
                  },
                  onSubmit: (value) {},
                ),
                CustomTextField(
                  label: 'Email',
                  required: true,
                  textController: controller.emailController.value,
                  onChanged: (value) {
                    controller.change.value = true;
                    controller.onChangeEmail(value);
                  },
                  error: controller.emailError.value,
                  onSubmit: (value) {},
                ),
                if (user.isStudent)
                  GetBuilder<SchoolController>(builder: (sController) {
                    return Column(
                      children: [
                        SchoolPicker(
                          expand: true,
                          cities: sController.cities
                              .map((element) => DropdownMenuItem(
                                    value: element.name!,
                                    child: Text(element.name!),
                                  ))
                              .toList(),
                          schools: SchoolController.getSchoolSearch(
                                  sController.schoolSearch.value)
                              .map((element) => DropdownMenuItem(
                                    value: element.name!,
                                    child: Text(element.name!),
                                  ))
                              .toList(),
                          onChangeType: sController.onChnagedType,
                          onChangeSchool: (value) {
                            controller.change.value = true;
                            controller.school.value = value;
                            sController.onChnagedSchool(value);
                          },
                          onChangeCity: sController.onChnagedCity,
                          cityValue: sController.cityController.value,
                          schoolValue: sController.schoolController.value,
                          typeValue: sController.typeController.value,
                        ),
                        SizedBox(
                          height: getSizeWrtHeight(20),
                        )
                      ],
                    );
                  })
                else
                  SizedBox(
                    height: getSizeWrtHeight(200),
                  ),
                CustomButton(
                  height: getSizeWrtHeight(65),
                  widthh: width - getSize(30),
                  onTap: () {
                    Get.toNamed(AppRoutes.changePassword);
                  },
                  text: 'Change Password',
                  textStyle: AppFonts.poppinsMedium16blue,
                  textColor: const Color(0xff164B9B),
                  color: Colors.white,
                  borderColor: const Color(0xff164B9B),
                ),
                SizedBox(
                  height: getSizeWrtHeight(18),
                ),
                CustomButton(
                    height: getSizeWrtHeight(65),
                    widthh: width - getSize(30),
                    onTap: controller.validate
                        ? () async {
                            await controller.editProfile();
                          }
                        : null,
                    text: 'Save',
                    textStyle: AppFonts.poppinsMedium16White,
                    color: const Color(0xff164B9B),
                    textColor: Colors.white,
                    borderColor: const Color(0xff164B9B)),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
