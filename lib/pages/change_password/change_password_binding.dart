import 'package:get/get.dart';
import 'package:sro/pages/change_password/change_password_controller.dart';

class ChangePassworddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}