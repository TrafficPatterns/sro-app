import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/custom_drop_down.dart';
import 'package:sro/global_widgets/hour.dart';
import 'package:sro/global_widgets/listing.dart';
import 'package:sro/global_widgets/map.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/global_widgets/special_listing_widget.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/globals.dart';
import 'package:sro/models/hour.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import '../../global_widgets/bottom_sheet.dart';
import '../../services/globals/global_user_variables.dart';
import '../events/events_controller.dart';

class CreateEvent extends GetView<EventsController> {
  final bool? fromEdit;
  const CreateEvent({Key? key, this.fromEdit = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var schoolController = Get.put(SchoolController());
    EventType eventType = controller.eventType.value!;
    var days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];
    return WillPopScope(
      onWillPop: () async {
        var now = DateTime.now();
        var dif = now.difference(controller.clickedOnCreate);
        if (dif.inMilliseconds <= 1200) {
          await Future.delayed(
              Duration(milliseconds: 1200 - dif.inMilliseconds));
        }
        await controller.clearEventCreationFields();
        return true;
      },
      child: GestureDetector(
        onTap: unfocus,
        child: HeaderScaffold(
          label: '${controller.edit.value ? 'Edit' : 'Add'} Event',
          leading: SizedBox(
              child: BackButton(
            color: Colors.black,
            onPressed: () async {
              await controller.clearEventCreationFields();
              Get.back();
            },
          )),
          trailing: BackButton(
            color: Colors.transparent,
            onPressed: () {},
          ),
          centerTitle: true,
          headerStyle: AppFonts.poppins16BlackBold,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create ${getNameofEvent(eventType)} event',
                        style: AppFonts.poppins16BlackBold,
                      )),
                  Builder(builder: (_) {
                    Completer<GoogleMapController> completer = Completer();
                    return Column(
                      children: [
                        if (!user.isStudent)
                          Column(
                            children: [
                              SizedBox(
                                height: getSizeWrtHeight(20),
                              ),
                              CustomDropDown(
                                height: getSizeWrtHeight(60),
                                width: getSize(345),
                                selected: controller.selectedSchoolName.value,
                                onChanged: (value) async {
                                  controller.selectedSchoolName.value = value;
                                  var school = schoolController.schools
                                      .firstWhereOrNull((element) {
                                    if (element.name == value) {
                                      return true;
                                    }
                                    return false;
                                  });
                                  if (school == null) return;
                                  controller.location.value = school.location;
                                  var c = await completer.future;
                                  c.animateCamera(
                                      CameraUpdate.newLatLng(school.location!));
                                  controller.update();
                                },
                                label: 'Choose School',
                                values: SchoolController.getSchoolSearch(
                                        schoolController.schools)
                                    .map((element) => DropdownMenuItem(
                                          value: element.name!,
                                          child: Text(
                                            element.name!,
                                            style: AppFonts.poppins14Black,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 22.0, bottom: 10.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Meetup Location *',
                                style: AppFonts.poppins16Black,
                              )),
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: SizedBox(
                            height: getSizeWrtHeight(170),
                            width: getSize(350),
                            child: Obx(() {
                              return MapView(
                                controller: completer,
                                markerAtInitial: true,
                                initialMarker: controller.icon.value,
                                initialPosition:
                                    controller.location.value != null
                                        ? CameraPosition(
                                            bearing: 192.8334901395799,
                                            target: controller.location.value!,
                                            zoom: 19.151926040649414)
                                        : null,
                                hasZoom: false,
                                onTap: (_) async {
                                  if (!user.isStudent &&
                                      controller.selectedSchoolName.value ==
                                          null) {
                                    showToas('Please choose a school first');
                                    return;
                                  }
                                  await Get.toNamed(AppRoutes.mapChooser,
                                      arguments: controller.location.value ??
                                          const LatLng(37.43296265331129,
                                              -122.08832357078792));
                                  (await completer.future).animateCamera(
                                      CameraUpdate.newLatLng(
                                          controller.location.value!));
                                },
                                liteMode: true,
                                hasCompass: false,
                                lockGestures: true,
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: getSizeWrtHeight(25),
                  ),
                  if (eventType == EventType.IC)
                    Obx(() {
                      return Listing(
                        color: Colors.white,
                        heigth: getSizeWrtHeight(82),
                        title: 'Round Trip',
                        titleStyle: AppFonts.poppins16Black,
                        onTraillingTap: null,
                        trailing: FlutterSwitch(
                          value: controller.roundTrip.value,
                          height: getSizeWrtHeight(30),
                          width: getSize(50),
                          onToggle: controller.onRoundTripChanged,
                          activeColor: const Color(0xff65c466),
                        ),
                      );
                    }),
                  if (eventType != EventType.IC)
                    SizedBox(
                      height: getSizeWrtHeight(25),
                    ),
                  CustomTextField(
                    label:
                        '${user.role == 'student' ? 'Student' : 'Parent'} Full Name',
                    required: true,
                    textController: controller.parentName.value,
                    onSubmit: (_) => controller.eventTitleFocus.requestFocus(),
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(20),
                  ),
                  CustomTextField(
                      focusNode: controller.eventTitleFocus,
                      label: 'Event Title',
                      maxLength: 60,
                      required: true,
                      textController: controller.eventTitle.value,
                      onSubmit: (_) => {
                            eventType == EventType.IC
                                ? controller.eventSizeFocus.requestFocus()
                                : controller.numberOfStudentsFocus
                                    .requestFocus()
                          }),
                  SizedBox(
                    height: getSizeWrtHeight(20),
                  ),
                  if (eventType == EventType.IC)
                    CustomTextField(
                      focusNode: controller.eventSizeFocus,
                      label: 'Event Size',
                      required: true,
                      textInputType: TextInputType.number,
                      textController: controller.eventSize.value,
                      onSubmit: (_) =>
                          controller.eventDescriptionFocus.requestFocus(),
                    ),
                  if (eventType != EventType.IC)
                    CustomTextField(
                      focusNode: controller.numberOfStudentsFocus,
                      label: 'Number Of Students',
                      required: true,
                      textInputType: TextInputType.number,
                      textController: controller.numberOfStudents.value,
                      onSubmit: (_) =>
                          controller.numberOfAdultsFocus.requestFocus(),
                    ),
                  if (eventType != EventType.IC)
                    SizedBox(
                      height: getSizeWrtHeight(20),
                    ),
                  if (eventType != EventType.IC)
                    CustomTextField(
                      focusNode: controller.numberOfAdultsFocus,
                      label: 'Number Of Adults',
                      required: true,
                      textController: controller.numberOfAdults.value,
                      textInputType: TextInputType.number,
                      onSubmit: (_) =>
                          controller.eventDescriptionFocus.requestFocus(),
                    ),
                  SizedBox(
                    height: getSizeWrtHeight(20),
                  ),
                  CustomTextField(
                      focusNode: controller.eventDescriptionFocus,
                      label: 'Event Description',
                      textController: controller.eventDescription.value),
                  SizedBox(
                    height: getSizeWrtHeight(35),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Custom Schedule *',
                        style: AppFonts.poppins16Black,
                      ),
                      Obx(() {
                        return FlutterSwitch(
                          value: controller.hasSchedule.value,
                          height: getSizeWrtHeight(30),
                          width: getSize(50),
                          onToggle: (value) =>
                              controller.hasSchedule.value = value,
                          activeColor: const Color(0xff65c466),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: getSizeWrtHeight(15),
                  ),
                  Obx(() {
                    return AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: controller.hasSchedule.value
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (_, index) {
                                return Obx(() {
                                  int? hour, minute;
                                  String? amPm;
                                  if (controller.schedule[index] != null) {
                                    hour = controller.schedule[index]!.hour;
                                    minute = controller.schedule[index]!.minute;
                                    amPm = controller.schedule[index]!.amPm;
                                  }
                                  return Listing(
                                    onTap: () {
                                      controller.updateCheck(
                                          index, !controller.check[index]);
                                    },
                                    color: Colors.white,
                                    heigth: getSizeWrtHeight(82),
                                    title: days[index],
                                    titleStyle: AppFonts.poppins14Black,
                                    leading: Checkbox(
                                        onChanged: (value) {
                                          controller.updateCheck(
                                              index, value ?? false);
                                        },
                                        value: controller.check[index],
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3))),
                                        activeColor: const Color(0xff164B9B)),
                                    onTraillingTap: () {
                                      if (!controller.check[index]) {
                                        controller.check[index] = true;
                                      }
                                      Navigator.of(context).push(
                                        showPicker(
                                            context: context,
                                            value: Time(
                                              hour: TimeOfDay.now().hour,
                                              minute: TimeOfDay.now().minute,
                                            ),
                                            onChange: (TimeOfDay value) {
                                              var time = HourFormatter(
                                                hour: value.hourOfPeriod,
                                                minute: value.minute,
                                                amPm: value.period.name,
                                              );
                                              controller.schedule[index] = time;
                                            },
                                            accentColor:
                                                const Color(0xff164B9B)),
                                      );
                                    },
                                    trailing: GestureDetector(
                                        child: Hour(
                                      hour: hour,
                                      minute: minute,
                                      amPm: amPm,
                                    )),
                                  );
                                });
                              })
                          : Obx(() {
                              int? hour, minute;
                              String? amPm;
                              hour = controller.everydayTime.value.hour;
                              minute = controller.everydayTime.value.minute;
                              amPm = controller.everydayTime.value.amPm;
                              return Listing(
                                color: Colors.white,
                                heigth: getSizeWrtHeight(82),
                                title: 'All Days',
                                titleStyle: AppFonts.poppins14Black,
                                onTraillingTap: () {
                                  Navigator.of(context).push(
                                    showPicker(
                                        context: context,
value: Time(
                                              hour: TimeOfDay.now().hour,
                                              minute: TimeOfDay.now().minute,
                                            ),
                                        onChange: (TimeOfDay value) {
                                          var time = HourFormatter(
                                            hour: value.hourOfPeriod,
                                            minute: value.minute,
                                            amPm: value.period.name,
                                          );
                                          controller.everydayTime.value = time;
                                        },
                                        accentColor: const Color(0xff164B9B)),
                                  );
                                },
                                trailing: GestureDetector(
                                    child: Hour(
                                  hour: hour,
                                  minute: minute,
                                  amPm: amPm,
                                )),
                              );
                            }),
                    );
                  }),
                  SizedBox(
                    height: getSizeWrtHeight(15),
                  ),
                  CustomButton(
                    height: getSizeWrtHeight(65),
                    widthh: width - getSize(30),
                    onTap: () async {
                      bool extras = true;
                      if (eventType == EventType.IC) {
                        if (controller.eventSize.value.text.isEmpty) {
                          extras = false;
                        }
                      } else {
                        if (controller.numberOfAdults.value.text.isEmpty ||
                            controller.numberOfStudents.value.text.isEmpty) {
                          extras = false;
                        }
                      }
                      if (controller.validateFields && extras) {
                        var response = await controller.addEvent(eventType);
                        Get.back();
                        CustomBottomSheet.show(
                          Get.context!,
                          child: Text(
                            '${response['message']}',
                            style: AppFonts.poppins14Black,
                          ),
                          label: '${response['status']}',
                        );
                        controller.clearEventCreationFields();
                      } else {
                        showToas('All Fields are mandatory');
                      }
                    },
                    text: '${controller.edit.value ? 'Edit' : 'Add'} Event',
                    textStyle: AppFonts.poppinsMedium16White,
                    color: const Color(0xff164B9B),
                    textColor: Colors.white,
                    borderColor: const Color(0xff164B9B),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
