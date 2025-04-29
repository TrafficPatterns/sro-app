package com.example.sro

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val methodChannelName = "location_service/method"

    //    private lateinit var alarmHelper: AlarmHelper
    private var methodChannel: MethodChannel? = null


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupChannels(flutterEngine.dartExecutor.binaryMessenger)
        createChannel()
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "location_service",
                "location_service_name",
                NotificationManager.IMPORTANCE_HIGH
            )
            val notificationManager: NotificationManager = getSystemService(
                NOTIFICATION_SERVICE
            ) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun onDestroy() {
        teardownChannels()
        super.onDestroy()
    }

    private fun setupChannels(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, methodChannelName)
        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "start_location_service" -> {
                    //                val token = call.argument<String>("token")
                    //                if (token != null) {
                    //                    val prefs = getSharedPreferences(Constants.SharedPreferencesNAME, MODE_PRIVATE)
                    //                    val editor: SharedPreferences.Editor = prefs.edit()
                    //                    editor.putString("token", token)
                    //                    editor.putBoolean("repeat", true)
                    //                    editor.apply()
                    //                    alarmHelper = AlarmHelper(context)
                    //                    alarmHelper.setup()
                    //                    result.success("service started")
                    //                } else {
                    //                    result.error(
                    //                        "10",
                    //                        "Could not find token",
                    //                        "Token not found but is needed to upload the location"
                    //                    )
                    //                }
                    Result.success("Location Started")
                }
                "stop_location_service" -> {
                    //                val prefs = getSharedPreferences(Constants.SharedPreferencesNAME, MODE_PRIVATE)
                    //                val editor: SharedPreferences.Editor = prefs.edit()
                    //                editor.putBoolean("repeat", false)
                    //                editor.apply()
                    //                alarmHelper = AlarmHelper(context)
                    //                alarmHelper.cancelPrevious()
                    //                val serviceIntent = Intent(context, MyService::class.java)
                    //                context.stopService(serviceIntent)
                    Result.success("Stop Location")
                }
                "check_permission" -> {
                    //                checkLocationPermission()
                    result.success("Permission Asked")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun teardownChannels() {
        methodChannel!!.setMethodCallHandler(null)
    }

//    private fun checkLocationPermission() {
//        if (ActivityCompat.checkSelfPermission(
//                this,
//                Manifest.permission.ACCESS_FINE_LOCATION
//            ) != PackageManager.PERMISSION_GRANTED
//        ) {
//            requestLocationPermission()
//        } else {
//            checkBackgroundLocation()
//        }
//    }
//
//    private fun checkBackgroundLocation() {
//        if (ActivityCompat.checkSelfPermission(
//                this,
//                Manifest.permission.ACCESS_BACKGROUND_LOCATION
//            ) != PackageManager.PERMISSION_GRANTED
//        ) {
//            requestBackgroundLocationPermission()
//        }
//    }
//
//    private fun requestLocationPermission() {
//        ActivityCompat.requestPermissions(
//            this,
//            arrayOf(
//                Manifest.permission.ACCESS_FINE_LOCATION,
//            ),
//            MY_PERMISSIONS_REQUEST_LOCATION
//        )
//    }
//
//    private fun requestBackgroundLocationPermission() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            ActivityCompat.requestPermissions(
//                this,
//                arrayOf(
//                    Manifest.permission.ACCESS_BACKGROUND_LOCATION
//                ),
//                MY_PERMISSIONS_REQUEST_BACKGROUND_LOCATION
//            )
//        }
//    }
//
//    override fun onRequestPermissionsResult(
//        requestCode: Int,
//        permissions: Array<String>,
//        grantResults: IntArray
//    ) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
//        when (requestCode) {
//            MY_PERMISSIONS_REQUEST_LOCATION -> {
//                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//
//                    if (ContextCompat.checkSelfPermission(
//                            this,
//                            Manifest.permission.ACCESS_FINE_LOCATION
//                        ) == PackageManager.PERMISSION_GRANTED
//                    ) {
//                        checkBackgroundLocation()
//                    }
//
//                } else {
//                    Log.d("Ali Location", "permission denied")
//                    startActivity(
//                        Intent(
//                            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
//                            Uri.fromParts("package", this.packageName, null),
//                        )
//                    )
//                }
//                return
//            }
//            MY_PERMISSIONS_REQUEST_BACKGROUND_LOCATION -> {
//                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//                    if (ContextCompat.checkSelfPermission(
//                            this,
//                            Manifest.permission.ACCESS_FINE_LOCATION
//                        ) == PackageManager.PERMISSION_GRANTED
//                    ) {
//                        Log.d(
//                            "Ali Location",
//                            "Granted Background Location Permission",
//                        )
//                    }
//                } else {
//                    Log.d("Ali Location", "permission denied")
//                }
//                return
//
//            }
//        }
//    }

//    companion object {
//        private const val     MY_PERMISSIONS_REQUEST_LOCATION = 99
//        private const val MY_PERMISSIONS_REQUEST_BACKGROUND_LOCATION = 66
//    }
}
