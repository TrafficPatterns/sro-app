package com.example.sro.workers
//
//import android.Manifest
//import android.app.Service
//import android.content.Context
//import android.content.SharedPreferences
//import android.content.pm.PackageManager
//import android.os.Looper
//import androidx.core.app.ActivityCompat
//import androidx.work.Worker
//import androidx.work.WorkerParameters
//import com.example.sro.Util.Constants
//import com.google.android.gms.location.*
//import com.google.gson.Gson
//import io.flutter.Log
//
//class LocationWorker(private val context: Context, workerParameters: WorkerParameters) : Worker(context, workerParameters) {
//    private lateinit var locationManager: FusedLocationProviderClient
//    private lateinit var locationCallback: LocationCallback
//    private lateinit var locationRequest: LocationRequest
//    private var locationList = mutableListOf<Map<String,String>>()
//
//    override fun doWork(): Result {
//        locationManager = LocationServices.getFusedLocationProviderClient(context)
//        setupRequest()
//        startLocationUpdates()
//        return Result.success()
//    }
//
//    private fun startLocationUpdates() {
//        if (ActivityCompat.checkSelfPermission(
//                context,
//                Manifest.permission.ACCESS_FINE_LOCATION
//            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
//                context,
//                Manifest.permission.ACCESS_COARSE_LOCATION
//            ) != PackageManager.PERMISSION_GRANTED
//        ) {
//            return
//        }
//        locationManager.requestLocationUpdates(
//            locationRequest,
//            locationCallback,
//            Looper.getMainLooper()
//        )
//    }
//
//    private fun setupRequest(){
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
//                    if(location != null) {
//                        val time = System.currentTimeMillis()
//                        val locMap = LinkedHashMap<String, String>()
//                        locMap["time"] = time.toString()
//                        locMap["lat"] = location!!.latitude.toString()
//                        locMap["lng"] = location!!.longitude.toString()
//                        locationList.add(locMap)
//                    }
//                }
//            }
//        }
//    }
//
//    private fun saveList(){
//        val prefs = context.getSharedPreferences(Constants.SharedPreferencesNAME, Service.MODE_PRIVATE)
//        val editor: SharedPreferences.Editor = prefs.edit()
//        val gson = Gson()
//        val data = prefs.getString(Constants.LIST_KEY, null)
//        if(data !=null ){
//            locationList.addAll(gson.fromJson(data, mutableListOf<Map<String,String>>()::class.java))
//        }
//        val encoded = gson.toJson(locationList)
//        editor.putString(Constants.LIST_KEY, encoded)
//        editor.apply()
//        Log.d("Saved Locations", encoded)
//    }
//
//    override fun onStopped() {
//        saveList()
//        super.onStopped()
//        stopLocationUpdates()
//    }
//
//    private fun stopLocationUpdates() {
//        locationManager.removeLocationUpdates(locationCallback)
//    }
//}