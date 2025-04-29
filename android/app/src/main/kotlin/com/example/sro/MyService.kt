package com.example.sro
//
//import android.Manifest
//import android.app.Service
//import android.content.Intent
//import android.content.SharedPreferences
//import android.content.pm.PackageManager
//import android.os.IBinder
//import androidx.core.app.ActivityCompat
//import androidx.core.app.NotificationCompat
//import com.example.sro.Util.Constants
//import com.example.sro.Util.RandomIntUtils
//import com.google.android.gms.location.*
//import com.google.gson.Gson
//import io.flutter.Log
//import org.schoolroutes.schoolroutes.R
//import java.util.*
//import kotlin.collections.LinkedHashMap
//
//class MyService : Service() {
//    private var locationManager: FusedLocationProviderClient? = null
//    private lateinit var locationCallback: LocationCallback
//    private lateinit var locationRequest: LocationRequest
//    private var locationList = mutableListOf<Map<String, String>>()
//
//    override fun onCreate() {
//        val compatBuilder = NotificationCompat.Builder(this, "location_service")
//            .setContentText("Location is being logged").setContentTitle("School Routes")
//            .setSmallIcon(R.drawable.location)
//        startForeground(RandomIntUtils.getRandomInt(), compatBuilder.build())
//        super.onCreate()
//        locationManager = LocationServices.getFusedLocationProviderClient(this)
//        setupRequest()
//        startLocationUpdates()
//    }
//
//    private fun startLocationUpdates() {
//        if (ActivityCompat.checkSelfPermission(
//                this,
//                Manifest.permission.ACCESS_FINE_LOCATION
//            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
//                this,
//                Manifest.permission.ACCESS_COARSE_LOCATION
//            ) != PackageManager.PERMISSION_GRANTED
//        ) {
//            stopSelf()
//            return
//        }
//        locationManager!!.requestLocationUpdates(
//            locationRequest,
//            locationCallback,
//            null
//        )
//    }
//
//    override fun onDestroy() {
//        saveList()
//        super.onDestroy()
//        stopLocationUpdates()
//    }
//
//    private fun setupRequest() {
//        locationRequest = LocationRequest.create().apply {
//            interval = 100
//            fastestInterval = 100
//            priority = Priority.PRIORITY_HIGH_ACCURACY
//        }
//        locationCallback = object : LocationCallback() {
//            override fun onLocationResult(locationResult: LocationResult) {
//                super.onLocationResult(locationResult)
//                if (locationResult.locations.isNotEmpty()) {
//                    val location = locationResult.lastLocation
//                    if (location != null) {
//                        val time = System.currentTimeMillis()
//                        val hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
//                        val locMap = LinkedHashMap<String, String>()
//                        locMap["timeInterval"] =
//                            (if (hour <= 9) 1 else if (hour <= 13) 2 else 3).toString()
//                        locMap["time"] = time.toString()
//                        locMap["lat"] = location.latitude.toString()
//                        locMap["lng"] = location.longitude.toString()
//                        locationList.add(locMap)
//                    }
//                }
//            }
//        }
//    }
//
//    private fun saveList() {
//        val prefs = getSharedPreferences(Constants.SharedPreferencesNAME, MODE_PRIVATE)
//        val editor: SharedPreferences.Editor = prefs.edit()
//        val gson = Gson()
//        val data = prefs.getString(Constants.LIST_KEY, null)
//        if (data != null) {
//            locationList.addAll(
//                gson.fromJson(
//                    data,
//                    mutableListOf<Map<String, String>>()::class.java
//                )
//            )
//        }
//        val encoded = gson.toJson(locationList)
//        editor.putString(Constants.LIST_KEY, encoded)
//        editor.apply()
//        Log.d("Saved Locations", encoded)
//    }
//
//    private fun stopLocationUpdates() {
//        if (locationManager != null) {
//            locationManager!!.removeLocationUpdates(locationCallback)
//        }
//    }
//
//    override fun onBind(p0: Intent?): IBinder? {
//        return null
//    }
//}