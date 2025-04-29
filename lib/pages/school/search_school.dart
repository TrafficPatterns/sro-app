import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/globals.dart';
import 'package:sro/pages/school/data.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/themes/app_fonts.dart';

class SearchSchool extends GetView<SchoolController> {
  const SearchSchool({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(onWillPop: () async {
      unfocus();
      if (controller.legendOpen.value) {
        controller.legendOpen.value = false;
        controller.update();
        return false;
      }
      if (controller.schoolFilter.value) {
        controller.clearFilters();
        return false;
      }
      if (controller.mapOpen.value && !user.isStudent) {
        var now = DateTime.now();
        var dif = now.difference(controller.clickedOpenMap);
        if (dif.inMilliseconds > 1200) {
          controller.mapOpen.value = false;
          controller.resetLegends();
          controller.resizeMarkers(
              controller.whichList.value == 0
                  ? controller.schools[controller.index.value].id!
                  : controller.allSchools[controller.index.value].id!,
              15.0);
        } else {
          Future.delayed(Duration(milliseconds: 1200 - dif.inMilliseconds), () {
            controller.mapOpen.value = false;
            controller.resetLegends();
          });
        }
        return false;
      }
      if (Get.arguments != null) {
        var bl = Get.arguments;
        if (bl) {
          isGuest = false;
          return true;
        }
      }
      return true;
    }, child: Obx(() {
      return GestureDetector(
        onTap: unfocus,
        child: HeaderScaffold(
            centerTitle: true,
            leading: ((controller.mapOpen.value ||
                            controller.schoolFilter.value) &&
                        (user.role != 'student' ||
                            controller.legendOpen.value)) ||
                    (Get.arguments != null && Get.arguments)
                ? BackButton(
                    color: Colors.black,
                    onPressed: () {
                      unfocus();
                      if (controller.legendOpen.value) {
                        controller.legendOpen.value = false;
                        return;
                      }
                      if (controller.schoolFilter.value) {
                        controller.clearFilters();
                        return;
                      }
                      if (controller.mapOpen.value && !user.isStudent) {
                        var now = DateTime.now();
                        var dif = now.difference(controller.clickedOpenMap);
                        if (dif.inMilliseconds > 1200) {
                          controller.mapOpen.value = false;
                          controller.resetLegends();
                        } else {
                          Future.delayed(
                              Duration(milliseconds: 1200 - dif.inMilliseconds),
                              () {
                            controller.mapOpen.value = false;
                            controller.resetLegends();
                          });
                        }
                        return;
                      }
                      if (Get.arguments != null) {
                        var bl = Get.arguments;
                        if (bl) {
                          isGuest = false;
                          Get.back();
                        }
                      }
                    },
                  )
                : null,
            label: (controller.mapOpen.value)
                ? controller.whichList.value == 0
                    ? controller.schools[controller.index.value].name
                    : controller.allSchools[controller.index.value].name
                : 'Schools',
            headerStyle: AppFonts.poppins16BlackBold,
            headerPadding: const EdgeInsets.only(top: 15.0, bottom: 10),
            trailing: controller.mapOpen.value
                ? null
                : controller.schoolFilter.value || isGuest
                    ? null
                    : GestureDetector(
                        onTap: () {
                          controller.schoolFilter.value = true;
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: GetImages(
                            image: AppImages.filter,
                          ),
                        ),
                      ),
            // child: Padding(
            //     padding: const EdgeInsets.all(20.0),
            child: const Data()),
      );
    }));
  }
}
