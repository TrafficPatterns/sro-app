import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:sro/global_widgets/special_listing_widget.dart';
import 'package:sro/models/event_member.dart';
import 'package:sro/models/hour.dart';
import 'package:sro/models/message_model.dart';

import '../services/global_functions.dart';

class Event {
  String? adminId;
  String? eventID;
  String? title;
  String? adminName;
  String? description;
  EventType? type;
  bool? approved;
  int? sizeLimit;
  int? size;
  bool? isRoundTrip;
  LatLng? location;
  int? allParents;
  int? allStudents;
  String? schoolID;
  int? total;
  int offset;
  List<MessageModel>? messages = [];
  List<EventMemberModel> eventMembers;
  List<EventMemberModel> waitListedMembers;

  int activeNotifications;
  bool? hasCustomSchedule;
  List<HourFormatter?> schedule = [
    null,
    null,
    null,
    null,
    null,
  ];
  Event(
      {this.hasCustomSchedule,
      this.location,
      this.activeNotifications = 0,
      this.adminId,
      this.adminName,
      this.approved = false,
      this.eventID,
      this.isRoundTrip = false,
      this.size,
      this.schoolID,
      this.sizeLimit,
      this.title,
      this.offset = 0,
      this.type,
      this.description,
      this.eventMembers = const [],
      this.messages,
      this.waitListedMembers = const []});
  // void setHour(int day, HourFormatter time) {
  //   schedule[day] = time;
  // }

  void setSchedule(List<HourFormatter?> schedule) {
    if (schedule.length < 5) {
      log('Error in add schedule passed list is too short');
      return;
    }
    this.schedule = schedule;
  }

  static Event getEventFromMap(dynamic map) {
    Event event = Event(
      eventID: map['eventID'],
      adminId: map['adminID'],
      adminName: map['adminName'],
      title: HtmlCharacterEntities.decode(map['title'] ?? ''),
      type: EventType.values.firstWhere(
          (e) => e.toString().split('.')[1] == map['type'],
          orElse: () => EventType.BT),
      approved: int.parse(map['approved'] ?? 0) == 1,
      description: HtmlCharacterEntities.decode(map['description'] ?? ''),
      size: int.parse(map['size'] ?? 0),
      sizeLimit: int.parse(map['sizeLimit'] ?? 0),
      isRoundTrip: int.parse(map['isRoundTrip'] ?? 0) == 1,
      schoolID: map['schoolID'] ?? '0',
      location:
          LatLng(double.parse(map['posLat']), double.parse(map['posLng'])),
    );
    if (map['members'] != null) {
      var temp = <EventMemberModel>[];
      int parent = 0, student = 0, total = 0;
      for (var x in map['members']) {
        parent += int.tryParse(x['parentsCount']) ?? 0;
        student += int.tryParse(x['studentsCount']) ?? 0;
        EventMemberModel eventMemberModel =
            EventMemberModel.getEventMemberFromMap(x);
        temp.add(eventMemberModel);
      }
      total = student + parent;
      event.total = total;
      event.allStudents = student;
      event.allParents = parent;
      event.eventMembers = temp;
    }
    if (map['waitlist'] != null) {
      var temp = <EventMemberModel>[];
      for (var x in map['waitlist']) {
        EventMemberModel eventMemberModel =
            EventMemberModel.getEventMemberFromMap(x);
        temp.add(eventMemberModel);
      }
      event.waitListedMembers = temp;
    }
    var schedule = <HourFormatter?>[
      getTimeFromString(map['monday']),
      getTimeFromString(map['tuesday']),
      getTimeFromString(map['wednesday']),
      getTimeFromString(map['thursday']),
      getTimeFromString(map['friday'])
    ];
    event.hasCustomSchedule = false;
    for (int i = 1; i < schedule.length; i++) {
      if (schedule[i] == null || schedule[i - 1] == null) {
        if (schedule[i] != null || schedule[i - 1] != null) {
          event.hasCustomSchedule = true;
          break;
        }
      } else {
        if (!HourFormatter.compare(schedule[i]!, schedule[i - 1]!)) {
          event.hasCustomSchedule = true;
          break;
        }
      }
    }
    event.setSchedule(schedule);
    return event;
  }
}
