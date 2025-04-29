import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/globals.dart';
import 'package:sro/pages/events/events_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../global_widgets/bottom_sheet.dart';

class DeleteLeave extends GetView<EventsController> {
  final String? eventID;
  final bool? isChat;
  const DeleteLeave({Key? key, this.eventID, this.isChat = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                InkWell(
                  onTap: () async {
                    if (isChat!) {
                      Get.back();
                      Get.back();
                    }
                    Get.back();
                    dynamic response =
                        await controller.leaveDeleteEvent(eventID!, 'delete');
                    if (response['status'] == 'success') {
                      Get.back();
                    }
                    CustomBottomSheet.show(Get.context!,
                        label:
                            '${response['status']!}'.toString().capitalizeFirst,
                        child: Text(
                          response['message'],
                          style: AppFonts.poppins14Black,
                        ));
                  },
                  child: SizedBox(
                    height: getSizeWrtHeight(50),
                    child: Center(
                        child: Text(
                      'Delete',
                      style: AppFonts.poppinsMedium16blue,
                    )),
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                  height: 1,
                ),
                InkWell(
                  onTap: () async {
                    if (isChat!) {
                      Get.back();
                      Get.back();
                    }
                    Get.back();
                    dynamic response =
                        await controller.leaveDeleteEvent(eventID!, 'leave');
                    if (response['status'] == 'success') {
                      Get.back();
                    }
                    CustomBottomSheet.show(Get.context!,
                        label:
                            '${response['status']!}'.toString().capitalizeFirst,
                        child: Text(
                          response['message'],
                          style: AppFonts.poppins14Black,
                        ));
                  },
                  child: SizedBox(
                    height: getSizeWrtHeight(50),
                    child: Center(
                        child: Text(
                      'Leave',
                      style: AppFonts.poppinsMedium16Red,
                    )),
                  ),
                ),
              ]),
            ),
            SizedBox(height: getSize(10)),
            InkWell(
              onTap: Get.back,
              child: Container(
                height: getSizeWrtHeight(50),
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Center(
                    child: Text(
                  'Cancel',
                  style: AppFonts.poppinsMedium16blue,
                )),
              ),
            )
          ]),
    );
  }
}
