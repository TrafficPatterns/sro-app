import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/bottom_sheet.dart';
import '../../global_widgets/custom_button.dart';
import '../../global_widgets/special_listing_widget.dart';
import '../../global_widgets/text_field.dart';
import '../../services/global_functions.dart';
import '../../themes/app_fonts.dart';
import '../events/events_controller.dart';

class SizeDialogue extends GetView<EventsController> {
  const SizeDialogue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var temp = controller.exEvent.value!;
    String parentCount = '';
    String studentCount = '';
    String size = '';
    var focus = FocusNode();
    return GestureDetector(
      onTap: unfocus,
      child: Container(
        height: getSizeWrtHeight(temp.type == EventType.IC ? 200 : 300),
        width: getSize(350),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (temp.type != EventType.IC)
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: CustomTextField(
                      autofocus: true,
                      textInputType: TextInputType.number,
                      oneditingComplete: focus.requestFocus,
                      label: 'Parent Count',
                      onChanged: (value) {
                        parentCount = value;
                      },
                    )),
              Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 7),
                  child: CustomTextField(
                    textInputType: TextInputType.number,
                    focusNode: focus,
                    autofocus: temp.type == EventType.IC,
                    label: temp.type == EventType.IC ? 'Size' : 'Student Count',
                    onChanged: (value) {
                      if (temp.type == EventType.IC) {
                        size = value;
                      } else {
                        studentCount = value;
                      }
                    },
                  )),
              CustomButton(
                text: 'Done',
                onTap: () async {
                  if (temp.type != EventType.IC) {
                    if (studentCount.isEmpty || parentCount.isEmpty) {
                      showToas('All fields are required');
                      return;
                    }
                  } else {
                    if (size.isEmpty) {
                      showToas('All fields are required');
                      return;
                    }
                  }
                  Get.back();
                  var response = await controller.joinEvent(temp.eventID,
                      pCount: parentCount, sCount: studentCount, size: size);
                  await controller.getExternalEvent(temp.eventID!);
                  controller.update();
                  CustomBottomSheet.show(Get.context!,
                      label:
                          '${response['status']!}'.toString().capitalizeFirst,
                      child: Text(
                        response['message'],
                        style: AppFonts.poppins14Black,
                      ));
                },
                widthh: getSize(100),
                textStyle: AppFonts.poppinsMedium16White,
                color: const Color(0xff164B9B),
                textColor: Colors.white,
                borderColor: const Color(0xff164B9B),
              )
            ]),
      ),
    );
  }
}
