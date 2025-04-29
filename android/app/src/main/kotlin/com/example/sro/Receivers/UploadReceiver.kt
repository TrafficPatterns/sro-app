package com.example.sro.Receivers
//
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import android.os.Build
//import android.text.format.DateFormat
//import androidx.work.*
//import com.example.sro.Services.UploadService
//import com.example.sro.Util.Constants
//import com.example.sro.workers.UploadWorker
//import io.flutter.Log
//
//class UploadReceiver : BroadcastReceiver() {
////    private lateinit var serviceIntent : Intent
//
//    override fun onReceive(context: Context, intent: Intent) {
////        serviceIntent = Intent(context, UploadService::class.java)
//        val timeInMillis = intent.getLongExtra(Constants.SET_EXACT_TIME, 0L)
//        val myConstraints: Constraints = Constraints.Builder()
//            .setRequiredNetworkType(NetworkType.CONNECTED)
//            .build()
//        val uploadWorkRequest: WorkRequest =
//            OneTimeWorkRequestBuilder<UploadWorker>()
//                .setConstraints(myConstraints)
//                .addTag(Constants.UPLOAD_WORKER_TAG)
//                .build()
//        WorkManager.getInstance(context).enqueue(uploadWorkRequest)
//        Log.d("Upload Service Started || Alarm Executed at", convertDate(timeInMillis))
//    }
//
//    private fun convertDate(timeInMillis: Long): String =
//        DateFormat.format("dd/MM/yyyy hh:mm:ss", timeInMillis).toString()
//}