// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/services.dart';

// class BackGroundHandler {
//   static const methodChannel = MethodChannel('location_service/method');
//   static const eventChannel = EventChannel('location_service/event');
//   static StreamSubscription? pressureSub;
//   static Future<void> activateLocation(String token) async {
//     try {
//       var state =
//           (await methodChannel.invokeMethod('check_permission')).toString();
//       log('permission was $state');
//     } catch (e) {
//       log(e.toString());
//     }
//     if (Platform.isAndroid) {
//       try {
//         var available = (await methodChannel
//                 .invokeMethod('start_location_service', {"token": token}))
//             .toString();
//         log('availbility $available');
//       } catch (e) {
//         log(e.toString());
//       }
//     }
//   }

//   static Future<void> stopLocation() async {
//     if (Platform.isAndroid) {
//       try {
//         var available =
//             (await methodChannel.invokeMethod('stop_location_service'))
//                 .toString();
//         log('availbility $available');
//       } catch (e) {
//         log(e.toString());
//       }
//     }
//   }

//   // static Future<void> listen() async {
//   //   pressureSub = eventChannel.receiveBroadcastStream().listen((event) {
//   //     log('availability $event');
//   //   });
//   // }

//   // static Future<void> stopListen() async {
//   //   pressureSub!.cancel();
//   // }
// }
