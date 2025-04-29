import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/globals.dart';
import 'package:sro/models/event_member.dart';
import 'package:sro/pages/events/events_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../global_widgets/bottom_sheet.dart';

class EventMemberOptions extends GetView<EventsController> {
  final String? eventID;
  final EventMemberModel? model;
  const EventMemberOptions({Key? key, this.eventID, this.model})
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
                TextButton(
                  onPressed: () {},
                  child: Text(
                    model!.getFullName(),
                    style: AppFonts.poppins15Grey,
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                  height: 1,
                ),
                InkWell(
                  onTap: () async {
                    var response =
                        await controller.makeAdmin(eventID, model!.userID);
                    await controller.getExternalEvent(eventID!);
                    controller.update();
                    Get.back();
                    CustomBottomSheet.show(
                      Get.context!,
                      label: '${response['message']}',
                      child: Text(
                        '${response['message']}',
                        style: AppFonts.poppins14Black,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: getSizeWrtHeight(50),
                    child: Center(
                        child: Text(
                      'Make Admin',
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
                    var response = await controller.kickFromEvent(
                      eventID,
                      model!.userID,
                    );
                    Get.back();
                    if (response['status'] == 'success') {
                      (controller.exEvent.value == null
                              ? controller.eventsList[
                                  controller.currentMessageList.value]
                              : controller.exEvent.value!)
                          .eventMembers
                          .removeWhere((element) {
                        if (element.userID == model!.userID) {
                          return true;
                        }
                        return false;
                      });
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
                      'Remove User',
                      style: AppFonts.poppinsMedium16Red,
                    )),
                  ),
                ),
              ]),
            ),
            SizedBox(height: getSize(10)),
            Container(
              height: getSizeWrtHeight(50),
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: InkWell(
                onTap: Get.back,
                child: SizedBox(
                  child: Center(
                      child: Text(
                    'Cancel',
                    style: AppFonts.poppinsMedium16blue,
                  )),
                ),
              ),
            )
          ]),
    );
  }
}
