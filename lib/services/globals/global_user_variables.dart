import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

UserModel user = UserModel();
SharedPreferences? prefs;

// ignore: non_constant_identifier_names
var LOCATION_KEY = "LOCATION_KEY";
// ignore: non_constant_identifier_names
var LOCATION_KEY_STORAGE = "LOCATION_KEY_STORAGE";

var showD = false;

var isGuest = false;

String? cityIDForGuest;

StreamSubscription<Position>? stream;

String privacyPolicyUrl = 'http://user.schoolroutes.org/policy.php';
