import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/global_widgets/header_widget.dart';
import 'package:sro/global_widgets/listing.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/pages/register/register_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../global_widgets/custom_button.dart';
import '../../global_widgets/school_picker.dart';
import '../../globals.dart';
import '../../services/global_functions.dart';
import '../school/school_controller.dart';

class AddStudent extends GetView<RegisterController> {
  const AddStudent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.clearfilters();
        return true;
      },
      child: BackScaffold(
          hasAppBar: true,
          onBackPress: () async {
            await controller.clearfilters();
            Get.back();
          },
          trailing: TextButton(
              onPressed: () async {
                await controller.submitFunction();
              },
              child: Text(
                'Skip',
                style: AppFonts.poppinsMedium18blue,
              )),
          body: Obx(() => Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: HeaderWidget(
                      head: 'Add Students!',
                    ),
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(20),
                  ),
                  CustomTextField(
                    textController: controller.studentNameController.value,
                    onChanged: controller.onChnagedStudentName,
                    label: 'Nickname(Optional)',
                  ),
                  Obx(() {
                    return SchoolPicker(
                      cities: controller.cities
                          .map((element) => DropdownMenuItem(
                                value: element.name!,
                                child: Text(element.name!),
                              ))
                          .toList(),
                      schools:
                          SchoolController.getSchoolSearch(controller.schools)
                              .map((element) => DropdownMenuItem(
                                    value: element.id!,
                                    child: Text(element.name!),
                                  ))
                              .toList(),
                      onChangeType: controller.onChangedStudentType,
                      onChangeSchool: controller.onChnagedStudentSchool,
                      onChangeCity: controller.onChnagedStudentCity,
                      cityValue: controller.studentCity.value,
                      schoolValue: controller.studentSchool.value,
                      typeValue: controller.studentType.value,
                    );
                  }),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.students.length,
                      itemBuilder: (context, index) {
                        return Listing(
                          title: controller.students[index]['name'],
                          subtitle: controller.students[index]['school'],
                          elevation: 5,
                          trailing: GetImages(
                            image: AppImages.delete,
                            height: getSizeWrtHeight(60),
                            width: getSize(30),
                          ),
                          onTraillingTap: () {
                            controller.removeStudent(index);
                          },
                        );
                      }),
                  SizedBox(
                    height: getSizeWrtHeight(20),
                  ),
                  CustomButton(
                    height: getSizeWrtHeight(70),
                    widthh: width - getSize(30),
                    onTap: () {
                      if (controller.studentSchool.value == null) {
                        showToas('Please fill all fields');
                        return;
                      }
                      controller.addStudent(
                        controller.studentNameController.value.text,
                        SchoolController.getSchoolSearch(controller.schools)
                            .firstWhere((element) =>
                                element.id == controller.studentSchool.value)
                            .name!,
                      );
                      ++controller.studentCounter.value;
                      controller.studentNameController.value.clear();
                      unfocus();
                    },
                    text: 'Add Student',
                    textStyle: AppFonts.poppinsMedium16White,
                    color: const Color(0xff164B9B),
                    textColor: Colors.white,
                    borderColor: const Color(0xff164B9B),
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(18),
                  ),
                  CustomButton(
                    height: getSizeWrtHeight(70),
                    widthh: width - getSize(30),
                    onTap: () async {
                      Get.toNamed(AppRoutes.inviteCo);
                    },
                    text: 'Continue',
                    textStyle: AppFonts.poppinsMedium16blue,
                    textColor: const Color(0xff164B9B),
                    color: Colors.white,
                    borderColor: const Color(0xff164B9B),
                  ),
                ],
              ))),
    );
  }
}
