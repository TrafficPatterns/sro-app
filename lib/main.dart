import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/route/app_pages.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/services/httpoverride.dart';
import 'package:sro/services/local_notification.dart';
import 'package:sro/themes/app_theme.dart';
import 'package:workmanager/workmanager.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  log(message.toString());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'UPLOAD_SAVED_LOCATIONS') {
      if (Platform.isAndroid) {
        Workmanager().registerOneOffTask(
            "UPLOAD_SAVED_LOCATIONS", "UPLOAD_SAVED_LOCATIONS",
            initialDelay: const Duration(days: 1),
            constraints: Constraints(networkType: NetworkType.connected));
      }
      var sp = await SharedPreferences.getInstance();
      if (sp.getBool(LOCATION_KEY) ?? false) {
        try {
          await uploadLocations();
          return true;
        } catch (e) {
          log('$e From dispatcher');
          return false;
        }
      } else {
        return false;
      }
    }
    return true;
  });
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   var androidInfo = await deviceInfo.androidInfo;
  //   if (androidInfo.version.sdkInt! > 28) {
  //     AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  //   }
  // }
  Workmanager().initialize(callbackDispatcher);
  user = await UserModel().getUserFromSharedPreferences;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      transitionDuration: const Duration(milliseconds: 100),
      title: 'School Routes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.list,
    );
  }
}
