import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class BoundsModel {
  LatLng? northeast;
  LatLng? southwest;
  BoundsModel({this.northeast, this.southwest});

  static BoundsModel parseFromMap(dynamic map) {
    try {
      return BoundsModel(
        northeast: LatLng(map['northeast']['lat'], map['northeast']['lng']),
        southwest: LatLng(map['southwest']['lat'], map['southwest']['lng']),
      );
    } catch (e) {
      log('Bound parsing ${e.toString()}');
      return BoundsModel();
    }
  }
}
