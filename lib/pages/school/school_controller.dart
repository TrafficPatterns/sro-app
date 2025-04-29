import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sro/dialogs/ask_for_location.dart';
import 'package:sro/dialogs/ask_to_register.dart';
import 'package:sro/global_widgets/bottom_sheet.dart';
import 'package:sro/global_widgets/circle_container_with_image.dart';
import 'package:sro/global_widgets/dialog_box.dart';
import 'package:sro/global_widgets/listing.dart';
import 'package:sro/models/event_model.dart';
import 'package:sro/models/school_model.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/pages/directions/directions_controller.dart';
import 'package:sro/pages/directions/directions_page.dart';
import 'package:sro/pages/events/events_controller.dart';
import 'package:sro/pages/loading/loading_overlay.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/services/remote.dart';
import 'package:sro/services/validation.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../global_widgets/special_listing_widget.dart';
import '../../models/city_model.dart';

class SchoolController extends GetxController {
  var schools = <SchoolModel>[].obs;
  var allSchools = <SchoolModel>[].obs;
  final mapController = Completer<GoogleMapController>();
  var index = 0.obs;
  var guest = false.obs;
  var whichList = 0.obs;

  // for locking user in map
  var clickedOpenMap = DateTime.now();

  var mapOpen = false.obs;
  var selectedLocation = Rx<LatLng?>(null);
  var cities = <CityModel>[].obs;
  var schoolSearch = Rx<List<SchoolModel>>([]);
  var cityController = Rx<String?>(null);
  var typeController = Rx<String?>(null);
  var schoolController = Rx<String?>(null);
  var studentNameController = TextEditingController().obs;
  var studentNameError = Rx<String?>(null);
  var schoolID = ''.obs;
  var cityID = ''.obs;
  Map<String, dynamic> parsedSave = {};
  var zoomVal = 15.0.obs;
  var zoomLog = 15.0.obs;
  var legendOpen = false.obs;
  var schoolFilter = false.obs;
  var refreshController = RefreshController();

  var searchController = TextEditingController();

  // for guest filters
  var schoolGuest = Rx<String?>(null);
  var typeGuest = Rx<String?>(null);
  var cityGuest = Rx<String?>(null);

  var legends = Rx<List<bool>>(List.filled(17, true));
  var disabledPaths = ['CP', 'SD', 'EB', 'WB'];
  var diablesShapes = ['park', 'P'];
  var disabledMarkers = [
    'AW_STOP',
    'FC',
    'PW',
    'BT',
    'IC',
    'WSB',
    'BP',
    'SP',
    'TS',
    'CG',
    'MC'
  ];

  void resetLegends() {
    legends.value = List.filled(17, true);
  }

  Future<void> toggleLegend(int i, bool value) async {
    legends.value[i] = value;
    update();
    if (i > 4) {
      await resizeMarkers(
          (whichList.value == 0
                  ? schools[index.value]
                  : allSchools[index.value])
              .id!,
          zoomLog.value);
    } else {
      await hideStuff((whichList.value == 0
              ? schools[index.value]
              : allSchools[index.value])
          .id!);
    }
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    user = await UserModel().getUserFromSharedPreferences;
    if (user.isStudent) {
      schools.value = [
        SchoolModel(
            name: 'Schools',
            location: const LatLng(37.43296265331129, -122.08832357078792))
      ];

      index.value = 0;
      selectedLocation.value = schools.first.location;
      mapOpen.value = true;

      await getschools(loading: true, navigateMap: true);
    } else {
      await getschools();
    }
    if (!user.isStudent) {
      await getAllschools();
    }
    await getCities();
    await getSchool();
  }

