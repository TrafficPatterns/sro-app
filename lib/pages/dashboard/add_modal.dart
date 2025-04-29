import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sro/pages/events/events_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/globals/global_user_variables.dart';

import '../../global_widgets/bottom_sheet.dart';
import '../../global_widgets/scaffold_back.dart';
import '../../global_widgets/special_listing_widget.dart';
import '../../services/global_functions.dart';
import '../school/school_controller.dart';

void showAddEvents(BuildContext context) {
  EventsController controller = Get.put(EventsController());
  var sController = Get.put(SchoolController());
  CustomBottomSheet.show(
    context,
    child: ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SListing(
            height: getSizeWrtHeight(90),
            evntType: EventType.BT,
            heading: 'Bike Train',
            onTap: () async {
              Get.back();
              controller.icon.value =
                  await SchoolController.getIcon('BT', scale: 0.5);
              if (user.isStudent) {
                controller.location.value = sController.schools.first.location!;
                controller.selectedSchoolName.value =
                    sController.schools.first.name!;
              }
              controller.eventType.value = EventType.BT;
              controller.parentName.value.text = user.getFullName();
              controller.clickedOnCreate = DateTime.now();
              Get.toNamed(AppRoutes.addEvents);
            },
          ),
          SListing(
            height: getSizeWrtHeight(90),
            evntType: EventType.WSB,
            heading: 'Walking School Bus',
            onTap: () async {
              Get.back();
              controller.icon.value =
                  await SchoolController.getIcon('WSB', scale: 0.5);
              if (user.isStudent) {
                controller.location.value = sController.schools.first.location!;
                controller.selectedSchoolName.value =
                    sController.schools.first.name!;
              }
              controller.eventType.value = EventType.WSB;
              controller.parentName.value.text = user.getFullName();
              controller.clickedOnCreate = DateTime.now();

              Get.toNamed(AppRoutes.addEvents);
            },
          ),
          if (!user.isStudent)
            SListing(
              height: getSizeWrtHeight(90),
              evntType: EventType.IC,
              heading: 'Invite Carpool',
              onTap: () async {
                Get.back();
                controller.icon.value =
                    await SchoolController.getIcon('IC', scale: 0.5);
                controller.parentName.value.text = user.getFullName();
                controller.eventType.value = EventType.IC;
                controller.clickedOnCreate = DateTime.now();
                Get.toNamed(AppRoutes.addEvents);
              },
            ),
        ],
      ),
    ),
    label: 'Choose Event',
  );
}
