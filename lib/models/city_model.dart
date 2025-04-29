import 'package:google_maps_flutter/google_maps_flutter.dart';

class CityModel {
  String? cityID;
  String? name;
  bool? archived;
  LatLng? location;

  CityModel({this.archived = false, this.cityID, this.location, this.name});

  static CityModel getCityFromMap(dynamic map) {
    return CityModel(
      cityID: map['cityID'],
      location:
          LatLng(double.parse(map['posLat']), double.parse(map['posLng'])),
      name: map['name'],
      archived:
          map['archived'] != null ? map['archived'].toString() == '1' : false,
    );
  }
}
