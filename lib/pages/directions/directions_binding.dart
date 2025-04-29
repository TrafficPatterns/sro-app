import 'package:get/get.dart';
import 'package:sro/pages/directions/directions_controller.dart';

class DirectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectionsController>(() => DirectionsController());
  }
}
