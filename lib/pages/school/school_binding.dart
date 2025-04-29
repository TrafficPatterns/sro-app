import 'package:get/get.dart';
import 'package:sro/pages/school/school_controller.dart';

class SchoolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchoolController>(() => SchoolController());
  }
}