package com.example.sro.workers
//
//import android.app.Service
//import android.content.Context
//import android.content.SharedPreferences
//import androidx.work.Worker
//import androidx.work.WorkerParameters
//import com.android.volley.Request
//import com.android.volley.toolbox.JsonObjectRequest
//import com.android.volley.toolbox.Volley
//import com.example.sro.Util.Constants
//import com.google.gson.Gson
//import io.flutter.Log
//import java.net.URLEncoder
//
//class UploadWorker(private val context: Context, workerParameters: WorkerParameters) :
//    Worker(context, workerParameters) {
//    override fun doWork(): Result {
//        upload()
//        return Result.success()
//    }
//
//
//    private fun upload() {
//        val prefs =
//            context.getSharedPreferences(Constants.SharedPreferencesNAME, Service.MODE_PRIVATE)
//        val editor: SharedPreferences.Editor = prefs.edit()
//        val gson = Gson()
//        val data = prefs.getString(Constants.LIST_KEY, "[]")
//        val decodedData = gson.fromJson(data, mutableListOf<Map<String, String>>()::class.java)
//        var index = 0
//        val errorData = mutableListOf<Map<String, String>>()
//        while (true) {
//            if (index * 10 >= decodedData.size) {
//                break;
//            }
//            var upperLimit = ((index + 1) * 10)
//            if (upperLimit > decodedData.size) {
//                upperLimit = decodedData.size
//            }
//            val sublist = decodedData.slice((index * 10) until upperLimit)
//            val upMap = LinkedHashMap<String, Any>()
//            upMap["token"] = prefs.getString("token", "")!!
//            upMap["locations"] = sublist
//            val encodedHREF = URLEncoder.encode(gson.toJson(upMap), "utf-8")
//            val url = "http://api.schoolroutes.org/user/log_location.php?data=$encodedHREF"
//            val volleyQueue = Volley.newRequestQueue(context)
//            Log.e("URL", url)
//            val jsonObjectRequest = JsonObjectRequest(
//                Request.Method.GET,
//                url,
//                null,
//                { response ->
//                    Log.d("Upload Response", response.toString())
//                    Log.d("Upload Locations Successful", "")
//                    if (upperLimit < decodedData.size) {
//                        editor.putString(
//                            Constants.LIST_KEY,
//                            gson.toJson(decodedData.slice(upperLimit until decodedData.size))
//                        )
//                        editor.apply()
//                    } else {
//                        editor.putString(
//                            Constants.LIST_KEY,
//                            null
//                        )
//                        editor.apply()
//                    }
//                },
//                { error ->
//                    errorData.addAll(sublist)
//                    Log.e("MainActivity", "Upload error: ${error.localizedMessage}")
//                }
//            )
//            volleyQueue.add(jsonObjectRequest)
//            index += 1
//        }
//        if (errorData.isEmpty()) {
//            editor.putString(Constants.LIST_KEY, null)
//            editor.apply()
//        } else {
//            editor.putString(Constants.LIST_KEY, gson.toJson(errorData))
//            editor.apply()
//            Log.e("Upload Error", errorData.toString())
//        }
//    }
//}
