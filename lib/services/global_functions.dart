import 'dart:developer' as dev;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/global_widgets/special_listing_widget.dart';
import 'package:sro/services/remote.dart';
import 'package:workmanager/workmanager.dart';

import '../globals.dart';
import '../models/hour.dart';
import '../pages/dashboard/dashboard_controller.dart';
import 'globals/global_user_variables.dart';

class GlobalFunctions {}

String getHashedText(String password) =>
    sha256.convert(utf8.encode(password.trim())).toString();

void showToas(String msg, {int? time}) {
  Fluttertoast.showToast(msg: msg, timeInSecForIosWeb: time ?? 1);
}

void unfocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

Future<bool> isConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

void requestFocusNode(BuildContext context, FocusNode? node) =>
    FocusScope.of(context).requestFocus(node);

double getSize(double num) {
  return (width * num) / 375; // 375 is the screen size of the xd phone designs
}

double getSizeWrtHeight(double num) {
  return (height * num) / 812; // 812 is the screen size of the xd phone designs
}

String getNameofEvent(EventType eventType) {
  if (eventType == EventType.BT) {
    return 'Bike Train';
  } else if (eventType == EventType.WSB) {
    return 'Walking School Bus';
  } else {
    return 'Carpool';
  }
}

HourFormatter? getTimeFromString(String? value) {
  if (value == null || value.isEmpty) return null;
  var temp = value.split(':');
  if (temp.length < 2) return null;
  var temp2 = temp[1].split(' ');
  if (temp2.length < 2) return null;
  return HourFormatter(
      hour: int.parse(temp[0]), minute: int.parse(temp2[0]), amPm: temp2[1]);
}

String getStringFromTime(HourFormatter? formatter) {
  if (formatter == null || !formatter.validate) return '';
  return '${formatter.hour}:${formatter.minute} ${formatter.amPm}';
}

List<LatLng> polyLineParser(String encodedPolyline) {
  List<LatLng> points = [];
  List<Point> point = PolyUtils.decode(encodedPolyline);
  for (var x in point) {
    points.add(LatLng(x.x.toDouble(), x.y.toDouble()));
  }
  return points;
}

