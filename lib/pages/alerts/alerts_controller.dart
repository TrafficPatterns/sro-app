import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sro/models/alert_model.dart';
import 'package:sro/models/user_model.dart';

import '../../services/globals/global_user_variables.dart';
import '../../services/remote.dart';

class AlertsController extends GetxController {
  var alertsList = <AlertModel>[].obs;
  var refreshController = RefreshController();

  @override
  void onInit() async {
    user = await UserModel().getUserFromSharedPreferences;
    await getEvents();
    sortEvents();
    super.onInit();
  }

  Future<void> onRefresh() async {
    await getEvents();
    sortEvents();
    refreshController.refreshCompleted();
  }

  Future<void> getEvents() async {
    try {
      var params = <String, dynamic>{};
      params['token'] = user.token;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI(
          "user/get_notifications.php", encodedData);
      var parsedRes = json.decode(res);
      alertsList.clear();
      for (var alert in parsedRes) {
        alertsList.add(AlertModel.getModelFromMap(alert));
      }
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> readAlert(int index) async {
    try {
      var a = alertsList[index];
      if (a.isRead!) {
        return;
      }
      alertsList[index].isRead = true;
      update();
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['notificationID'] = a.notificationID;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      await RemoteServices.getAPI("user/read_notification.php", encodedData);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> unreadAlert(int index) async {
    try {
      var a = alertsList[index];
      if (!a.isRead!) {
        return;
      }
      alertsList[index].isRead = false;
      update();
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['notificationID'] = a.notificationID;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      await RemoteServices.getAPI("user/unread_notification.php", encodedData);
    } catch (e) {
      log(e.toString());
    }
  }

  bool allRead() {
    for (var x in alertsList) {
      if (!(x.isRead ?? false)) {
        log('h1');
        return false;
      }
    }
    log('h2');
    return true;
  }

  Future<void> deleteAlert(int index) async {
    try {
      var a = alertsList[index];
      alertsList.removeAt(index);
      update();
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['notificationID'] = a.notificationID;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      await RemoteServices.getAPI("user/delete_notification.php", encodedData);
    } catch (e) {
      log(e.toString());
    }
  }

  void sortEvents() {
    alertsList.sort(
      (a, b) {
        if (a.date!.difference(b.date!).isNegative) {
          return 1;
        }
        return -1;
      },
    );
  }

  Future<void> readAll() async {
    try {
      var params = <String, dynamic>{};
      for (int i = 0; i < alertsList.length; i++) {
        alertsList[i].isRead = true;
      }
      update();
      params['token'] = user.token;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      await RemoteServices.getAPI(
          "user/read_all_notifications.php", encodedData);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteAll() async {
    try {
      var params = <String, dynamic>{};
      alertsList.clear();
      update();
      params['token'] = user.token;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      await RemoteServices.getAPI(
          "user/clear_all_notifications.php", encodedData);
    } catch (e) {
      log(e.toString());
    }
  }

  void onSelected(String choice) {
    if (alertsList.isEmpty) {
      return;
    }
    if (choice == 'Read All') {
      readAll();
    } else {
      deleteAll();
    }
  }
}
