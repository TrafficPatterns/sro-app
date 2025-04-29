package com.example.sro.Receivers
//
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import com.example.sro.AlarmHelper
//import com.example.sro.Util.Constants
//import io.flutter.embedding.android.FlutterActivity
//
//class BootComplete : BroadcastReceiver() {
//    override fun onReceive(context: Context, intent: Intent) {
//        val action: String? = intent.action
//        if (action != null) {
//            if (action == Intent.ACTION_BOOT_COMPLETED) {
//                val prefs = context.getSharedPreferences(
//                    Constants.SharedPreferencesNAME,
//                    FlutterActivity.MODE_PRIVATE
//                )
//                if(prefs.getBoolean("repeat", false)){
//                    val alarmHelper = AlarmHelper(context)
//                    alarmHelper.setup()
//                }
//            }
//        }
//    }
//}