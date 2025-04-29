import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sro/models/event_model.dart';

class SchoolModel {
  String? id;
  String? name;
  String? cityId;
  String? studentName;
  String? cityName;
  String? type;
  bool? archived;
  LatLng? location;
  List<LatLng> gates = [];
  bool? hidden;
  List<Marker> markers = [];
  Set<Circle> circles = {};
  Set<Polygon> polygons = {};
  Set<Polyline> polylines = {};
  List<Event> events = [];
  bool? duplicate;
  SchoolModel(
      {this.cityId,
      this.cityName,
      this.id,
      this.type,
      this.name,
      this.studentName,
      this.archived = false,
      this.location,
      this.hidden = false,
      this.duplicate = false});
  static SchoolModel getSchoolModelFromMap(dynamic map) {
    return SchoolModel(
        cityId: map['cityID'] ?? '',
        cityName: map['cityName'] ?? '',
        id: map['schoolID'] ?? '',
        name: map['name'] ?? '',
        type: map['type'] ?? '',
        archived: map['archived'] != null
            ? (map['archived'].toString() == '1')
            : false,
        studentName: map['studentName'] ?? '',
        location: (map['posLat'] != null && map['posLng'] != null)
            ? LatLng(double.parse(map['posLat']), double.parse(map['posLng']))
            : null);
  }
}
