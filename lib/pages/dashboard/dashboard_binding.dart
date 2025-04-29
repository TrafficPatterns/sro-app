import 'package:get/get.dart';
import 'package:sro/pages/account/account_controller.dart';
import 'package:sro/pages/alerts/alerts_controller.dart';
import 'package:sro/pages/directions/directions_controller.dart';
import 'package:sro/pages/school/school_controller.dart';

import '../events/events_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(() => AccountController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<SchoolController>(() => SchoolController());
    Get.lazyPut<EventsController>(() => EventsController());
    Get.lazyPut<AlertsController>(() => AlertsController());
    Get.lazyPut<DirectionsController>(() => DirectionsController());
  }
}
