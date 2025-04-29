import 'package:get/get.dart';
import 'package:sro/pages/notifications_settings/notifications_settings_controller.dart';

class NotificationsSettingsdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsSettingsdController>(() => NotificationsSettingsdController());
  }
}
