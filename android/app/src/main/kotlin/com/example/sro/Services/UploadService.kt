package com.example.sro.Services
//
//import android.app.Service
//import android.content.Intent
//import android.content.SharedPreferences
//import android.os.IBinder
//import androidx.core.app.NotificationCompat
//import com.android.volley.Request
//import com.android.volley.toolbox.JsonObjectRequest
//import com.android.volley.toolbox.Volley
//import com.example.sro.Util.Constants
//import com.example.sro.Util.RandomIntUtils
//import com.google.gson.Gson
//import io.flutter.Log
//import org.schoolroutes.schoolroutes.R
//import java.net.URLEncoder
//
//class UploadService : Service() {
//
//    override fun onCreate() {
//        val compatBuilder = NotificationCompat.Builder(this, "location_service")
//            .setContentText("Uploading location data").setContentTitle("School Routes").setSmallIcon(
//                R.drawable.uploading)
//        startForeground(RandomIntUtils.getRandomInt(),compatBuilder.build())
//        super.onCreate()
//        upload()
//    }
//
//    private fun upload(){
//        val prefs = getSharedPreferences(Constants.SharedPreferencesNAME, MODE_PRIVATE)
//        val editor: SharedPreferences.Editor = prefs.edit()
//        val gson = Gson()
//        val data = prefs.getString(Constants.LIST_KEY, "[]")
//        var upMap = LinkedHashMap<String, String>()
//        upMap["token"] = prefs.getString("token","")!!
//        upMap["location"] = data!!
//        val encodedHREF = URLEncoder.encode(gson.toJson(upMap), "utf-8")
//        val url = "http://api.schoolroutes.org/user/uploadLocation.php?data=$encodedHREF"
//        val volleyQueue = Volley.newRequestQueue(this)
//        val jsonObjectRequest = JsonObjectRequest(
//            Request.Method.GET,
//            url,
//            null,
//            { response ->
//                Log.d("Upload Response", response.toString())
//                Log.d("Uploaded Locations Successful", encodedHREF)
//                editor.putString(Constants.LIST_KEY, null)
//                editor.apply()
//            },
//            { error ->
//                Log.e("MainActivity", "Upload error: ${error.localizedMessage}")
//            }
//        )
//        volleyQueue.add(jsonObjectRequest)
//        stopSelf()
//    }
//
//    override fun onBind(p0: Intent?): IBinder? {
//        return null
//    }
//}