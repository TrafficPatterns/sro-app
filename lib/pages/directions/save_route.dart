import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/pages/directions/directions_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class SaveRoute extends GetView<DirectionsController> {
  const SaveRoute({Key? key}) : super(key: key);
  static String routeKey = 'routeKey';
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          controller.nameController.value.clear();
          return Future.value(true);
        },
        child: Container(
          height: getSizeWrtHeight(250),
          width: getSize(350),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Text(
                'Save This Route',
                style: AppFonts.poppins14Black,
                textAlign: TextAlign.center,
              )),
              CustomTextField(
                  autofocus: true,
                  textController: controller.nameController.value,
                  label: 'Route Name'),
              Center(
                  child: CustomButton(
                onTap: () async {
                  unfocus();
                  if (controller.nameController.value.text.isEmpty) {
                    showToas('Please type a name');
                    return;
                  }
                  var sp = await SharedPreferences.getInstance();
                  var list = <String, dynamic>{};
                  list = sp.getString(routeKey) != null
                      ? json.decode(sp.getString(routeKey)!)
                      : {};
                  log(list.toString());
                  if (list[controller.nameController.value.text] != null) {
                    showToas('Name already used, please use a different one');
                    return;
                  }
                  list[controller.nameController.value.text] = [
                    controller.school.value.id,
                    controller.initialResponse.value
                  ];
                  sp.setString(routeKey, json.encode(list));
                  Get.back();
                  controller.nameController.value.clear();
                },
                text: 'Save',
                textStyle: AppFonts.poppins14White,
                color: const Color(0xff164B9B),
                borderColor: const Color(0xff164B9B),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
