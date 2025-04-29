import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/global_widgets/special_listing_widget.dart';
import 'package:sro/models/event_model.dart';
import 'package:sro/pages/events/events_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class EventsPage extends GetView<EventsController> {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      label: 'My Events',
      child: Obx(
        () => Expanded(
            child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SmartRefresher(
                  enablePullDown: true,
                  header: const WaterDropHeader(),
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  child: controller.eventsList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                              Text(
                                'You are not a member of any events',
                                style: AppFonts.poppins14BlackBold,
                              ),
                            ])
                      : ListView.builder(
                          itemCount: controller.eventsList.length,
                          itemBuilder: (_, int i) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Obx(() {
                                if (i >= controller.eventsList.length) {
                                  return const SizedBox();
                                }
                                Event e = controller.eventsList[i];
                                return SListing(
                                  height: getSizeWrtHeight(98),
                                  hasBorder: false,
                                  evntType: e.type,
                                  heading: e.title,
                                  notification: e.activeNotifications,
                                  sub: (e.messages == null ||
                                          e.messages!.isEmpty)
                                      ? null
                                      : e.messages!.first.senderName,
                                  onTap: () {
                                    controller.currentMessageList.value = i;
                                    controller.getMessagesForEvent();
                                    controller
                                        .eventsList[i].activeNotifications = 0;
                                    controller.active.value =
                                        controller.eventsList[i].eventID!;
                                    Get.toNamed(AppRoutes.eventChat);
                                  },
                                );
                              }),
                            );
                          }),
                ))),
      ),
    );
  }
}
