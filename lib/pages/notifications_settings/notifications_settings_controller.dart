import 'dart:convert';
import 'package:get/get.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/services/remote.dart';

class NotificationsSettingsdController extends GetxController {
  var map = {}.obs;

  @override
  void onInit() async {
    final user = await UserModel().getUserFromSharedPreferences;
    var params = <String, dynamic>{};
    params['token'] = user.token;
    var data = json.encode(params);
    var encodedData = Uri.encodeComponent(data);
    var res =
        await RemoteServices.getAPI("user/get_noti_settings.php", encodedData);
    var parsedRes = json.decode(res);
    map.value = parsedRes;
    super.onInit();
  }

  updateNotification() async {
    final user = await UserModel().getUserFromSharedPreferences;
    map['token'] = user.token;
    var data = json.encode(map);
    var encodedData = Uri.encodeComponent(data);
    var res = await RemoteServices.getAPI(
        "user/update_noti_settings.php", encodedData);
    var parsedRes = json.decode(res);
    return parsedRes['message'];
  }
}
