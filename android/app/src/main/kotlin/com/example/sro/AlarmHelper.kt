package com.example.sro
//
//import android.app.AlarmManager
//import android.app.PendingIntent
//import android.content.Context
//import android.content.Intent
//import android.os.Build
//import com.example.sro.Receivers.UploadReceiver
//import com.example.sro.Util.Constants
//import io.flutter.Log
//import java.util.*
//
//class AlarmHelper(private val context: Context) {
//    private var alarmManager: AlarmManager =
//        context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
//
//    fun setRepetitiveAlarm(timeInMillis: Long, cancel: Boolean, upload: Boolean, requestCode: Int) {
//        setAlarm(
//            timeInMillis,
//            getPendingIntent(
//                getIntent(upload).apply {
//                    action = Constants.SET_REPEATING
//                    putExtra(Constants.SET_EXACT_TIME, timeInMillis)
//                    putExtra(Constants.CANCEL, cancel)
//                    putExtra(Constants.REQUEST_CODE, requestCode)
//                },
//                requestCode
//            ),
//            upload
//        )
//    }
//
//    private fun setAlarm(timeInMillis: Long, pendingIntent: PendingIntent, upload: Boolean) {
//        alarmManager.cancel(pendingIntent)
//        if (upload) {
//            alarmManager.setRepeating(
//                AlarmManager.RTC_WAKEUP,
//                timeInMillis,
//                AlarmManager.INTERVAL_HALF_DAY,
//                pendingIntent
//            )
//        } else {
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                alarmManager.setExactAndAllowWhileIdle(
//                    AlarmManager.RTC_WAKEUP,
//                    timeInMillis,
//                    pendingIntent
//                )
//            } else {
//                alarmManager.setExact(
//                    AlarmManager.RTC_WAKEUP,
//                    timeInMillis,
//                    pendingIntent
//                )
//            }
//        }
//    }
//
//    private fun getIntent(upload: Boolean): Intent = Intent(
//        context,
//        if (upload) UploadReceiver::class.java else LocationAlarmReceiver::class.java
//    )
//
//    private fun getPendingIntent(intent: Intent, requestCode: Int): PendingIntent {
//        var flags = PendingIntent.FLAG_UPDATE_CURRENT
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            flags = flags or PendingIntent.FLAG_IMMUTABLE
//        }
//        return PendingIntent.getBroadcast(context, requestCode, intent, flags)
//    }
//
//    fun setup() {
//        val calendar: Calendar = Calendar.getInstance()
//        calendar.set(Calendar.HOUR_OF_DAY, 7)
//        calendar.set(Calendar.MINUTE, 0)
//        calendar.set(Calendar.SECOND, 0)
//        setRepetitiveAlarm(calendar.timeInMillis, false, false, 100)
//        calendar.set(Calendar.HOUR_OF_DAY, 9)
//        calendar.set(Calendar.MINUTE, 0)
//        calendar.set(Calendar.SECOND, 0)
//        setRepetitiveAlarm(calendar.timeInMillis, true, false, 101)
//
//        calendar.set(Calendar.HOUR_OF_DAY, 11)
//        calendar.set(Calendar.MINUTE, 0)
//        calendar.set(Calendar.SECOND, 0)
//        setRepetitiveAlarm(calendar.timeInMillis, false, false, 102)
//        calendar.set(Calendar.HOUR_OF_DAY, 13)
//        calendar.set(Calendar.MINUTE, 0)
//        calendar.set(Calendar.SECOND, 0)
//        setRepetitiveAlarm(calendar.timeInMillis, true, false, 103)
//
//        calendar.set(Calendar.HOUR_OF_DAY, 14)
//        calendar.set(Calendar.MINUTE, 0)
//        calendar.set(Calendar.SECOND, 0)
//        setRepetitiveAlarm(calendar.timeInMillis, false, false, 104)
//        calendar.set(Calendar.HOUR_OF_DAY, 16)
//        calendar.set(Calendar.MINUTE, 0)
//        calendar.set(Calendar.SECOND, 0)
//        setRepetitiveAlarm(calendar.timeInMillis, true, false, 105)
//
//        calendar.set(Calendar.HOUR_OF_DAY, 20)
//        calendar.set(Calendar.MINUTE, 0)
//        calendar.set(Calendar.SECOND, 0)
//        setRepetitiveAlarm(calendar.timeInMillis, false, true, 106)
//    }
//
//    fun cancelPrevious() {
//        alarmManager.cancel(
//            getPendingIntent(
//                getIntent(false).apply {
//                    action = Constants.SET_REPEATING
//                },
//                100
//            )
//        )
//        alarmManager.cancel(
//            getPendingIntent(
//                getIntent(false).apply {
//                    action = Constants.SET_REPEATING
//                },
//                101
//            )
//        )
//
//        alarmManager.cancel(
//            getPendingIntent(
//                getIntent(false).apply {
//                    action = Constants.SET_REPEATING
//                },
//                102
//            )
//        )
//
//        alarmManager.cancel(
//            getPendingIntent(
//                getIntent(false).apply {
//                    action = Constants.SET_REPEATING
//                },
//                103
//            )
//        )
//
//        alarmManager.cancel(
//            getPendingIntent(
//                getIntent(false).apply {
//                    action = Constants.SET_REPEATING
//                },
//                104
//            )
//        )
//
//        alarmManager.cancel(
//            getPendingIntent(
//                getIntent(false).apply {
//                    action = Constants.SET_REPEATING
//                },
//                105
//            )
//        )
//
//        alarmManager.cancel(
//            getPendingIntent(
//                getIntent(true).apply {
//                    action = Constants.SET_REPEATING
//                },
//                106
//            )
//        )
//    }
//}