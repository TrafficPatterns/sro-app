import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/pages/loading/loading_overlay.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/services/remote.dart';

class ChangePasswordController extends GetxController {
  var currentPasswordController = TextEditingController().obs;
  var newPasswordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
  var users = UserModel().obs;

  @override
  void onInit() async {
    user = await UserModel().getUserFromSharedPreferences;
    users.value = user;
    super.onInit();
  }

  Future<dynamic> changePassword() async {
    bool gotBack = false;
    showDialog(context: Get.context!, builder: (_) => const LoadingOverlay());
    try {
      final user = await UserModel().getUserFromSharedPreferences;
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['oldPass'] = currentPasswordController.value.text;
      params['newPass'] = newPasswordController.value.text;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res =
          await RemoteServices.getAPI("user/change_password.php", encodedData);
      var parsedRes = json.decode(res);
      Get.back();
      Get.back();
      gotBack = true;
      return parsedRes['message'];
    } catch (e) {
      log(e.toString());
      if (!gotBack) {
        Get.back();
      }
      return 'Something went wrong';
    }
  }
}
