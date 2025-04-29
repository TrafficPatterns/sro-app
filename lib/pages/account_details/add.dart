import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/global_widgets/header_widget.dart';
import 'package:sro/global_widgets/listing.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../global_widgets/custom_button.dart';
import '../../global_widgets/school_picker.dart';
import '../../globals.dart';
import '../../services/global_functions.dart';

class AddStudentSettings extends GetView<SchoolController> {
  const AddStudentSettings({Key? key}) : super(key: key);

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
            body: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: HeaderWidget(
                    head: 'Add Studets!',
                  ),
                ),
                SizedBox(
                  height: getSizeWrtHeight(20),
                ),
                CustomTextField(
                  width: width,
                  textController: controller.studentNameController.value,
                  error: controller.studentNameError.value,
                  label: 'Nickname (Optional)',
                  required: false,
                ),
                GetBuilder<SchoolController>(builder: (controller) {
                  return SchoolPicker(
                    expand: true,
                    cities: controller.cities
                        .map((element) => DropdownMenuItem(
                              value: element.name!,
                              child: Text(element.name!),
                            ))
                        .toList(),
                    schools: SchoolController.getSchoolSearch(
                            controller.schoolSearch.value)
                        .toSet()
                        .toList()
                        .map((element) => DropdownMenuItem(
                              value: element.id!,
                              child: Text(element.name!),
                            ))
                        .toList(),
                    onChangeType: controller.onChnagedType,
                    onChangeSchool: controller.onChnagedSchool,
                    onChangeCity: controller.onChnagedCity,
                    cityValue: controller.cityController.value,
                    schoolValue: controller.schoolController.value,
                    typeValue: controller.typeController.value,
                  );
                }),
                SizedBox(
                  height: getSizeWrtHeight(20),
                ),
                GetBuilder<SchoolController>(builder: (controller) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.schools.length,
                      itemBuilder: (context, index) {
                        return Listing(
                          widtth: width,
                          title: controller.schools[index].studentName,
                          subtitle: controller.schools[index].name,
                          elevation: 5,
                          trailing: GetImages(
                            image: AppImages.delete,
                            height: getSizeWrtHeight(60),
                            width: getSize(30),
                          ),
                          onTraillingTap: () async {
                            await controller.deleteStudent(
                                schoolID: controller.schools[index].id,
                                studentName:
                                    controller.schools[index].studentName);
                            controller.update();
                          },
                        );
                      });
                }),
                SizedBox(
                  height: getSizeWrtHeight(20),
                ),
                CustomButton(
                  height: getSizeWrtHeight(75),
                  widthh: width - getSize(30),
                  onTap: () {
                    if (controller.schoolController.value == null) {
                      showToas(
                          'Make sure you properly filled all the required fields');
                      return;
                    }
                    controller.addStudent(
                      studentName: controller.studentNameController.value.text,
                      schoolID: controller.schoolController.value,
                    );
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
                  height: getSizeWrtHeight(20),
                ),
              ],
            )));
  }
}