  Future<void> getschools(
      {bool loading = false, bool navigateMap = false}) async {
    var gotBack = false;
    try {
      if (!user.isStudent) {
        mapOpen.value = false;
      }
      if (loading) {
        showDialog(
            context: Get.context!,
            builder: (_) {
              return const LoadingOverlay();
            });
      }
      var params = <String, dynamic>{};
      params['token'] = user.token;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI("user/get_schools.php", encodedData,
          ignoreAuth: true);
      var parsedRes = json.decode(res);
      if (parsedRes is List) {
        if (!user.isStudent) {
          schools.value = [];
        }
        for (var x in parsedRes) {
          var temp = SchoolModel.getSchoolModelFromMap(x);
          if (temp.archived!) {
            continue;
          }
          if (navigateMap) {
            var controller = await mapController.future;
            controller.animateCamera(CameraUpdate.newLatLng(temp.location!));
            if (loading) {
              Get.back();
              if (showD) {
                DialogBox.showCustomDialog(child: const AskLocation());
                showD = false;
              }
              gotBack = true;
            }
          }
          if (user.isStudent) {
            schools[0] = temp;
            List<dynamic> list = await getSchoolMarkers(temp.id!);
            if (list.length >= 5) {
              temp.markers = list[0];
              temp.circles = list[1];
              temp.polylines = list[2];
              temp.polygons = list[3];
              temp.events = list[4];
            }
          }
          if (!user.isStudent) {
            bool add = true;
            for (var z in schools) {
              if (z.name == temp.name) {
                add = false;
                break;
              }
            }
            if (!add) {
              temp.duplicate = true;
            }
            schools.add(temp);
          } else {
            schools[0] = temp;
          }
        }
      } else {
        log(res);
      }
      update();
    } catch (e) {
      log('$e get schools school controller');
    }
    if (loading && !gotBack) {
      Get.back();
      if (showD) {
        DialogBox.showCustomDialog(child: const AskLocation());
        showD = false;
      }
    }
  }

