import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sro/models/direction/textvalue.dart';
import 'package:sro/pages/directions/directions_page.dart';
import 'package:sro/services/global_functions.dart';

class DirectionsStepModel {
  TextValue? duration;
  LatLng? endLocation;
  String? htmlInstructions;
  List<LatLng>? polyline;
  LatLng? startLocation;
  TravelMode? travelMode;
  TextValue? distance;
  String? maneuver;
  DirectionsStepModel? steps;

  DirectionsStepModel(
      {this.distance,
      this.duration,
      this.endLocation,
      this.htmlInstructions,
      this.maneuver,
      this.polyline,
      this.startLocation,
      this.steps,
      this.travelMode});
  static DirectionsStepModel parseStep(dynamic map) {
    try {
      var endLocation =
          LatLng(map['end_location']['lat'], map['end_location']['lng']);
      var startLocation =
          LatLng(map['start_location']['lat'], map['start_location']['lng']);
      return DirectionsStepModel(
          duration: TextValue.parseTextValue(map['duration']),
          endLocation: endLocation,
          startLocation: startLocation,
          htmlInstructions: map['html_instructions'],
          polyline: polyLineParser(map['polyline']['points']),
          travelMode: TravelModeMapReverse[map['travel_mode']],
          distance: TextValue.parseTextValue(map['distance']),
          maneuver: map['maneuver'],
          steps: map['steps'] == null
              ? null
              : DirectionsStepModel.parseStep(map['steps']));
    } catch (e) {
      log('error from parse step ${e.toString()}');
      return DirectionsStepModel();
    }
  }
}
