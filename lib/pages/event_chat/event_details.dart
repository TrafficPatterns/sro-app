import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sro/global_widgets/bottom_sheet.dart';
import 'package:sro/global_widgets/circle_container_with_image.dart';
import 'package:sro/global_widgets/dialog_box.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/global_widgets/special_listing_widget.dart';
import 'package:sro/globals.dart';
import 'package:sro/models/event_member.dart';
import 'package:sro/pages/event_chat/delete_leave.dart';
import 'package:sro/pages/event_chat/event_member_options.dart';
import 'package:sro/pages/event_chat/size_dialogu.dart';
import 'package:sro/pages/events/events_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';

import '../../global_widgets/custom_button.dart';
import '../../global_widgets/hour.dart';
import '../../global_widgets/listing.dart';
import '../../global_widgets/map.dart';
import '../../themes/app_fonts.dart';

class EventDetails extends GetView<EventsController> {
  const EventDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];
    final bool isChat = Get.arguments ?? false;
    return GetBuilder<EventsController>(builder: (controller) {
      bool amIinEvent = false;
      if (controller.exEvent.value != null) {
        for (var x in controller.exEvent.value!.eventMembers) {
          if (x.userID == user.userID) {
            amIinEvent = true;
          }
        }
      }
      return HeaderScaffold(
        label: 'Event Detail',
        headerStyle: AppFonts.poppins18Black,
        leading: BackButton(
          onPressed: Get.back,
          color: Colors.black,
        ),
        trailing: user.userID == controller.exEvent.value!.adminId
            ? TextButton(
                onPressed: () async {
                  await controller.getDataReadyForEdit();
                  Get.toNamed(AppRoutes.addEvents);
                },
                child: Text('Edit', style: AppFonts.poppinsMedium16blue))
            : null,
        centerTitle: true,
        child: Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(15)),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: getSizeWrtHeight(15),
                    ),
                    CircleImage(
                      iconPadding: const EdgeInsets.all(15),
                      iconFit: BoxFit.fill,
                      eventType: controller.exEvent.value!.type,
                      size: getSize(90),
                    ),
                    SizedBox(
                      height: getSizeWrtHeight(30),
                    ),
                    Text(
                      '${getNameofEvent(controller.exEvent.value!.type!)} Event',
                      style: AppFonts.poppins18BlackBold,
                    ),
                    SizedBox(
                      height: getSizeWrtHeight(15),
                    ),
                    Text(
                      '${controller.exEvent.value!.title}',
                      style: AppFonts.poppins14BlackBold,
                    ),
                    SizedBox(
                      height: getSizeWrtHeight(30),
                    ),
                    if (controller.exEvent.value!.type != EventType.IC)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                  '${controller.exEvent.value!.allParents} members'),
                              const Text('Parents')
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  '${controller.exEvent.value!.allStudents} members'),
                              const Text('Students')
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  '${controller.exEvent.value!.total} members'),
                              const Text('Total')
                            ],
                          )
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Total Size',
                                style: AppFonts.poppins14BlackBold,
                              ),
                              Text(
                                '${controller.exEvent.value!.sizeLimit}',
                                style: AppFonts.poppins14Black,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Current Size',
                                style: AppFonts.poppins14BlackBold,
                              ),
                              Text('${controller.exEvent.value!.size}',
                                  style: AppFonts.poppins14Black),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(
                      height: getSizeWrtHeight(35),
                    ),
                    const Divider(
                      color: Color(0xffECEDEE),
                      thickness: 2,
                      height: 2,
                    ),
                    SizedBox(
                      height: getSizeWrtHeight(5),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0, bottom: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Meetup Location *',
                            style: AppFonts.poppins16Black,
                          )),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: SizedBox(
                        height: getSizeWrtHeight(170),
                        width: getSize(350),
                        child: Obx(() {
                          return MapView(
                            initialMarker: controller.icon.value,
                            markerAtInitial: true,
                            initialPosition: CameraPosition(
                                bearing: 192.8334901395799,
                                target: controller.exEvent.value!.location!,
                                zoom: 19.151926040649414),
                            hasZoom: false,
                            onTap: (_) {},
                            liteMode: true,
                            hasCompass: false,
                            lockGestures: true,
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: getSizeWrtHeight(20),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Event Description',
                        style: AppFonts.poppins16BlackBold,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          (controller.exEvent.value!.description) ?? '',
                          style: AppFonts.poppins14Black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSizeWrtHeight(20),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Departure Time',
                        style: AppFonts.poppins16BlackBold,
                      ),
                    ),
                    if ((controller.exEvent.value!.hasCustomSchedule) ?? true)
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.exEvent.value!.schedule.length,
                          itemBuilder: (_, index) {
                            int? hour, minute;
                            String? amPm;
                            if ((controller.exEvent.value!.schedule[index]) !=
                                null) {
                              hour = controller
                                  .exEvent.value!.schedule[index]!.hour;
                              minute = controller
                                  .exEvent.value!.schedule[index]!.minute;
                              amPm = controller
                                  .exEvent.value!.schedule[index]!.amPm;
                            } else {
                              return const SizedBox();
                            }
                            return Listing(
                              onTap: () {},
                              color: Colors.white,
                              heigth: getSizeWrtHeight(60),
                              title: days[index],
                              titleStyle: AppFonts.poppins14Black,
                              onTraillingTap: () {},
                              trailing: Hour(
                                hour: hour,
                                minute: minute,
                                amPm: amPm,
                              ),
                            );
                          })
                    else
                      Obx(() {
                        int? hour, minute;
                        String? amPm;
                        hour = controller.exEvent.value!.schedule[0]!.hour;
                        minute = controller.exEvent.value!.schedule[0]!.minute;
                        amPm = controller.exEvent.value!.schedule[0]!.amPm;
                        return Listing(
                          color: Colors.white,
                          heigth: getSizeWrtHeight(65),
                          title: 'All Days',
                          titleStyle: AppFonts.poppins14Black,
                          trailing: Hour(
                            hour: hour,
                            minute: minute,
                            amPm: amPm,
                          ),
                        );
                      }),
                    SizedBox(
                      height: getSizeWrtHeight(20),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Participants',
                        style: AppFonts.poppins16BlackBold,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            controller.exEvent.value!.eventMembers.length,
                        itemBuilder: (_, index) {
                          EventMemberModel temp =
                              controller.exEvent.value!.eventMembers[index];
                          return SListing(
                            hasBorder: false,
                            height: getSizeWrtHeight(87),
                            heading: temp.getFullName(),
                            onTap: () {
                              var event = (controller.exEvent.value!);
                              if ((controller.exEvent.value!.adminId) ==
                                      temp.userID ||
                                  user.userID != event.adminId) {
                                return;
                              }
                              DialogBox.showCustomDialog(
                                  child: EventMemberOptions(
                                model: temp,
                                eventID: controller.exEvent.value!.eventID!,
                              ));
                            },
                            sub:
                                '${temp.total} Member${temp.total! <= 1 ? 's' : ''}',
                            evntType: EventType.avatar,
                            leading: (controller.exEvent.value!.adminId) ==
                                    controller.exEvent.value!
                                        .eventMembers[index].userID
                                ? const Text(
                                    'Admin',
                                    style: TextStyle(color: Colors.orange),
                                  )
                                : null,
                          );
                        }),
                    SizedBox(
                      height: getSizeWrtHeight(20),
                    ),
                    if (controller.exEvent.value!.waitListedMembers.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Waitlisted Participants',
                          style: AppFonts.poppins16BlackBold,
                        ),
                      ),
                    if (controller.exEvent.value!.waitListedMembers.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller
                              .exEvent.value!.waitListedMembers.length,
                          itemBuilder: (_, index) {
                            EventMemberModel temp = controller
                                .exEvent.value!.waitListedMembers[index];
                            return SListing(
                              hasBorder: false,
                              height: getSizeWrtHeight(87),
                              heading: temp.getFullName(),
                              onTap: () {
                                var event = (controller.exEvent.value!);
                                if ((controller.exEvent.value!.adminId) ==
                                        temp.userID ||
                                    user.userID != event.adminId) {
                                  return;
                                }
                                showDialog(
                                    context: isChat ? Get.context! : context,
                                    builder: (_) {
                                      return EventMemberOptions(
                                        model: temp,
                                        eventID:
                                            controller.exEvent.value!.eventID!,
                                      );
                                    });
                              },
                              sub:
                                  '${temp.total} Member${temp.total! <= 1 ? 's' : ''}',
                              evntType: EventType.avatar,
                            );
                          }),
                    if (controller.exEvent.value!.waitListedMembers.isNotEmpty)
                      SizedBox(
                        height: getSizeWrtHeight(20),
                      ),
                    CustomButton(
                      height: getSizeWrtHeight(65),
                      onTap: () async {
                        var temp = controller.exEvent.value!;
                        if (!amIinEvent) {
                          CustomBottomSheet.show(
                              isChat ? Get.context! : context,
                              label: 'Please Confirm',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Are you sure you want to join ',
                                        style: AppFonts.poppins14Black),
                                    TextSpan(
                                        text: '${temp.title}',
                                        style: AppFonts.poppins14BlackBold)
                                  ])),
                                  SizedBox(
                                    height: getSize(10),
                                  ),
                                  CustomButton(
                                    height: getSizeWrtHeight(65),
                                    onTap: () async {
                                      Get.back();
                                      DialogBox.showCustomDialog(
                                          child: const SizeDialogue());
                                    },
                                    text: 'Confirm',
                                    widthh: getSize(200),
                                    textStyle: AppFonts.poppinsMedium16White,
                                    color: const Color(0xff164B9B),
                                    textColor: Colors.white,
                                    borderColor: const Color(0xff164B9B),
                                  ),
                                ],
                              ));
                        } else {
                          dynamic response;
                          if (user.userID != temp.adminId) {
                            if (isChat) {
                              Get.back();
                              Get.back();
                            }
                            response = await controller.leaveDeleteEvent(
                                temp.eventID!, 'leave');
                            if (response['status'] == 'success') {
                              Get.back();
                            }
                            CustomBottomSheet.show(
                                isChat ? Get.context! : context,
                                label: '${response['status']!}'
                                    .toString()
                                    .capitalizeFirst,
                                child: Text(
                                  response['message'],
                                  style: AppFonts.poppins14Black,
                                ));
                          } else {
                            DialogBox.showCustomDialog(
                                child: DeleteLeave(eventID: temp.eventID, isChat: true,));
                          }
                        }
                      },
                      text:
                          '${amIinEvent ? user.userID == controller.exEvent.value!.adminId ? 'Delete' : 'Leave' : 'Join'} Event',
                      widthh: width,
                      textStyle: AppFonts.poppinsMedium16White,
                      color: amIinEvent
                          ? const Color(0xffBB2C3B)
                          : const Color(0xff164B9B),
                      textColor: Colors.white,
                      borderColor: amIinEvent
                          ? const Color(0xffBB2C3B)
                          : const Color(0xff164B9B),
                    ),
                    SizedBox(
                      height: getSizeWrtHeight(20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
