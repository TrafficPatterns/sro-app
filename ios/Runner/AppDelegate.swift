import UIKit
import Flutter
import GoogleMaps
import workmanager
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      
    GMSServices.provideAPIKey("AIzaSyDEBPLItA1bzKTw3jl9AYE-n6y5xo4jD5Q")

    WorkmanagerPlugin.registerTask(withIdentifier: "UPLOAD_SAVED_LOCATIONS")

    WorkmanagerPlugin.setPluginRegistrantCallback { registry in  
    GeneratedPluginRegistrant.register(with: registry)
    }
    
      // let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      //     let batteryChannel = FlutterMethodChannel(name: "location_service/method",
      //                                               binaryMessenger: controller.binaryMessenger)
      //     batteryChannel.setMethodCallHandler({
      //       (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      //         if(call.method == "start_location_service") {
      //             // let alarmManager = NSBackgroundActivityScheduler(identifier: "org.schoolroutes.schoolroutes")
      //             // alarmManager.repeats = true
                  
      //             result("Start location")
      //         } else if(call.method == "check_permission"){
      //             // let locationManager = CLLocationManager()
      //             // locationManager.delegate = self
      //             // let status = CLLocationManager.authorizationStatus()
      //             // switch status {
      //             //     case .authorizedWhenInUse:
      //             //       locationManager.requestAlwaysAuthorization()
      //             //       break
      //             //     case .denied:
      //             //         Result("Access Denied")
      //             //     case .notDetermined:
      //             //       locationManager.requestAlwaysAuthorization()
      //             //       break
      //             //     case .restricted:
      //             //       locationManager.requestAlwaysAuthorization()
      //             //       break
      //             // }
      //             result("check permissions")
      //         } else if(call.method == "stop_location_service"){
      //             result("Stop Location")
      //         } else {
      //             result(FlutterMethodNotImplemented)
      //         }
      //     })
      
    
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
