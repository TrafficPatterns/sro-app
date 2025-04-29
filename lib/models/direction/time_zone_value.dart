import 'dart:developer';

class TimeZoneTextValueObject {
  String? timeZone;
  String? text;
  DateTime? time;

  TimeZoneTextValueObject({this.text, this.time, this.timeZone});

  static TimeZoneTextValueObject? parseTimeZone(dynamic map) {
    if (map == null) {
      return null;
    }
    try {
      return TimeZoneTextValueObject(
          text: map['text'],
          time: DateTime.fromMillisecondsSinceEpoch(map['value'] * 1000),
          timeZone: map['time_zone']);
    } catch (e) {
      log('error from parse time zone ${e.toString()}');
      return null;
    }
  }
}
