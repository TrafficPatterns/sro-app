import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/dialogs/ask_for_location.dart';
import 'package:sro/dialogs/confirm_disable_location.dart';
import 'package:sro/global_widgets/dialog_box.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:workmanager/workmanager.dart';

import '../../services/globals/global_user_variables.dart';
import '../../services/remote.dart';

class AccountController extends GetxController {
  var isLocTrackingActive = false.obs;
  late SharedPreferences sp;
  var name = ''.obs;

  void toggleLocation() {
    if (isLocTrackingActive.value) {
      DialogBox.showCustomDialog(child: const ConfirmDisable());
    } else {
      DialogBox.showCustomDialog(child: const AskLocation());
    }
    sp.setBool(LOCATION_KEY, isLocTrackingActive.value);
  }

  @override
  void onInit() async {
    sp = await SharedPreferences.getInstance();
    isLocTrackingActive.value = sp.getBool(LOCATION_KEY) ?? false;
    user = await UserModel().getUserFromSharedPreferences;
    name.value = user.getFullName().capitalizeFirst!;
    super.onInit();
  }

  Future<void> updateName() async {
    user = await UserModel().getUserFromSharedPreferences;
    name.value = user.getFullName().capitalizeFirst!;
    update();
  }

  static Future<void> removeDevice() async {
    try {
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['deviceToken'] = await FirebaseMessaging.instance.getToken();
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI(
          "user/remove_device.php", encodedData,
          ignoreAuth: true);
      log(res.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> logout() async {
    Get.offAllNamed(AppRoutes.welcome);
    Workmanager().cancelAll();
    removeDevice();
    final prefs = await SharedPreferences.getInstance();
    if (stream != null) {
      stream!.cancel();
      stream = null;
    }
    prefs.clear();
  }

  static Future<void> deleteAccount() async {
    try {
      var params = <String, dynamic>{};
      params['token'] = user.token;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI("user/delete_user.php", encodedData,
          ignoreAuth: true);
      var parsedRes = json.decode(res);
      if (parsedRes['status'] == 'success') {
        showToas('Account Deleted Sucessfuly');
        logout();
      } else {
        showToas('Something Went Wrong!');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
