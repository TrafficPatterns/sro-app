import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sro/globals.dart';
import 'package:sro/pages/account/account_controller.dart';
import 'package:sro/services/global_functions.dart';

class RemoteServices {
  static Dio dio = Dio();
  static dynamic jsonResponse = "";

  static Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        showToas('No Internte Connection');
        return false;
      }
    } on SocketException catch (_) {
      showToas('No Internte Connection');
      return false;
    }
  }

  static Future<dynamic> getAPI(url, queryString,
      {bool ignoreAuth = false}) async {
    if (!(await _checkInternet())) {
      return;
    }
    String globalUrl = 'http://$serverUrl/$url';
    globalUrl += "?data=$queryString";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 40);
    try {
      await dio.get(globalUrl).then((response) {
        jsonResponse = response.data;
      });
      if (!ignoreAuth) {
        try {
          var decoded = json.decode(jsonResponse);
          if (decoded['status'] == 'error' &&
              decoded['message'] == 'Authentication failed.') {
            Future.delayed(
                const Duration(seconds: 1), AccountController.logout);
            showToas('Session Expired');
            return {};
          }
        } catch (e) {
          log(e.toString());
        }
      }
      return jsonResponse;
    } catch (e) {
      log(e.toString());
    }
  }
}
