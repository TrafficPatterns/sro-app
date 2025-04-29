import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sro/global_widgets/notification_listing.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/pages/alerts/alerts_controller.dart';

import '../../themes/app_fonts.dart';

class AlertsPage extends GetView<AlertsController> {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlertsController>(
        builder: (controller) => HeaderScaffold(
              label: 'Notifications',
              trailing: controller.alertsList.isEmpty
                  ? null
                  : PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: controller.onSelected,
                      itemBuilder: (_) {
                        return (!controller.allRead()
                                ? {'Read All', 'Delete All'}
                                : {'Delete All'})
                            .map((e) => PopupMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: AppFonts.poppins14Black,
                                  ),
                                ))
                            .toList();
                      },
                    ),
              child: Expanded(
                child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SmartRefresher(
                      enablePullDown: true,
                      header: const WaterDropHeader(),
                      controller: controller.refreshController,
                      onRefresh: controller.onRefresh,
                      child: controller.alertsList.isEmpty
                          ? Center(
                              child: Text(
                                'You do not have any notifcations',
                                style: AppFonts.poppins14BlackBold,
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              itemCount: controller.alertsList.length,
                              itemBuilder: (_, int i) {
                                var a = controller.alertsList[i];
                                return NotificationListing(
                                  onDismiss: () => {controller.deleteAlert(i)},
                                  read: () => {controller.readAlert(i)},
                                  unread: () => {controller.unreadAlert(i)},
                                  files: controller.alertsList[i].files,
                                  title: a.subject!.capitalizeFirst ?? '',
                                  subtitle: a.message,
                                  date: a.date,
                                  active: a.isRead ?? true,
                                  onTap: () => {controller.readAlert(i)},
                                );
                              }),
                    )),
              ),
            ));
  }
}
