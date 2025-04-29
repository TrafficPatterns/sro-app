import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sro/global_widgets/bottom_sheet.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/dialog_box.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/global_widgets/listing.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/models/direction/route_model.dart';
import 'package:sro/models/school_model.dart';
import 'package:sro/pages/directions/directions_page.dart';
import 'package:sro/pages/directions/save_route.dart';
import 'package:sro/pages/loading/loading_overlay.dart';
import 'package:sro/services/global_functions.dart';
// import 'package:location/location.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../route/app_routes.dart';
import '../../services/globals/global_user_variables.dart';
import '../../services/remote.dart';

class DirectionsController extends GetxController {
  late Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  var school = Rx<SchoolModel>(SchoolModel());
  var mode = Rx<TravelMode>(TravelMode.car);
  var route = Rx<RouteModel?>(null);
  var markers = Rx<Set<Marker>>({});
  FlutterTts flutterTts = FlutterTts();
  var line = Rx<List<LatLng>>([]);
  var instructios = Rx<String?>(null);
  var said = false;
  StreamSubscription<Position>? positionStream;
  var reached = Rx<String?>(null);
  var meters = Rx<int?>(null);
  var listen = Rx<bool>(false);
  var ind = Rx<List<int>?>(null);
  var offTrack = Rx<bool>(false);
  var initialResponse = Rx<dynamic>(null);
  var nameController = TextEditingController().obs;

