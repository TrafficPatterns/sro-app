import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../global_widgets/school_picker.dart';
import '../../services/global_functions.dart';

class Filters extends GetView<SchoolController> {
  const Filters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          GetBuilder<SchoolController>(builder: (controller) {
            return ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: getSizeWrtHeight(20)),
                SchoolPicker(
                  cities: controller.cities
                      .map((element) => DropdownMenuItem(
                            value: element.name!,
                            child: Text(element.name!),
                          ))
                      .toList(),
                  schools: SchoolController.getSchoolSearch(
                          controller.schoolSearch.value)
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
                ),
                SizedBox(
                  height: getSizeWrtHeight(20),
                ),
              ],
            );
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                widthh: getSize(250),
                text: 'Find School',
                textStyle: AppFonts.poppinsMedium16White,
                color: const Color(0xff164B9B),
                onTap: () async {
                  if (controller.schoolController.value == null ||
                      controller.schoolController.value!.isEmpty) {
                    showToas(
                        'Fill the required fields * to search for a school');
                  } else {
                    int i = 0;
                    bool found = false;
                    for (var x in controller.schools) {
                      if (x.id == controller.schoolID.value) {
                        controller.whichList.value = 0;
                        controller.index.value = i;
                        controller.schoolFilter.value = false;
                        controller.mapOpen.value = true;
                        controller.getSchoolMarkers(controller.schoolID.value,
                            set: true, index: i, which: 0);
                        controller.update();
                        found = true;
                        break;
                      }
                      i++;
                    }
                    if (!found) {
                      i = 0;
                      for (var x in controller.allSchools) {
                        if (x.id == controller.schoolID.value) {
                          controller.whichList.value = 1;
                          controller.index.value = i;
                          controller.schoolFilter.value = false;
                          controller.mapOpen.value = true;
                          controller.getSchoolMarkers(controller.schoolID.value,
                              set: true, index: i, which: 1);
                          controller.update();
                          found = true;
                          break;
                        }
                        i++;
                      }
                    }
                    if (!found) {
                      showToas('Something went wrong, please try agian');
                    } else {
                      controller.clearFilters();
                    }
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
