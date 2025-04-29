import 'package:get/get.dart';
import 'package:sro/pages/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginCOntroller>(() => LoginCOntroller());
  }
}
