import 'package:get/get.dart';
import '../events/events_controller.dart';

class EventChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventsController>(() => EventsController());
  }
}
