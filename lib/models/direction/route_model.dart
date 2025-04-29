// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:sro/models/direction/directions_route.dart';
import 'package:sro/pages/directions/directions_page.dart';

enum DirectionsStatus {
  OK,
  NOT_FOUND,
  ZERO_RESULTS,
  MAX_ROUTE_LENGTH_EXCEEDED,
  MAX_WAYPOINTS_EXCEEDED,
  INVALID_REQUEST,
  OVER_DAILY_LIMIT,
  OVER_QUERY_LIMIT,
  REQUEST_DENIED,
  UNKNOWN_ERROR
}

// ignore: non_constant_identifier_names
var DirectionsStatusMap = <String, DirectionsStatus>{
  'OK': DirectionsStatus.OK,
  'NOT_FOUND': DirectionsStatus.NOT_FOUND,
  'ZERO_RESULTS': DirectionsStatus.ZERO_RESULTS,
  'MAX_ROUTE_LENGTH_EXCEEDED': DirectionsStatus.MAX_ROUTE_LENGTH_EXCEEDED,
  'MAX_WAYPOINTS_EXCEEDED': DirectionsStatus.MAX_WAYPOINTS_EXCEEDED,
  'INVALID_REQUEST': DirectionsStatus.INVALID_REQUEST,
  'OVER_DAILY_LIMIT': DirectionsStatus.OVER_DAILY_LIMIT,
  'OVER_QUERY_LIMIT': DirectionsStatus.OVER_QUERY_LIMIT,
  'REQUEST_DENIED': DirectionsStatus.REQUEST_DENIED,
  'UNKNOWN_ERROR': DirectionsStatus.UNKNOWN_ERROR,
};

class RouteModel {
  DirectionsStatus? status;
  List<TravelMode?>? availableTravelModes;
  String? errorMessage;
  List<DirectionsRouteModel>? routes;

  RouteModel({
    this.availableTravelModes,
    this.errorMessage,
    this.routes,
    this.status,
  });

  static RouteModel? parseRouteFromMap(dynamic map) {
    try {
      List<TravelMode?> modes = [];
      if (map['available_travel_modes'] != null) {
        for (var x in map['available_travel_modes']) {
          modes.add(TravelModeMapReverse[x]);
        }
      }
      List<DirectionsRouteModel> routes = [];
      if (map['routes'] != null) {
        for (var x in map['routes']) {
          routes.add(DirectionsRouteModel.parseFromMap(x));
        }
      }
      return RouteModel(
          availableTravelModes: modes,
          errorMessage: map['error_message'],
          status: DirectionsStatusMap[map['status'] ?? 'OK'],
          routes: routes);
    } catch (e) {
      log('error from direction route initial ${e.toString()}');
      return null;
    }
  }
}
