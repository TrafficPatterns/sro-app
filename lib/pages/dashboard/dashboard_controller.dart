import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/pages/account/account_controller.dart';
import 'package:sro/pages/alerts/alerts_controller.dart';
import 'package:sro/pages/events/events_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/services/local_notification.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;
  late SharedPreferences sp;

  void changeTabIndex(int index) {
    unfocus();
    tabIndex = index;
    update();
  }

  @override
  void onInit() async {
    user = await UserModel().getUserFromSharedPreferences;
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.data['eventID'] != null) {
        var ec = Get.put(EventsController());
        if (message.data['eventID'] != ec.active.value) {
          LocalNotificationService.display(message);
        }
      } else {
        LocalNotificationService.display(message);
        log(message.data.toString());
        var aC = Get.put(AlertsController());
        aC.getEvents().then((value) {
          aC.sortEvents();
          aC.update();
        });
      }
    });
    SharedPreferences.getInstance().then((value) async {
      sp = value;
      if (sp.getBool(LOCATION_KEY) ?? false) {
        await checkLocationTracking(sp);
      }
      if (sp.getBool(LOCATION_KEY) ?? false) {
        startLocationTracking();
        scheduleLocationUpload();
      }
    });
    super.onInit();
  }

  static Future<bool> checkLocationTracking(SharedPreferences sp) async {
    bool serviceEnabled;
    LocationPermission permission;
    AccountController ac = Get.put(AccountController());
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      sp.setBool(LOCATION_KEY, false);
      ac.isLocTrackingActive.value = false;
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      sp.setBool(LOCATION_KEY, false);
      ac.isLocTrackingActive.value = false;
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      sp.setBool(LOCATION_KEY, false);
      ac.isLocTrackingActive.value = false;
      return false;
    }
    return true;
  }
}
