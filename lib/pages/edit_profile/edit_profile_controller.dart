import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/pages/account/account_controller.dart';
import 'package:sro/pages/loading/loading_overlay.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/services/validation.dart';

import '../../services/remote.dart';

class EditProfileController extends GetxController {
  var users = UserModel().obs;
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var school = ''.obs;
  var city = ''.obs;
  var change = false.obs;

  var emailError = Rx<String?>(null);
  var namError = Rx<String?>(null);
  var lastError = Rx<String?>(null);
  var phoneError = Rx<String?>(null);

  void onChangeEmail(String s) {
    emailError.value = ValidateAddItem.validateEmail(s);
  }

  void onChangeName(String s) {
    namError.value = ValidateAddItem.validateName(s);
  }

  void onChangeLast(String s) {
    lastError.value = ValidateAddItem.validateName(s);
  }

  void onChangephone(String s) {
    phoneError.value = ValidateAddItem.validateMobileWithFormatting(s);
  }

  @override
  void onInit() async {
    user = await UserModel().getUserFromSharedPreferences;
    users.value = user;
    firstNameController.value.text = users.value.firstName!;
    lastNameController.value.text = users.value.lastName!;
    emailController.value.text = users.value.email!;
    phoneController.value.text = users.value.phoneNumber!;
    super.onInit();
  }

  bool get validate {
    return emailError.value == null &&
        namError.value == null &&
        lastError.value == null &&
        phoneError.value == null;
  }

  Future<dynamic> editProfile() async {
    if (!change.value) {
      showToas("You haven't changed anything yet");
    } else {
      try {
        showDialog(
            context: Get.context!, builder: (_) => const LoadingOverlay());
        var params = <String, dynamic>{};
        params['token'] = user.token;
        params['firstName'] = firstNameController.value.text;
        params['lastName'] = lastNameController.value.text;
        params['email'] = emailController.value.text;
        params['phoneNumber'] = phoneController.value.text;
        if (user.isStudent) {
          // if (school.value.isEmpty) {
          var sc = Get.put(SchoolController());
          String cityID;
          String schoolID;
          if (school.value.isNotEmpty) {
            var s = sc.schoolSearch.value.firstWhereOrNull((element) {
                  if (element.name == school.value) return true;
                  return false;
                }) ??
                sc.schools.firstWhereOrNull((element) {
                  if (element.name == school.value) return true;
                  return false;
                }) ??
                sc.allSchools.firstWhereOrNull((element) {
                  if (element.name == school.value) return true;
                  return false;
                })!;
            schoolID = s.id!;
            cityID = s.cityId!;
          } else {
            schoolID = sc.schools.first.id!;
            cityID = sc.schools.first.id!;
          }
          params['schoolID'] = schoolID;
          params['cityID'] = cityID;
        }
        var data = json.encode(params);
        var encodedData = Uri.encodeComponent(data);
        var res =
            await RemoteServices.getAPI("user/edit_profile.php", encodedData);
        var parsedRes = json.decode(res);
        if (parsedRes['status'] == 'success') {
          await UserModel().setUserFromEdit(map: params);
          await Get.put(AccountController()).updateName();
        }
        showToas(parsedRes['message'].toString());
      } catch (e) {
        log(e.toString());
      }
      Get.back();
    }
  }
}
