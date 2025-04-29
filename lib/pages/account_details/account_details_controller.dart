import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sro/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/services/remote.dart';

class AccountDetailsController extends GetxController {
  var applyController = TextEditingController().obs;
  var generatedCode = Rx<String?>(null);
  var readOnly = true.obs;
  var coParent = Rx<String?>(null);
  var users = UserModel().obs;
  var loading = true.obs;

  @override
  void onInit() async {
    UserModel().getUserFromSharedPreferences.then((value) {
      user = value;
      users.value = user;
    });
    getCoParentName();
    getOldCode();
    super.onInit();
  }

  Future<dynamic> generateCode({bool copy = true}) async {
    final user = await UserModel().getUserFromSharedPreferences;
    var params = <String, dynamic>{};
    params['token'] = user.token;
    var data = json.encode(params);
    var encodedData = Uri.encodeComponent(data);
    var res =
        await RemoteServices.getAPI("coparent/generate_code.php", encodedData);
    generatedCode.value = res.toString().replaceAll('"', '');
    if (copy) {
      copyCode();
    }
  }

  void copyCode() {
    if (generatedCode.value != null && generatedCode.value!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: generatedCode.value!));
      showToas('Code Copied to Clipboard');
    } else {
      showToas('Please try again');
    }
  }

  Future<dynamic> applyCode() async {
    try {
      if (applyController.value.text == generatedCode.value) {
        showToas('You cannot use your own code');
        return;
      }
      final user = await UserModel().getUserFromSharedPreferences;
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['code'] = applyController.value.text;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res =
          await RemoteServices.getAPI("coparent/apply_code.php", encodedData);
      var parsedRes = json.decode(res);
      log(parsedRes.toString());
      if (parsedRes['status'] == 'success') {
        applyController.value.clear();
        getCoParentName();
        var sc = Get.put(SchoolController());
        sc.getschools();
        sc.update();
      }
      return parsedRes['message'];
    } catch (e) {
      log('error from apply code ${e.toString()}');
      return ('Something went wrong, please try again later');
    }
  }

  Future<dynamic> getCoParentName() async {
    try {
      final user = await UserModel().getUserFromSharedPreferences;
      var params = <String, dynamic>{};
      params['token'] = user.token;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI(
          "user/get_coparent_name.php", encodedData);
      var parsedRes = json.decode(res);
      log(res.toString());
      if (parsedRes['status'] == 'success' && parsedRes['message'] != null) {
        coParent.value = parsedRes['message'];
      } else {
        coParent.value = null;
      }
      loading.value = false;
    } catch (e) {
      log('error from get coparent name ${e.toString()}');
    }
  }

  Future<dynamic> deleteCoParent() async {
    try {
      final user = await UserModel().getUserFromSharedPreferences;
      var params = <String, dynamic>{};
      params['token'] = user.token;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res =
          await RemoteServices.getAPI("user/remove_coparent.php", encodedData);
      var parsedRes = json.decode(res);
      if (parsedRes['message'] != null) {
        showToas(parsedRes['message'].toString());
      }
      getCoParentName();
    } catch (e) {
      log('error from delete name ${e.toString()}');
      showToas('Something went wrong, please try again later');
    }
  }

  Future<dynamic> getOldCode() async {
    final user = await UserModel().getUserFromSharedPreferences;
    var params = <String, dynamic>{};
    params['token'] = user.token;
    var data = json.encode(params);
    var encodedData = Uri.encodeComponent(data);
    var res =
        await RemoteServices.getAPI("user/get_parent_code.php", encodedData);
    var parsedRes = json.decode(res);
    if (parsedRes['status'] == 'success') {
      generatedCode.value = parsedRes['message'].toString();
    }
  }
}
