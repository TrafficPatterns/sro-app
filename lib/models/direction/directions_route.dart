import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sro/models/direction/bounds.dart';
import 'package:sro/models/direction/directions_leg.dart';
import 'package:sro/services/global_functions.dart';

class DirectionsRouteModel {
  BoundsModel? bounds;
  List<DirectionsLegModel>? legs;
  List<LatLng>? overviewPolyline;
  String? summary;
  List<String>? warnings;

  DirectionsRouteModel(
      {this.bounds,
      this.legs,
      this.overviewPolyline,
      this.summary,
      this.warnings});

  static DirectionsRouteModel parseFromMap(dynamic map) {
    try {
      List<DirectionsLegModel> legs = [];
      for (var x in map['legs']) {
        legs.add(DirectionsLegModel.getLegFromMap(x));
      }
      List<String> warnings = [];
      for (var x in map['warnings']) {
        warnings.add(x.toString());
      }
      return DirectionsRouteModel(
        bounds: BoundsModel.parseFromMap(map['bounds']),
        overviewPolyline: polyLineParser(map['overview_polyline']['points']),
        summary: map['summary'],
        warnings: warnings,
        legs: legs,
      );
    } catch (e) {
      log('error from parse route ${e.toString()}');
      return DirectionsRouteModel();
    }
  }
}
