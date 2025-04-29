import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sro/models/direction/directions_step.dart';
import 'package:sro/models/direction/textvalue.dart';
import 'package:sro/models/direction/time_zone_value.dart';

class DirectionsLegModel {
  String? endAddress;
  LatLng? endLocation;

  String? startAddress;
  LatLng? startLocation;

  List<DirectionsStepModel>? steps;
  TimeZoneTextValueObject? arrivalTime;
  TimeZoneTextValueObject? departureTime;
  TextValue? distance;
  TextValue? duration;
  TextValue? durationInTraffic;

  DirectionsLegModel(
      {this.arrivalTime,
      this.departureTime,
      this.distance,
      this.duration,
      this.durationInTraffic,
      this.endAddress,
      this.endLocation,
      this.startAddress,
      this.startLocation,
      this.steps});

  static DirectionsLegModel getLegFromMap(dynamic map) {
    try {
      var endLocation =
          LatLng(map['end_location']['lat'], map['end_location']['lng']);

      var startLocation =
          LatLng(map['start_location']['lat'], map['start_location']['lng']);

      List<DirectionsStepModel> steps = [];
      for (var x in map['steps']) {
        steps.add(DirectionsStepModel.parseStep(x));
      }
      return DirectionsLegModel(
        endAddress: map['end_address'],
        endLocation: endLocation,
        startAddress: map['start_address'],
        startLocation: startLocation,
        departureTime:
            TimeZoneTextValueObject.parseTimeZone(map['departure_time']),
        arrivalTime: TimeZoneTextValueObject.parseTimeZone(map['arrival_time']),
        distance: TextValue.parseTextValue(map['distance']),
        duration: TextValue.parseTextValue(map['duration']),
        durationInTraffic: TextValue.parseTextValue(map['duration_in_traffic']),
        steps: steps,
      );
    } catch (e) {
      log('error from parse leg ${e.toString()}');
      return DirectionsLegModel();
    }
  }
}
