import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/pages/account/account_page.dart';
import 'package:sro/pages/alerts/alerts_page.dart';
import 'package:sro/pages/dashboard/add_modal.dart';
import 'package:sro/pages/events/events_page.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/pages/school/search_school.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SchoolController? schoolController;
    if (Get.isRegistered<SchoolController>()) {
      schoolController = Get.find<SchoolController>();
    }
    return WillPopScope(
      onWillPop: () async {
        log('called');
        return true;
      },
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: controller.tabIndex,
                children: const [
                  SearchSchool(),
                  EventsPage(),
                  SizedBox(),
                  AlertsPage(),
                  AccountPage(),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.black,
              selectedItemColor: const Color(0xff164B9B),
              onTap: (int index) {
                if (index == 2) {
                  if (schoolController != null &&
                      schoolController.schools.isEmpty) {
                    Get.snackbar(
                      'No schools',
                      'You must add a school before you can add an event',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.white,
                      colorText: Colors.black,
                      duration: const Duration(seconds: 5),
                      margin: const EdgeInsets.all(10),
                      borderRadius: 10,
                      isDismissible: true,
                      dismissDirection: DismissDirection.down,
                      forwardAnimationCurve: Curves.easeOutBack,
                    );
                    return;
                  }
                  showAddEvents(context);
                } else {
                  controller.changeTabIndex(index);
                }
              },
              currentIndex: controller.tabIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              enableFeedback: true,
              items: [
                _bottomNavigationBarItem(
                  image: AppImages.maps,
                  label: 'Maps',
                  active: AppImages.maps,
                ),
                _bottomNavigationBarItem(
                  image: AppImages.events,
                  label: 'Events',
                  active: AppImages.events,
                ),
                _bottomNavigationBarItem(
                  image: AppImages.add,
                  label: 'Events',
                ),
                _bottomNavigationBarItem(
                  image: AppImages.notifications,
                  label: 'Notifications',
                  active: AppImages.notifications,
                ),
                _bottomNavigationBarItem(
                  image: AppImages.settings,
                  label: 'Settings',
                  active: AppImages.settings,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _bottomNavigationBarItem({
    @required AppImages? image,
    String? label,
    AppImages? active,
  }) {
    return BottomNavigationBarItem(
      icon: GetImages(image: image),
      label: label,
      activeIcon: active != null
          ? GetImages(
              image: active,
              hasColor: true,
              color: const Color(0xff164B9B),
            )
          : null,
    );
  }
}