double calculateDistance(LatLng l1, LatLng l2) {
  num lat1 = l1.latitude;
  num lon1 = l1.longitude;
  num lat2 = l2.latitude;
  num lon2 = l2.longitude;
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

String capitilize(String? f) {
  if (f == null) {
    return '';
  }
  var splitStr = f.split(" ");
  for (var i = 0; i < splitStr.length; i++) {
    if (splitStr[i].isEmpty) {
      continue;
    }
    splitStr[i] =
        splitStr[i][0].toUpperCase() + splitStr[i].substring(1).toLowerCase();
  }
  f = splitStr.join(" ");
  return f;
}

Future<void> uploadLocations() async {
  try {
    var sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    if (token != null) {
      var dataString = sp.getString(LOCATION_KEY_STORAGE) ?? '[]';
      var data = json.decode(dataString);
      var params = <String, dynamic>{};
      params['token'] = sp.getString('token')!;
      params['locations'] = data;
      var sentData = json.encode(params);
      var encodedData = Uri.encodeComponent(sentData);
      await RemoteServices.getAPI("user/log_location.php", encodedData,
          ignoreAuth: true);
      sp.setString(LOCATION_KEY_STORAGE, '[]');
    }
  } catch (e) {
    dev.log('$e From upload locations in global functions');
  }
}

// Future<void> handleLocationIOS(RemoteMessage message) async {
//   if (Platform.isAndroid) {
//     return;
//   }
//   if (message.data['upload'].toString() == '1') {
//     try {
//       var sp = await SharedPreferences.getInstance();
//       var dataString = sp.getString(LOCATION_KEY_STORAGE) ?? '[]';
//       var data = json.decode(dataString);
//       var params = <String, dynamic>{};
//       params['token'] = user.token!;
//       params['locations'] = data;
//       var sentData = json.encode(params);
//       var encodedData = Uri.encodeComponent(sentData);
//       await RemoteServices.getAPI("user/log_location.php", encodedData,
//           ignoreAuth: true);
//       sp.setString(LOCATION_KEY_STORAGE, '[]');
//     } catch (e) {
//       dev.log(e.toString());
//     }
//   }
//   }
// }

// Future<bool> toggleLocationIOS({@required bool? value}) async {
//   if (Platform.isAndroid) {
//     return true;
//   }
//   try {
//     showDialog(context: Get.context!, builder: (_) => const LoadingOverlay());
//     var params = <String, dynamic>{};
//     params['status'] = value! ? 1 : 0;
//     params['token'] = user.token;
//     var data = json.encode(params);
//     var encodedData = Uri.encodeComponent(data);
//     var response = await RemoteServices.getAPI(
//         "user/set_location_tracking.php", encodedData);
//     var parsedResponse = json.decode(response);
//     Get.back();
//     return parsedResponse['status'] == 'success';
//   } catch (e) {
//     dev.log(e.toString());
//     Get.back();
//     return false;
//   }
// }

Future<bool> checkLocationPermissions() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

Future<void> startLocationTracking() async {
  try {
    await uploadLocations();
  } catch (e) {
    dev.log(e.toString());
  }
  var now = DateTime.now();
  if (now.hour < 17) {
    var at9 = DateTime(now.year, now.month, now.day, 9, 0, 0);
    if (at9.isAfter(now)) {
      var at7 = DateTime(now.year, now.month, now.day, 7, 0, 0);
      var dif = at7.difference(now);
      if (dif.isNegative) {
        logLocation(9);
      } else {
        Future.delayed(dif, () {
          logLocation(9);
        });
      }
    }
    var at13 = DateTime(now.year, now.month, now.day, 13, 0, 0);
    if (at13.isAfter(now)) {
      var at11 = DateTime(now.year, now.month, now.day, 11, 0, 0);
      var dif = at11.difference(now);
      if (dif.isNegative) {
        logLocation(13);
      } else {
        Future.delayed(dif, () {
          logLocation(13);
        });
      }
    }
    var at16 = DateTime(now.year, now.month, now.day, 16, 0, 0);
    if (at16.isAfter(now)) {
      var at14 = DateTime(now.year, now.month, now.day, 14, 0, 0);
      var dif = at14.difference(now);
      if (dif.isNegative) {
        logLocation(16);
      } else {
        Future.delayed(dif, () {
          logLocation(16);
        });
      }
    }
  }
  try {
    uploadLocations();
  } catch (e) {
    dev.log(e.toString());
  }
}

Future<void> logLocation(int to) async {
  var now = DateTime.now();
  var toReach = DateTime(now.year, now.month, now.day, to, 0, 0, 0, 0);
  var diff = toReach.difference(now);
  if (!diff.isNegative) {
    var sp = await SharedPreferences.getInstance();
    await DashboardController.checkLocationTracking(sp);
    if (sp.getBool(LOCATION_KEY) ?? false) {
      late LocationSettings locationSettings;
      if (Platform.isAndroid) {
        locationSettings = AndroidSettings(
            accuracy: LocationAccuracy.high,
            intervalDuration: const Duration(milliseconds: 500),
            foregroundNotificationConfig: const ForegroundNotificationConfig(
                notificationText: "Location is Being Logged",
                notificationTitle: "SchoolRoutes.org"));
      } else {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.best,
        );
      }
      int interval;
      if (to == 9) {
        interval = 1;
      } else if (to == 13) {
        interval = 2;
      } else {
        interval = 3;
      }
      var oldListString = sp.getString(LOCATION_KEY_STORAGE) ?? '[]';
      var oldList = json.decode(oldListString) as List<dynamic>;
      stream = Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((event) {
        var temp = <String, dynamic>{};
        temp['lat'] = event.latitude;
        temp['lng'] = event.longitude;
        temp['timeInterval'] = interval;
        temp['time'] = now.millisecondsSinceEpoch;
        oldList.add(temp);
        dev.log(temp.toString());
        sp.setString(LOCATION_KEY_STORAGE, json.encode(oldList));
      });
      Future.delayed(diff, () async {
        if (stream != null) {
          stream!.cancel();
        }
        var newListString = json.encode(oldList);
        sp.setString(LOCATION_KEY_STORAGE, newListString);
        try {
          uploadLocations();
        } catch (e) {
          dev.log(e.toString());
        }
      });
    }
  }
}

void scheduleLocationUpload() {
  if (!Platform.isAndroid) {
    return;
  }
  Workmanager().cancelAll();
  var now = DateTime.now();
  var at20 = DateTime(now.year, now.month, now.day, now.hour, 0, 0, 0, 0);
  var dif = at20.difference(now);
  if (dif.isNegative) {
    at20 = DateTime(now.year, now.month, now.day + 1, now.hour, 0, 0, 0, 0);
    dif = at20.difference(now);
    if (Platform.isAndroid) {
      Workmanager().registerPeriodicTask(
          "UPLOAD_SAVED_LOCATIONS", "UPLOAD_SAVED_LOCATIONS",
          initialDelay: dif,
          constraints: Constraints(networkType: NetworkType.connected),
          frequency: const Duration(days: 1));
    } else {
      Workmanager().registerOneOffTask(
          "UPLOAD_SAVED_LOCATIONS", "UPLOAD_SAVED_LOCATIONS",
          initialDelay: dif,
          constraints: Constraints(networkType: NetworkType.connected));
    }
  } else {
    if (Platform.isAndroid) {
      Workmanager().registerPeriodicTask(
          "UPLOAD_SAVED_LOCATIONS", "UPLOAD_SAVED_LOCATIONS",
          initialDelay: const Duration(days: 1),
          constraints: Constraints(networkType: NetworkType.connected),
          frequency: const Duration(days: 1));
    } else {
      Workmanager().registerOneOffTask(
          "UPLOAD_SAVED_LOCATIONS", "UPLOAD_SAVED_LOCATIONS",
          initialDelay: const Duration(days: 1),
          constraints: Constraints(networkType: NetworkType.connected));
    }
  }
}

String htmlToText(String html) {
  // regex to remove html tags
  final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
  return html.replaceAll(exp, '');
}
