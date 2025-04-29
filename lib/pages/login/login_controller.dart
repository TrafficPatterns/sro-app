import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/pages/loading/loading_overlay.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/services/validation.dart';

import '../../route/app_routes.dart';
import '../../services/remote.dart';

class LoginCOntroller extends GetxController {
  final String title = 'Login Page';
  var passwordController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var emailForgotController = TextEditingController().obs;

  var emailFocus = FocusNode().obs;
  var resetPhrases = [
    'Enter Your Email',
    'Enter The Code We Sent You',
    'Enter The New Email'
  ];
  var resetLevel = 1.obs;
  var emailFocusForgit = FocusNode().obs;
  var emailForgotFocus = FocusNode().obs;
  var passwordFocus = FocusNode().obs;
  var showPass = true.obs;
  var hasWrittenPass = false.obs;
  var hasWrittenEmail = false.obs;
  var errorEmail = ''.obs;
  var emailForgotError = Rx<String?>(null);
  var errorPass = Rx<String?>(null);
  String? email;
  String? emailForgot;
  String? code;
  String? passwordForgot;
  String? password;

  Future<void> login(String email, String password,
      {bool fromRegister = false}) async {
    if (!fromRegister) {
      showDialog(
          context: Get.context!,
          builder: (_) {
            return const LoadingOverlay();
          });
    }
    var deviceToken = await FirebaseMessaging.instance.getToken();
    log(deviceToken.toString());
    var params = <String, dynamic>{};
    params['email'] = email;
    params['password'] = password;
    params['deviceToken'] = deviceToken;
    params['isAndroid'] = Platform.isAndroid ? "1" : "0";
    var data = json.encode(params);
    var encodedData = Uri.encodeComponent(data);
    try {
      var response = await RemoteServices.getAPI("user/login.php", encodedData);
      await setUserModelFromResponse(response);
    } catch (e) {
      log(e.toString());
    }
    if (!fromRegister) {
      Get.back();
    }
  }

  setUserModelFromResponse(dynamic res) async {
    Map response = json.decode(res);
    if (response['status'] == 'error') {
      if (response['message'] is String) {
        showToas(response['message']);
        if ((response['message'] as String).toLowerCase().contains('user')) {
          errorEmail.value = response['message'];
          emailFocus.value.requestFocus();
        } else if ((response['message'] as String)
            .toLowerCase()
            .contains('password')) {
          errorPass.value = response['message'];
          passwordFocus.value.requestFocus();
        }
      }
    } else {
      if (response['token'] != null && response['token'] != '') {
        await user.setUser(map: response);
        user = await UserModel().getUserFromSharedPreferences;
        Get.offAllNamed(AppRoutes.dashboard);
        emailController.value.clear();
        passwordController.value.clear();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (user.isStudent) {
            showD = true;
          }
        });
      }
    }
  }

  bool get checkValidationOfFields {
    if (email == null ||
        errorEmail.value.isNotEmpty ||
        email!.isEmpty ||
        password == null ||
        errorPass.value != null ||
        password!.isEmpty) {
      if (email == null || email!.isEmpty || errorEmail.value.isNotEmpty) {
        emailFocus.value.requestFocus();
      } else {
        passwordFocus.value.requestFocus();
      }
      return false;
    }
    return true;
  }

  void get setShowPass {
    showPass.value = !showPass.value;
  }

  void onChnagedPass(String password) {
    this.password = password;
    if (password.trim().isNotEmpty) {
      hasWrittenPass.value = true;
    } else {
      hasWrittenPass.value = false;
    }
  }

  Future<bool> forgotPassword() async {
    showDialog(context: Get.context!, builder: (_) => const LoadingOverlay());
    String action = resetLevel.value == 1
        ? 'generate'
        : resetLevel.value == 2
            ? 'validate'
            : 'change';
    var params = <String, dynamic>{};
    params['email'] = emailForgot;
    params['password'] = passwordForgot;
    params['action'] = action;
    params['code'] = code;
    var data = json.encode(params);
    var encodedData = Uri.encodeComponent(data);
    try {
      var response =
          await RemoteServices.getAPI("user/forgot_password.php", encodedData);
      Get.back();
      var parsed = json.decode(response);
      showToas(parsed['message']);
      if (resetLevel.value == 1) {
        if (parsed['message'] == 'Temp code generated successfully') {
          return true;
        }
      } else if (resetLevel.value == 2) {
        if (parsed['message'] == 'Temp code is correct') {
          return true;
        }
      } else {
        if (parsed['message'] == 'Password changed successfully') {
          return true;
        }
      }
    } catch (e) {
      showToas('Something went wrong, please try again later');
      log(e.toString());
    }
    return false;
  }

  void onChnagedEmail(String email) {
    this.email = email.trim();
    if (email.trim().isNotEmpty) {
      hasWrittenEmail.value = true;
    } else {
      hasWrittenEmail.value = false;
    }
    errorEmail.value = ValidateAddItem.validateEmail(email) ?? '';
  }

  void onChnagedEmailForgot(String email) {
    emailForgot = email.trim();
  }

  void onChnagedCodeForgot(String code) {
    this.code = code.trim().toUpperCase();
  }

  void onChnagedPassForgot(String code) {
    passwordForgot = code;
    emailForgotError.value = ValidateAddItem.validatePassword(code);
  }

  void reset() {
    emailController.value.clear();
    passwordController.value.clear();
    errorEmail.value = '';
    errorPass.value = null;
    hasWrittenEmail.value = false;
    hasWrittenPass.value = false;
  }
}
