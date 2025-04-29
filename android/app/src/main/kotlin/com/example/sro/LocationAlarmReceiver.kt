package com.example.sro
//
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import android.os.Build
//import android.text.format.DateFormat
//import com.example.sro.Util.Constants
//import io.flutter.Log
//import java.util.*
//
//
//class LocationAlarmReceiver : BroadcastReceiver() {
//    private lateinit var serviceIntent : Intent
//
//    override fun onReceive(context: Context, intent: Intent) {
//        serviceIntent = Intent(context, MyService::class.java)
//        val timeInMillis = intent.getLongExtra(Constants.SET_EXACT_TIME, 0L)
//        val cancel = intent.getBooleanExtra(Constants.CANCEL, false)
//        val requestCode = intent.getIntExtra(Constants.REQUEST_CODE, 100)
//        var day = 86400000L
//        AlarmHelper(context).setRepetitiveAlarm(timeInMillis+day, cancel, false, requestCode)
//        if(cancel){
//            context.stopService(serviceIntent)
//            Log.d("Alarm Executed at || Service Stopped", convertDate(timeInMillis))
//        }else {
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                context.startForegroundService(serviceIntent)
//            } else {
//                context.startService(serviceIntent)
//            }
//            Log.d("Alarm Executed at || Service Started", convertDate(timeInMillis))
//        }
//    }
//
//    private fun convertDate(timeInMillis: Long): String =
//        DateFormat.format("dd/MM/yyyy hh:mm:ss", timeInMillis).toString()
//}