  Future<dynamic> calculateRoute(
      {bool recalculte = false, dynamic respone}) async {
    resetParams();
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToas('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToas('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToas(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }
    Position locationData = await Geolocator.getCurrentPosition();
    var controller = await mapController.future;
    markers.value = {
      Marker(
          markerId: const MarkerId('school'), position: school.value.location!),
      Marker(
          markerId: const MarkerId('my_location'),
          position: LatLng(locationData.latitude, locationData.longitude))
    };
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locationData.latitude, locationData.longitude),
        zoom: 15)));
    await callDirections(locationData,
        recalculate: recalculte, response: respone);
    LocationSettings locationSettings =
        const LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((currentLocation) {
      if (listen.value) {
        markers.value = {
          Marker(
              markerId: const MarkerId('school'),
              position: school.value.location!),
          Marker(
              markerId: const MarkerId('my_location'),
              position:
                  LatLng(currentLocation.latitude, currentLocation.longitude))
        };
        onChangeLocation(currentLocation);
        update();
      }
    });
  }

  Future<dynamic> callDirections(Position locationData,
      {bool recalculate = false, dynamic response}) async {
    showDialog(context: Get.context!, builder: (_) => const LoadingOverlay());
    dynamic jsonResponse;
    if (response == null) {
      Dio dio = Dio();
      LatLng pos = school.value.location!;
      if (school.value.gates.isNotEmpty) {
        log("${school.value.gates}");
        var min = calculateDistance(
            LatLng(locationData.latitude, locationData.longitude),
            school.value.gates[0]);
        pos = school.value.gates[0];
        for (var gate in school.value.gates) {
          if (calculateDistance(
                  LatLng(locationData.latitude, locationData.longitude),
                  gate) <=
              min) {
            pos = gate;
          }
        }
      }
      String globalUrl =
          // 'https://maps.googleapis.com/maps/api/directions/json?destination=33.911880,36.013580&origin=${locationData.latitude},${locationData.longitude}&mode=${TravelModeMap[mode]}&key=AIzaSyDQ4jeHkQCg5sVvzADyvQSqglBUN2xHSUk';
          'https://maps.googleapis.com/maps/api/directions/json?destination=${pos.latitude},${pos.longitude}&origin=${locationData.latitude},${locationData.longitude}&mode=${TravelModeMap[mode]}&key=AIzaSyDQ4jeHkQCg5sVvzADyvQSqglBUN2xHSUk';
      dio.options.connectTimeout = const Duration(seconds: 40);
      try {
        await dio.get(globalUrl).then((dioResponse) {
          jsonResponse = dioResponse.data;
        });
      } catch (e) {
        log(e.toString());
      }
    } else {
      jsonResponse = response;
    }
    try {
      route.value = RouteModel.parseRouteFromMap(jsonResponse);
      line.value = route.value!.routes![0].overviewPolyline!;
    } catch (e) {
      log(e.toString());
      if (route.value != null &&
          route.value!.status == DirectionsStatus.ZERO_RESULTS) {
        showToas('No routes found for this travel mode');
      } else {
        showToas('Something went wrong please try again');
      }
      Get.back();
      Get.back();
      return;
    }
    update();
    listen.value = true;
    Get.back();
    if (!recalculate && response == null) {
      initialResponse.value = jsonResponse;
      logRoute();
      nameController.value.clear();
      if (!isGuest) {
        DialogBox.showCustomDialog(child: const SaveRoute());
      }
    }
  }

  Future<void> logRoute() async {
    try {
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['fromLat'] =
          route.value!.routes![0].legs![0].startLocation!.latitude;
      params['fromLng'] =
          route.value!.routes![0].legs![0].startLocation!.longitude;
      params['fromAddress'] = route.value!.routes![0].legs![0].startAddress!;
      params['schoolID'] = school.value.id!;
      params['mode'] = TravelModeMap[mode].toString().substring(0, 1);
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI(
          "user/add_route_request.php", encodedData,
          ignoreAuth: true);
      log(res.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Set<Polyline> get getRoute {
    Set<Polyline> polylines = {};
    if (route.value != null) {
      polylines.add(Polyline(
          points: line.value,
          color: const Color(0xff00FF7F),
          polylineId: PolylineId(
              school.value.id != null ? school.value.id! : 'route_to_school'),
          width: 4));
    }
    return polylines;
  }

  Future<dynamic> onChangeLocation(Position currentLocation) async {
    try {
      double min = double.maxFinite;
      int xx = 0, yy = 0, ii = 0;
      int xxI = 0, yyI = 0, iiI = 0;

      for (var x in route.value!.routes![0].legs!) {
        yyI = 0;
        for (var y in x.steps!) {
          iiI = 0;
          for (var z in y.polyline!) {
            var distance = SphericalUtils.computeDistanceBetween(
                math.Point(z.latitude, z.longitude),
                math.Point(
                    currentLocation.latitude, currentLocation.longitude));
            if (distance < min) {
              min = distance;
              xx = xxI;
              yy = yyI;
              ii = iiI;
              ind.value = [xx, yy];
            }
            iiI++;
          }
          yyI++;
        }
        xxI++;
      }
      if (min > 115) {
        log('\n Getting Off track $min \n');
        offTrack.value = true;
      } else {
        offTrack.value = false;
      }
      line.value =
          route.value!.routes![0].legs![xx].steps![yy].polyline!.sublist(ii);
      for (var x in route.value!.routes![0].legs![xx].steps!.sublist(yy + 1)) {
        line.value.addAll(x.polyline!);
      }
      for (var x in route.value!.routes![0].legs!.sublist(xx + 1)) {
        for (var y in x.steps!) {
          line.value.addAll(y.polyline!);
        }
      }
      if (xx == route.value!.routes![0].legs!.length - 1 &&
          yy == route.value!.routes![0].legs![xx].steps!.length - 1) {
        var lastStep = route.value!.routes![0].legs![xx].steps![yy];
        var remaining = SphericalUtils.computeDistanceBetween(
            math.Point(currentLocation.latitude, currentLocation.longitude),
            math.Point(lastStep.polyline!.last.latitude,
                lastStep.polyline!.last.longitude));
        if (remaining < 30) {
          reached.value = 'You have reached your destination';
          markers.value = {
            Marker(
                markerId: MarkerId(school.value.id ?? 'school '),
                position: school.value.location!)
          };
        } else {
          reached.value = null;
        }
      } else {
        reached.value = null;
      }
      var distance = 0.0;
      // calculate distance between every point in the polyline and add it to the total distance
      var tempLine =
          route.value!.routes![0].legs![xx].steps![yy].polyline!.sublist(ii);
      for (var i = 0; i < tempLine.length - 1; i++) {
        distance += SphericalUtils.computeDistanceBetween(
            math.Point(tempLine[i].latitude, tempLine[i].longitude),
            math.Point(tempLine[i + 1].latitude, tempLine[i + 1].longitude));
      }
      var totalDistance = 0.0;
      var totalLine = route.value!.routes![0].legs![xx].steps![yy].polyline!;
      // calculate distance between the every point in the polyline and add it to the total distance
      for (var i = 0; i < totalLine.length - 1; i++) {
        totalDistance += SphericalUtils.computeDistanceBetween(
            math.Point(totalLine[i].latitude, totalLine[i].longitude),
            math.Point(totalLine[i + 1].latitude, totalLine[i + 1].longitude));
      }

      meters.value = distance.round();

      String instructions;
      if (yy + 1 < route.value!.routes![0].legs![xx].steps!.length) {
        instructions =
            route.value!.routes![0].legs![xx].steps![yy + 1].htmlInstructions!;
      } else {
        instructions =
            route.value!.routes![0].legs![xx].steps![yy].htmlInstructions!;
      }
      if (instructios.value != instructions) {
        said = false;
        instructios.value = instructions;
        await flutterTts.speak(htmlToText("In $meter $instructions"));
      } else if (distance == totalDistance / 2) {
        said = false;
        await flutterTts.speak(htmlToText("In $meter $instructions"));
      } else if (distance < 30 && !said) {
        said = true;
        await flutterTts.speak(htmlToText(instructions));
      }
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  String get instruction {
    return instructios.value ?? 'Start your Route';
  }

  String get meter {
    int? feet = meters.value != null ? (meters.value! * 3.281).floor() : null;
    if (feet != null) {
      if (feet / 5280.0 > 0.1) {
        double miles = feet / 5280.0;
        miles = roundDouble(miles, 2);
        if (miles - miles.floor() == 0) {
          miles = miles.floorToDouble();
        }
        return '$miles${miles > 1 ? ' miles' : ' mile'}';
      }
    }
    return '0.1 mile';
  }

  void resetParams() {
    if (positionStream != null) {
      positionStream!.cancel();
    }
    markers.value = {};
    route.value = null;
    line.value = [];
    instructios.value = null;
    meters.value = null;
    offTrack.value = false;
    reached.value = null;
    listen.value = false;
    update();
  }

  void showFullDirections() {
    List<Widget> html = [];
    if (route.value != null &&
        route.value!.routes != null &&
        route.value!.routes![0].legs != null) {
      int i1 = 0, i2 = 0;
      for (var x in route.value!.routes![0].legs!) {
        for (var y in x.steps!) {
          if (ind.value != null) {
            if (i1 == ind.value![0] && i2 == ind.value![1]) {
              html.add(Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 197, 212, 228)),
                    child: HtmlWidget(y.htmlInstructions!)),
              ));
            } else {
              html.add(Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffECEDEE)),
                    child: HtmlWidget(y.htmlInstructions!)),
              ));
            }
          }
          i2++;
        }
        i1++;
      }
    }
    CustomBottomSheet.show(Get.context!,
        label: 'Directions',
        child: SizedBox(
          height: 350,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              shrinkWrap: true,
              children: html.isNotEmpty
                  ? html
                  : [const Center(child: Text('No Route Available'))],
            ),
          ),
        ));
  }

  Future<void> showBottomSheetForSavedRoutes(
    TravelMode travelMode, {
    @required SchoolModel? school,
  }) async {
    var sp = await SharedPreferences.getInstance();
    Map<String, dynamic> list = sp.getString(SaveRoute.routeKey) != null
        ? json.decode(sp.getString(SaveRoute.routeKey)!)
        : {};
    if (list.isNotEmpty) {
      Map<String, dynamic> temp = {};
      for (var x in list.entries) {
        var t = RouteModel.parseRouteFromMap(x.value[1]);
        if (t != null && t.routes != null) {
          if (t.routes![0].legs![0].steps![0].travelMode == travelMode &&
              x.value[0] == school!.id) {
            temp.addEntries([x]);
          }
        }
      }
      if (temp.isNotEmpty) {
        var listt = temp.entries.toList();
        CustomBottomSheet.show(
          Get.context!,
          label: 'Saved Routes For ${TravelModeMap[travelMode]} Tavel Mode',
          child: Column(
            children: [
              ScrollConfiguration(
                behavior: MyBehavior(),
                child: SizedBox(
                  height: 200,
                  child: Center(
                    child: ListView.builder(
                      itemCount: listt.length,
                      shrinkWrap: true,
                      itemBuilder: (_, i) {
                        return Listing(
                          heigth: getSizeWrtHeight(70),
                          title: listt[i].key,
                          trailing: GetImages(
                            image: AppImages.delete,
                            onTap: () {
                              list.remove(listt[i].key);
                              temp.remove(listt[i].key);
                              sp.setString(
                                  SaveRoute.routeKey, json.encode(list));
                              Get.back();
                              if (temp.isNotEmpty) {
                                showBottomSheetForSavedRoutes(travelMode,
                                    school: school);
                              }
                            },
                          ),
                          onTap: () {
                            Get.back();
                            initiate(
                                schooll: school,
                                travelMode: travelMode,
                                response: listt[i].value[1]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              CustomButton(
                text: 'New Route',
                onTap: () async {
                  Get.back();
                  initiate(schooll: school, travelMode: travelMode);
                },
                color: const Color(0xff164B9B),
                borderColor: const Color(0xff164B9B),
                textStyle: AppFonts.poppins14White,
              ),
            ],
          ),
        );
        return;
      }
    }
    initiate(schooll: school, travelMode: travelMode);
  }

  void initiate(
      {@required SchoolModel? schooll,
      @required TravelMode? travelMode,
      dynamic response}) {
    school.value = schooll!;
    mode.value = travelMode!;
    mapController = Completer<GoogleMapController>();
    listen.value = true;
    if (!isGuest) {
      Get.back();
    }
    Get.toNamed(AppRoutes.directios);
    calculateRoute(respone: response);
  }
}