  Future<void> getCities() async {
    try {
      var res = await RemoteServices.getAPI("city/get_cities.php", '',
          ignoreAuth: true);
      var parsedRes = json.decode(res);
      if (parsedRes is List) {
        for (var x in parsedRes) {
          var temp = CityModel.getCityFromMap(x);
          if (!temp.archived!) {
            cities.add(temp);
          }
        }
      } else {
        log(res);
      }
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  getAllschools({String? cityID, String? type}) async {
    try {
      if (!user.isStudent) {
        mapOpen.value = false;
      }
      var params = <String, dynamic>{};
      params['cityID'] = cityID ?? '';
      params['type'] = type ?? '';
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI(
          "school/get_schools.php", encodedData,
          ignoreAuth: true);
      var parsedRes = json.decode(res);
      if (parsedRes is List) {
        allSchools.value = [];
        for (var x in parsedRes) {
          var temp = SchoolModel.getSchoolModelFromMap(x);
          if (temp.archived!) {
            continue;
          }
          bool c = true;
          for (var x in schools) {
            if (x.id == temp.id) {
              c = false;
              break;
            }
          }
          if (c) {
            allSchools.add(temp);
          }
        }
      } else {
        log(res + ' not list in get all schools');
      }
      update();
    } catch (e) {
      log('$e get All schools school controller');
    }
  }

  Future<List<dynamic>> getSchoolMarkers(String schoolID,
      {bool set = false, int? index, int? which}) async {
    try {
      var params = <String, dynamic>{};
      List<dynamic> tbr = [];
      params['schoolID'] = schoolID;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var gates = <LatLng>[];
      var res = await RemoteServices.getAPI(
          "school/get_school.php", encodedData,
          ignoreAuth: true);
      var parsedRes = json.decode(res);
      if (parsedRes['items'] != null) {
        if (isGuest) {
          parsedRes['items']['events'] = [];
        }
        var markers = parsedRes['items']['markers'];
        tbr.add(<Marker>[]);
        for (var marker in markers) {
          if (marker['markerType'] != 'G') {
            tbr[0].add(Marker(
                icon: await getIcon(marker['markerType'], scale: getScale(15)),
                markerId: MarkerId(marker['markerID']),
                position: LatLng(double.tryParse(marker['posLat']) ?? 0,
                    double.tryParse(marker['posLng']) ?? 0),
                rotation: double.tryParse(marker['rotation']) ?? 0));
          } else {
            gates.add(LatLng(double.tryParse(marker['posLat']) ?? 0,
                double.tryParse(marker['posLng']) ?? 0));
          }
        }
        var circles = parsedRes['items']['circles'];
        tbr.add(<Circle>{});
        for (var circle in circles) {
          tbr[1].add(Circle(
              circleId: CircleId(circle['circleID']),
              center: getLatLngFromDynamic(circle['center']),
              radius: double.tryParse(circle['radius']) ?? 0.0,
              strokeColor: getColor(circle['strokeColor']),
              strokeWidth: int.tryParse(circle['strokeWeight']) ?? 1,
              fillColor: getColor(circle['fillColor'])));
        }
        var polylines = parsedRes['items']['routes'];
        tbr.add(<Polyline>{});
        for (var polyline in polylines) {
          List<LatLng> points = [];
          var temp = json.decode(polyline['path']);
          for (var point in temp) {
            points.add(getLatLngFromDynamic(point));
          }
          tbr[2].add(Polyline(
            polylineId: PolylineId(polyline['routeID']),
            points: points,
            patterns:
                polyline['routeType'] == 'SD' || polyline['routeType'] == 'EB'
                    ? [PatternItem.dot, PatternItem.gap(1), PatternItem.dot]
                    : [],
            endCap: polyline['routeType'] == 'SD'
                ? Cap.customCapFromBitmap(await getIcon('SD'))
                : Cap.buttCap,
            color: getColor(polyline['strokeColor']),
          ));
        }
        var polygons = parsedRes['items']['rectangles'];
        tbr.add(<Polygon>{});
        for (var polygon in polygons) {
          List<LatLng> points = [];
          var bounds = json.decode(polygon['bounds']);
          for (var point in bounds) {
            points.add(getLatLngFromDynamic(point));
          }
          tbr[3].add(Polygon(
              polygonId: PolygonId(polygon['rectangleID']),
              points: points,
              strokeColor: getColor(polygon['strokeColor']),
              fillColor: getColor(polygon['fillColor']),
              strokeWidth: int.tryParse(polygon['strokeWeight']) ?? 1));
        }
        var events = parsedRes['items']['events'];
        tbr.add(<Event>[]);
        for (var event in events) {
          var e = Event(
              eventID: event['eventID'],
              adminId: event['userID'],
              type: EventType.values.firstWhere(
                  (e) => e.toString().split('.')[1] == event['type'],
                  orElse: () => EventType.BT),
              adminName: event['fullName'],
              title: event['title'],
              description: event['description'],
              approved: event['approved'] == '1',
              size: int.tryParse(event['size']) ?? 0,
              sizeLimit: int.tryParse(event['sizeLimit']) ?? 0,
              location: LatLng(double.parse(event['posLat']),
                  double.parse(event['posLng'])));
          tbr[4].add(e);
          tbr[0].add(Marker(
            markerId: MarkerId(e.eventID!),
            zIndex: 99999999,
            icon: await getIcon(e.type.toString().split('.').last,
                scale: getScaleEvents(15)),
            position: e.location!,
            onTap: () async {
              var eventsController = Get.put(EventsController());
              await eventsController.getExternalEvent(e.eventID!);
              Get.toNamed(AppRoutes.eventDetails);
            },
          ));
        }
      }
      if (set) {
        var temp = (which == 0 ? schools : allSchools)[index!];
        if (tbr.length >= 5) {
          temp.markers = tbr[0];
          temp.circles = tbr[1];
          temp.polylines = tbr[2];
          temp.polygons = tbr[3];
          temp.events = tbr[4];
          temp.gates = gates;
        }
        (which == 0 ? schools : allSchools)[index] = temp;
        update();
      }
      parsedSave[schoolID] = parsedRes;
      return tbr;
    } catch (e) {
      parsedSave[schoolID] = {};
      log('$e get school markers');
      if (!user.isStudent) {
        Get.back();
      }
      return [];
    }
  }

  Color getColor(dynamic value) {
    var split = (value as String).replaceAll('#', "");
    if (split.length == 6) {
      split = "ff$split";
    }
    return Color(int.parse('0x$split'));
  }

  LatLng getLatLngFromDynamic(dynamic value) {
    if (value is String) {
      var l = json.decode(value);
      return LatLng(double.tryParse((l as List).first) ?? 0.0,
          double.tryParse(l.last) ?? 0.0);
    } else {
      var l = value;
      return LatLng(double.tryParse((l as List).first) ?? 0.0,
          double.tryParse(l.last) ?? 0.0);
    }
  }

  Future<void> resizeMarkers(String schoolID, double zoom) async {
    var parsedRes = parsedSave[(whichList.value == 0
        ? schools[index.value].id!
        : allSchools[index.value].id!)];
    if (parsedRes == null) return;
    if (parsedRes['items'] != null) {
      var markers = parsedRes['items']['markers'];

      int i = 0;
      int j = 0;
      for (var marker in markers) {
        int c = 0;
        bool check = true;
        for (var d in disabledMarkers) {
          if (marker['markerType'] == d) {
            if (!legends
                .value[disabledPaths.length + diablesShapes.length + c]) {
              check = false;
              break;
            }
          }
          c++;
        }
        if ((whichList.value == 0
                    ? schools[index.value].markers
                    : allSchools[index.value].markers)
                .length >
            i) {
          if (!check) {
            (whichList.value == 0
                    ? schools[index.value].markers
                    : allSchools[index.value].markers)[i] =
                (Marker(
                    icon: await getIcon('CLR', scale: 1),
                    markerId: MarkerId(marker['markerID']),
                    position: LatLng(double.tryParse(marker['posLat']) ?? 0,
                        double.tryParse(marker['posLng']) ?? 0),
                    rotation: double.tryParse(marker['rotation']) ?? 0));
          } else {
            (whichList.value == 0
                ? schools[index.value].markers
                : allSchools[index.value]
                    .markers)[i] = (Marker(
                icon:
                    await getIcon(marker['markerType'], scale: getScale(zoom)),
                markerId: MarkerId(marker['markerID']),
                position: LatLng(double.tryParse(marker['posLat']) ?? 0,
                    double.tryParse(marker['posLng']) ?? 0),
                rotation: double.tryParse(marker['rotation']) ?? 0));
          }
        } else {
          break;
        }
        i++;
        j++;
      }
      var events = parsedRes['items']['events'];
      for (int x = 0; x < events.length; x++) {
        int c = 0;
        bool check = true;
        for (var d in disabledMarkers) {
          if (events[x]['type'] == d) {
            if (!legends
                .value[disabledPaths.length + diablesShapes.length + c]) {
              check = false;
              break;
            }
          }
          c++;
        }
        if (!check) {
          var e = (whichList.value == 0
              ? schools[index.value].events
              : allSchools[index.value].events)[i - j];
          (whichList.value == 0
              ? schools[index.value].markers
              : allSchools[index.value].markers)[i] = (Marker(
            markerId: MarkerId(e.eventID!),
            zIndex: 99999999,
            icon: await getIcon('CLR', scale: 1),
            position: e.location!,
            onTap: () async {},
          ));
        } else {
          var e = (whichList.value == 0
              ? schools[index.value].events
              : allSchools[index.value].events)[i - j];
          if (i <
              (whichList.value == 0
                      ? schools[index.value].markers
                      : allSchools[index.value].markers)
                  .length) {
            (whichList.value == 0
                ? schools[index.value].markers
                : allSchools[index.value].markers)[i] = (Marker(
              markerId: MarkerId(e.eventID!),
              icon: await getIcon(e.type.toString().split('.').last,
                  scale: getScaleEvents(zoom)),
              position: e.location!,
              zIndex: 99999999,
              onTap: () async {
                var eventsController = Get.put(EventsController());
                await eventsController.getExternalEvent(e.eventID!);
                Get.toNamed(AppRoutes.eventDetails);
              },
            ));
          } else {
            break;
          }
        }
        i++;
      }
    }
  }

  double getScale(double zoom) {
    if (zoom <= 12) {
      return zoom * 0.015;
    } else if (zoom <= 13) {
      return zoom * 0.02;
    } else if (zoom <= 14) {
      return zoom * 0.025;
    } else {
      return zoom * 0.03;
    }
  }

  double getScaleEvents(double zoom) {
    if (zoom <= 12) {
      return zoom * 0.02;
    } else if (zoom <= 13) {
      return zoom * 0.025;
    } else if (zoom <= 14) {
      return zoom * 0.03;
    } else if (zoom <= 15) {
      return zoom * 0.035;
    } else {
      return zoom * 0.04;
    }
  }

  static Future<BitmapDescriptor> getIcon(String value,
      {double scale = 1}) async {
    switch (value) {
      case 'BP':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/BP.png',
            width: 200.0 * scale,
            height: 200.0 * scale);
      case 'AW_STOP':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/AW_STOP.png',
            width: 200.0 * scale,
            height: 200.0 * scale);
      case 'BT':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/BT.png',
            width: 150.0 * scale,
            height: 250.0 * scale);
      case 'CG':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/CG.png',
            width: 125.0 * scale,
            height: 200.0 * scale);
      case 'FC':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/FC.png',
            width: 125.0 * scale,
            height: 200.0 * scale);
      case 'IC':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/IC.png',
            width: 150.0 * scale,
            height: 250.0 * scale);
      case 'MC':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/MC.png',
            width: 125.0 * scale,
            height: 200.0 * scale);
      case 'PBA':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/PBA.png',
            width: 125.0 * scale,
            height: 200.0 * scale);
      case 'PW':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/PW.png',
            width: 200.0 * scale,
            height: 200.0 * scale);
      case 'SCHOOL':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/SCHOOL.png',
            width: 200.0 * scale,
            height: 200.0 * scale);
      case 'SP':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/SP.png',
            width: 200.0 * scale,
            height: 200.0 * scale);
      case 'STOP':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/STOP.png',
            width: 200.0 * scale,
            height: 200.0 * scale);
      case 'TS':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/TS.png',
            width: 125.0 * scale,
            height: 200.0 * scale);
      case 'WSB':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/WSB.png',
            width: 150.0 * scale,
            height: 250.0 * scale);
      case 'CLR':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/clear.png',
            width: 10.0 * scale,
            height: 20.0 * scale);
      case 'SD':
        return MarkerIcon.pictureAsset(
            assetPath: 'assets/images/markers/head.png',
            width: 20.0,
            height: 20.0);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> hideStuff(String schoolID) async {
    var parsedRes = parsedSave[(whichList.value == 0
        ? schools[index.value].id!
        : allSchools[index.value].id!)];
    if (parsedRes['items'] != null) {
      var polylines = parsedRes['items']['routes'];
      var tmp = <Polyline>{};
      for (var polyline in polylines) {
        int c = 0;
        bool check = true;
        for (var d in disabledPaths) {
          if (polyline['routeType'] == d) {
            if (!legends.value[c]) {
              check = false;
              break;
            }
          }
          c++;
        }
        if (check) {
          List<LatLng> points = [];
          var temp = json.decode(polyline['path']);
          for (var point in temp) {
            points.add(getLatLngFromDynamic(point));
          }
          tmp.add(Polyline(
            polylineId: PolylineId(polyline['routeID']),
            points: points,
            patterns:
                polyline['routeType'] == 'SD' || polyline['routeType'] == 'EB'
                    ? [PatternItem.dot, PatternItem.gap(1), PatternItem.dot]
                    : [],
            endCap: polyline['routeType'] == 'SD'
                ? Cap.customCapFromBitmap(await getIcon('SD'))
                : Cap.buttCap,
            color: getColor(polyline['strokeColor']),
          ));
        }
      }
      log('${polylines.length} ${tmp.length}');
      if (whichList.value == 0) {
        schools[index.value].polylines = tmp;
      } else {
        allSchools[index.value].polylines = tmp;
      }
      var tmp2 = <Polygon>{};
      var polygons = parsedRes['items']['rectangles'];
      log(polygons.toString());
      for (var polygon in polygons) {
        int c = 0;
        bool check = true;
        for (var d in diablesShapes) {
          if (polygon['recType'] == d) {
            if (!legends.value[disabledPaths.length + c]) {
              check = false;
              break;
            }
          }
          c++;
        }
        if (check) {
          List<LatLng> points = [];
          var bounds = json.decode(polygon['bounds']);
          for (var point in bounds) {
            points.add(getLatLngFromDynamic(point));
          }
          tmp2.add(Polygon(
              polygonId: PolygonId(polygon['rectangleID']),
              points: points,
              strokeColor: getColor(polygon['strokeColor']),
              fillColor: getColor(polygon['fillColor']),
              strokeWidth: int.tryParse(polygon['strokeWeight']) ?? 1));
        }
      }
      if (whichList.value == 0) {
        schools[index.value].polygons = tmp2;
      } else {
        allSchools[index.value].polygons = tmp2;
      }
      update();
    }
  }

  Future<void> onChnagedCity(dynamic value) async {
    value = value.toString();
    cityController.value = value;
    typeController.value = null;
    schoolController.value = null;
    update();
    CityModel? city = cities.firstWhereOrNull((element) {
      if (element.name == value) {
        return true;
      }
      return false;
    });
    String id;
    if (city == null) {
      id = '';
    } else {
      id = city.cityID ?? '';
    }
    await getSchool(cityID: id);
    update();
  }

  Future<void> onChnagedType(dynamic value) async {
    value = value.toString();
    typeController.value = value;
    schoolController.value = null;
    update();
    CityModel? city = cities.firstWhereOrNull((element) {
      if (element.name == cityController.value) {
        return true;
      }
      return false;
    });
    String id;
    if (city == null) {
      id = '';
    } else {
      id = city.cityID ?? '';
    }
    await getSchool(cityID: id, type: value);
    update();
  }

  void onChnagedSchool(dynamic value) {
    value = value.toString();
    schoolController.value = value;
    update();
    SchoolModel? school = schoolSearch.value.firstWhereOrNull((element) {
      if (element.name == value) {
        return true;
      }
      return false;
    });
    String sID, cID;
    if (school == null) {
      sID = '';
      cID = '';
    } else {
      sID = school.id ?? '';
      cID = school.cityId ?? '';
    }
    log('$sID $cID');
    schoolID.value = sID;
    cityID.value = cID;
  }

  Future<void> getSchool({String? cityID, String? type}) async {
    try {
      var params = <String, dynamic>{};
      params['cityID'] = cityID ?? '';
      params['type'] = type ?? '';
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI(
          "school/get_schools.php", encodedData,
          ignoreAuth: true);
      var parsedRes = json.decode(res);
      if (parsedRes is List) {
        unfocus();
        schoolSearch.value.clear();
        for (var x in parsedRes) {
          var temp = SchoolModel.getSchoolModelFromMap(x);
          if (!temp.archived!) {
            schoolSearch.value.add(SchoolModel.getSchoolModelFromMap(x));
          }
        }
      } else {
        log(res);
      }
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  Future<void> clearFilters() async {
    schoolFilter.value = false;
    schoolController.value = null;
    typeController.value = null;
    cityController.value = null;
    await getSchool();
  }

  void search(String value) {
    value = value.trim();
    for (var x in allSchools) {
      if (value.isEmpty) {
        x.hidden = false;
        continue;
      }
      if (RegExp(value.toLowerCase()).hasMatch(x.name!.toLowerCase()) ||
          RegExp(value.toLowerCase()).hasMatch(x.cityName!.toLowerCase()) ||
          RegExp(value.toLowerCase()).hasMatch(x.type!.toLowerCase())) {
        x.hidden = false;
      } else {
        x.hidden = true;
      }
    }
    update();
  }

  Future<void> deleteStudent(
      {@required String? schoolID, @required studentName}) async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return const LoadingOverlay();
        });
    try {
      var params = <String, dynamic>{};
      params['schoolID'] = schoolID!;
      params['studentName'] = studentName!;
      params['token'] = user.token!;
      log(params.toString());
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI(
          "user/delete_student.php", encodedData,
          ignoreAuth: true);
      var parsedRes = json.decode(res);
      await getschools();
      showToas(parsedRes['message'].toString());
      var ec = Get.put(EventsController());
      await ec.getEvents();
      ec.update();
    } catch (e) {
      log(e.toString());
    }
    Get.back();
    update();
  }

  Future<void> addStudent({String? schoolID, String? studentName = ''}) async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return const LoadingOverlay();
        });
    try {
      if (studentName!.isEmpty) {
        var i = 1;
        for (var x in schools) {
          List split = x.studentName!.split(' ').map((e) => e.trim()).toList();
          if (split.length == 2 &&
              split[0] == 'Student' &&
              int.tryParse(split[1]) != null &&
              int.parse(split[1]) == i) {
            i++;
          }
        }
        studentName = 'Student $i';
      }
      var params = <String, dynamic>{};
      params['schoolID'] = schoolID ?? this.schoolID.value;
      params['studentName'] = studentName;
      params['token'] = user.token!;
      log(params.toString());
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI("user/add_student.php", encodedData,
          ignoreAuth: true);
      var parsedRes = json.decode(res);
      await getschools();
      showToas(parsedRes['message'].toString());
    } catch (e) {
      log(e.toString());
    }
    Get.back();
    update();
  }

  void onChangeName(value) {
    studentNameError.value = ValidateAddItem.validateName(value);
  }

  Future<void> clearfilters() async {
    // when adding students
    cityController.value = null;
    studentNameController.value.clear();
    typeController.value = null;
    schoolController.value = null;
    await getSchool();
  }

  Future<void> takeMeToMaps() async {
    SchoolModel school =
        whichList.value == 0 ? schools[index.value] : allSchools[index.value];
    CustomBottomSheet.show(
      Get.context!,
      label: school.name,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(height: getSizeWrtHeight(10)),
          Center(
            child: Text(
              'How do you plan on going there?',
              style: AppFonts.poppins14Black,
            ),
          ),
          SizedBox(height: getSizeWrtHeight(20)),
          Listing(
            title: 'By Bike',
            trailing: const CircleImage(eventType: EventType.BT, size: 40),
            heigth: getSizeWrtHeight(90),
            onTap: () {
              var dc = Get.put(DirectionsController());
              dc.showBottomSheetForSavedRoutes(TravelMode.bike, school: school);
              Get.back();
            },
          ),
          Listing(
            title: 'By Car',
            trailing: const CircleImage(eventType: EventType.IC, size: 40),
            heigth: getSizeWrtHeight(90),
            onTap: () {
              var dc = Get.put(DirectionsController());
              dc.showBottomSheetForSavedRoutes(TravelMode.car, school: school);
              Get.back();
            },
          ),
          Listing(
            title: 'By Foot',
            trailing: const CircleImage(
              eventType: EventType.walking,
              size: 40,
              iconPadding: EdgeInsets.all(5),
            ),
            heigth: getSizeWrtHeight(90),
            onTap: () async {
              var dc = Get.put(DirectionsController());
              dc.showBottomSheetForSavedRoutes(TravelMode.walking,
                  school: school);
              Get.back();
            },
          )
        ],
      ),
    );
  }

  static List<SchoolModel> getSchoolSearch(List<SchoolModel> schools) {
    List<String> schoolnames = [];
    List<SchoolModel> filteredSchools = [];
    for (var x in schools) {
      if (!schoolnames.contains(x.name)) {
        schoolnames.add(x.name!);
        filteredSchools.add(x);
      }
    }
    return filteredSchools;
  }

  Future<void> onRefresh() async {
    unfocus();
    searchController.clear();
    typeGuest.value = null;
    cityGuest.value = null;
    await getschools();
    getAllschools();
    refreshController.refreshCompleted();
  }

  Future<void> openMap({int? whichlist, int? i}) async {
    whichList.value = whichlist!;
    index.value = i!;
    mapOpen.value = true;
    clickedOpenMap = DateTime.now();
    if (isGuest) {
      DialogBox.showCustomDialog(child: const AskRegister());
    }
    await getSchoolMarkers((whichlist == 0 ? schools[i] : allSchools[i]).id!,
        set: true, which: whichlist, index: i);
    update();
  }

  Future<void> onChangeCityGuest(dynamic value) async {
    value = value.toString();
    cityGuest.value = value;
    typeGuest.value = null;
    update();
    CityModel? city = cities.firstWhereOrNull((element) {
      if (element.name == value) {
        return true;
      }
      return false;
    });
    String? id;
    if (city == null) {
      id = null;
    } else {
      id = city.cityID;
    }
    await getAllschools(cityID: id);
    update();
  }

  Future<void> onChangeTypeGuest(dynamic value) async {
    value = value.toString();
    typeGuest.value = value;
    update();
    CityModel? city = cities.firstWhereOrNull((element) {
      if (element.name == cityGuest.value) {
        return true;
      }
      return false;
    });
    String? id;
    if (city == null) {
      id = null;
    } else {
      id = city.cityID;
    }
    await getAllschools(cityID: id, type: value);
    update();
  }
}
