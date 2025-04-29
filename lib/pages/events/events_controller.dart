import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sro/models/event_model.dart';
import 'package:sro/pages/loading/loading_overlay.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:web_socket_channel/io.dart';

import '../../global_widgets/special_listing_widget.dart';
import '../../models/hour.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../services/remote.dart';

class EventsController extends GetxController {
  late IOWebSocketChannel channel;

  // for locking user in
  var clickedOnCreate = DateTime.now();

  //focus nodes
  var eventTitleFocus = FocusNode();
  var eventDescriptionFocus = FocusNode();
  var selectedSchoolNameFocus = FocusNode();
  var numberOfAdultsFocus = FocusNode();
  var numberOfStudentsFocus = FocusNode();
  var eventSizeFocus = FocusNode();
  var days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];
  var refreshController = RefreshController();
  // For openning chats of a given event based on index
  var currentMessageList = (0).obs;
  var active = ''.obs;

  // for editing events
  var edit = false.obs;

  // for openning an external event
  var exEvent = Rx<Event?>(null);

  // For Sending Messages
  var message = ''.obs;
  var textController = TextEditingController().obs;

  // For Event Creation
  var parentName = TextEditingController().obs;
  var eventTitle = TextEditingController().obs;
  var eventDescription = TextEditingController().obs;
  var selectedSchoolName = Rx<String?>(null);
  var hasSchedule = false.obs;
  var location = Rx<LatLng?>(null);
  var icon = Rx<BitmapDescriptor>(BitmapDescriptor.defaultMarker);
  var eventType = Rx<EventType?>(null);
  var everydayTime = HourFormatter().obs;
  var numberOfAdults = TextEditingController().obs;
  var numberOfStudents = TextEditingController().obs;
  var eventSize = TextEditingController().obs;
  var roundTrip = RxBool(false);
  var schedule = <HourFormatter?>[
    null,
    null,
    null,
    null,
    null,
  ].obs;
  var check = [
    false,
    false,
    false,
    false,
    false,
  ].obs;
  void updateCheck(int index, bool value) {
    check[index] = value;
  }

  bool get validateFields {
    bool s = false;
    if (hasSchedule.value) {
      int i = 0;
      for (var x in schedule) {
        if (x != null && check[i] == true) {
          s = true;
        }
        i++;
      }
    } else {
      if (everydayTime.value.validate) {
        s = true;
      }
    }
    if (parentName.value.text.trim().isNotEmpty &&
        eventTitle.value.text.trim().isNotEmpty &&
        location.value != null &&
        selectedSchoolName.value != null &&
        s) {
      return true;
    }
    return false;
  }

  void onRoundTripChanged(bool value) {
    roundTrip.value = value;
  }

  Future<dynamic> addEvent(EventType eventType) async {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return const LoadingOverlay();
        });
    try {
      var event = Event(
          title: eventTitle.value.text,
          location: location.value,
          hasCustomSchedule: hasSchedule.value,
          description: eventDescription.value.text,
          type: eventType,
          approved: false,
          sizeLimit: int.tryParse(eventSize.value.text),
          isRoundTrip: roundTrip.value,
          messages: [],
          adminId: user.userID,
          adminName: user.getFullName());
      if (hasSchedule.value) {
        event.setSchedule(schedule);
      } else {
        List<HourFormatter?> temp = List.filled(5, everydayTime.value);
        event.setSchedule(temp);
      }
      var response = await uploadEvent(event);
      if (response['status'] == 'success') {
        if (!edit.value) {
          var schoolController = Get.put(SchoolController());
          await schoolController.getschools();
          if (!user.isStudent) {
            schoolController.mapOpen.value = false;
          }
          event.eventID = response['data']['eventID'];
          eventsList.add(event);
        } else {
          for (int i = 0; i < eventsList.length; i++) {
            if (eventsList[i].eventID == exEvent.value!.eventID) {
              await getExternalEvent(exEvent.value!.eventID!);
              var t = eventsList[i];
              eventsList[i] = exEvent.value!;
              eventsList[i].messages = t.messages;
              break;
            }
          }
        }
        update();
      }
      Get.back();
      return response;
    } catch (e) {
      Get.back();
      log(e.toString());
      return {'status': 'Error', 'message': 'Something went wrong'};
    }
  }

  Future<dynamic> uploadEvent(Event event) async {
    var schoolController = Get.put(SchoolController());
    String schoolID = '';
    for (var x in schoolController.schools) {
      if (x.name == selectedSchoolName.value) {
        schoolID = x.id!;
      }
    }
    var params = <String, dynamic>{};
    params['description'] = event.description;
    params['fullName'] = user.getFullName();
    params['isRoundTrip'] = roundTrip.value ? '1' : '0';
    params['parentsCount'] =
        numberOfAdults.value.text.isEmpty ? '0' : numberOfAdults.value.text;
    params['posLat'] = location.value!.latitude.toString();
    params['posLng'] = location.value!.longitude.toString();
    params['schoolID'] = schoolID;
    params['sizeLimit'] =
        eventSize.value.text.isEmpty ? '-1' : eventSize.value.text;
    params['studentsCount'] =
        numberOfStudents.value.text.isEmpty ? '0' : numberOfStudents.value.text;
    params['title'] = event.title;
    params['type'] = event.type!.toString().split('.')[1];
    params['userID'] = user.userID;
    params['action'] = edit.value ? 'update' : 'create';
    params['token'] = user.token;
    if (edit.value) {
      params['eventID'] = exEvent.value!.eventID!;
    }
    int i = 0;
    if (hasSchedule.value) {
      for (var element in schedule) {
        if (check[i] == false) {
          params[days[i]] = '';
        } else {
          params[days[i]] = getStringFromTime(element);
        }
        i++;
      }
    } else {
      for (var element in List.filled(5, everydayTime.value)) {
        params[days[i]] = getStringFromTime(element);
        i++;
      }
    }
    try {
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res =
          await RemoteServices.getAPI("event/edit_event.php", encodedData);
      var parsedRes = json.decode(res);
      return parsedRes;
    } catch (e) {
      log(e.toString());
      return {'status': 'Error', 'message': 'Something went wrong'};
    }
  }

  Future<void> clearEventCreationFields() async {
    edit.value = false;
    parentName.value.clear();
    eventTitle.value.clear();
    eventSize.value.clear();
    numberOfAdults.value.clear();
    numberOfStudents.value.clear();
    selectedSchoolName.value = null;
    eventType.value = null;
    eventDescription.value.clear();
    if (!user.isStudent) {
      location.value = null;
    } else {
      var sc = Get.put(SchoolController());
      sc.getSchoolMarkers(sc.schools.first.id!, set: true, which: 0, index: 0);
      if (sc.schools.isNotEmpty) {
        location.value = sc.schools.first.location;
      }
    }
    hasSchedule.value = false;
    everydayTime.value = HourFormatter();
    schedule.value = <HourFormatter?>[null, null, null, null, null];
    check.value = [false, false, false, false, false];
  }

  var eventsList = <Event>[].obs;
  @override
  void onInit() async {
    channel = IOWebSocketChannel.connect(Uri.parse('ws://138.68.27.132:6969'));
    channel.stream.listen((message) {
      var str = String.fromCharCodes(message);
      var data = json.decode(str);
      int i = 0;
      for (var x in eventsList) {
        if (x.eventID.toString() == data['eventID'].toString()) {
          var messageModel = MessageModel(
            fromMe: data['userID'] == user.userID,
            senderName: data['user'] ?? '',
            text: HtmlCharacterEntities.decode(data['message'] ?? ''),
            userID: (data['userID'] ?? '').toString(),
            dateSent: data['date'] == null
                ? DateTime.now()
                : DateTime.tryParse(data['date']) ?? DateTime.now(),
          );
          var temp = eventsList[i];
          if (!(active.value == temp.eventID)) {
            temp.activeNotifications++;
          }
          temp.messages = temp.messages ?? [];
          temp.messages!.insert(0, messageModel);
          temp.messages!.sort(
            (a, b) {
              if (a.dateSent!.difference(b.dateSent!).isNegative) {
                return 1;
              }
              return -1;
            },
          );
          if (active.value.isEmpty) {
            eventsList.remove(x);
            eventsList.insert(0, temp);
          } else {
            eventsList[i] = temp;
          }
          update();
        }
        i++;
      }
    }, onDone: () {
      log('jaja');
    }, onError: (error) {
      log('$error   hhahaha');
    });
    await getEvents();
    if (user.isStudent) {
      var schoolController = Get.put(SchoolController());
      if (schoolController.schools.isNotEmpty) {
        location.value = schoolController.schools.first.location;
        selectedSchoolName.value = schoolController.schools.first.name;
      }
    }
    super.onInit();
  }

  Future<void> getEvents() async {
    final user = await UserModel().getUserFromSharedPreferences;
    var params = <String, dynamic>{};
    params['token'] = user.token;
    var data = json.encode(params);
    var encodedData = Uri.encodeComponent(data);
    var res = await RemoteServices.getAPI("user/get_events.php", encodedData);
    if (res is! String) {
      return;
    }
    var parsedRes = json.decode(res);
    if (parsedRes is List) {
      int i = 0;
      eventsList.value = <Event>[];
      for (var x in parsedRes) {
        eventsList.add(Event.getEventFromMap(x));
        await getMessagesForEvent(index: i);
        i++;
      }
      sortList();
    } else {
      log(res);
    }
    update();
  }

  void sortList() {
    eventsList.sort((e1, e2) {
      if (e1.messages!.isEmpty && e2.messages!.isNotEmpty) {
        return 1;
      } else if (e1.messages!.isNotEmpty && e2.messages!.isEmpty) {
        return -1;
      } else if (e1.messages!.isEmpty && e2.messages!.isEmpty) {
        return 0;
      } else {
        if (e1.messages!.first.dateSent!
            .isAfter(e2.messages!.first.dateSent!)) {
          return -1;
        } else {
          return 1;
        }
      }
    });
    update();
  }

  void addMessage(MessageModel messageModel) {
    var temp = eventsList[currentMessageList.value];
    temp.messages = temp.messages ?? [];
    temp.messages!.insert(0, messageModel);
    temp.messages!.sort(
      (a, b) {
        if (a.dateSent!.difference(b.dateSent!).isNegative) {
          return 1;
        }
        return -1;
      },
    );
    eventsList[currentMessageList.value] = temp;
    sendMessage(messageModel.text!);
  }

  void onChangedMessage(String value) {
    message.value = value.trim();
  }

  Future<void> getMessagesForEvent({int? index, int? offset}) async {
    int i = index ?? currentMessageList.value;
    if (i >= eventsList.length || eventsList[i].eventID == null) return;
    eventsList[i].messages = eventsList[i].messages ?? [];
    final user = await UserModel().getUserFromSharedPreferences;
    var params = <String, dynamic>{};
    params['token'] = user.token;
    params['eventID'] = eventsList[i].eventID;
    params['offset'] = offset ?? 0;
    var data = json.encode(params);
    var encodedData = Uri.encodeComponent(data);
    var res =
        await RemoteServices.getAPI("event/get_messages.php", encodedData);

    var parsedRes = json.decode(res);
    if (parsedRes is List) {
      if (eventsList[i].offset == 0) {
        eventsList[i].messages = [];
      }
      var temp = eventsList[i];
      temp.messages = temp.messages ?? [];
      for (var x in parsedRes) {
        temp.messages!.add(await MessageModel.getMessageModelFromMap(x));
      }
      temp.messages!.sort(
        (a, b) {
          if (a.dateSent!.difference(b.dateSent!).isNegative) {
            return 1;
          }
          return -1;
        },
      );
      eventsList[i] = temp;
    } else {
      log(res);
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      int i = currentMessageList.value;
      if (i >= eventsList.length) return;
      final user = await UserModel().getUserFromSharedPreferences;
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['eventID'] = eventsList[currentMessageList.value].eventID;
      params['message'] = message;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      await RemoteServices.getAPI("event/send_message.php", encodedData);
      var param2 = <String, dynamic>{};

      param2['user'] = user.getFullName();
      param2['userID'] = user.userID!;
      param2['eventID'] = eventsList[currentMessageList.value].eventID!;
      param2['message'] = message;
      var now = DateTime.now();
      param2['date'] =
          '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';
      var data2 = json.encode(param2);
      channel.sink.add(data2);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> joinEvent(String? eventID,
      {String? pCount, String? sCount, String? size}) async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return const LoadingOverlay();
        });
    try {
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['action'] = 'join';
      params['eventID'] = eventID;
      params['userID'] = user.userID;
      params['parentsCount'] = pCount!.isEmpty ? '0' : pCount;
      params['studentsCount'] = sCount!.isEmpty ? '0' : sCount;
      params['size'] = size!.isEmpty ? '0' : size;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var response =
          await RemoteServices.getAPI("event/edit_event.php", encodedData);
      var parsedResponse = json.decode(response);
      if (parsedResponse['message'] != null) {
        if (parsedResponse['status'] == 'success') {
          var s = Get.put(SchoolController());
          if (user.isStudent) {
            await s.getschools();
          }
          getEvents();
        }
        Get.back();
        return parsedResponse;
      }
      Get.back();
      return {'status': 'error', 'message': 'Something went wrong'};
    } catch (e) {
      Get.back();
      log('$e join event');
      return {'status': 'error', 'message': 'Something went wrong'};
    }
  }

  Future<dynamic> leaveDeleteEvent(String eventID, String action) async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return const LoadingOverlay();
        });
    try {
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['action'] = action;
      params['eventID'] = eventID;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var response =
          await RemoteServices.getAPI("event/edit_event.php", encodedData);
      var parsedResponse = json.decode(response);
      if (parsedResponse['message'] != null) {
        if (parsedResponse['status'] == 'success') {
          await getEvents();
          if (action == 'delete') {
            var school = Get.put(SchoolController());
            if (user.isStudent) {
              school.getSchoolMarkers(school.schools.first.id!,
                  set: true, which: 0, index: 0);
            } else {
              school.mapOpen.value = false;
            }
          }
        }
        Get.back();
        return parsedResponse;
      }
      Get.back();
      return {'status': 'error', 'message': 'Something went wrong'};
    } catch (e) {
      Get.back();
      log('$e levae delete event');
      return {'status': 'error', 'message': 'Something went wrong'};
    }
  }

  Future<dynamic> makeAdmin(String? eventID, String? userID) async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return const LoadingOverlay();
        });
    try {
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['action'] = 'promote';
      params['eventID'] = eventID;
      params['userID'] = userID;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var response =
          await RemoteServices.getAPI("event/edit_event.php", encodedData);
      var parsedResponse = json.decode(response);
      Get.back();
      if (parsedResponse['message'] != null) {
        return parsedResponse;
      }
      return {'status': 'error', 'message': 'Something went wrong'};
    } catch (e) {
      log('$e promote from event');
      Get.back();
      return {'status': 'error', 'message': 'something went wrong'};
    }
  }

  Future<dynamic> kickFromEvent(String? eventID, String? userID) async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return const LoadingOverlay();
        });
    try {
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['action'] = 'kick';
      params['eventID'] = eventID;
      params['userID'] = userID;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var response =
          await RemoteServices.getAPI("event/edit_event.php", encodedData);
      var parsedResponse = json.decode(response);
      if (parsedResponse['message'] != null) {
        if (parsedResponse['status'] == 'success') {
          getEvents();
        }
        Get.back();
        return parsedResponse;
      }
      Get.back();
      return {'status': 'error', 'message': 'Something went wrong'};
    } catch (e) {
      log('$e kick from event');
      Get.back();
      return {'status': 'error', 'message': 'Something went wrong'};
    }
  }

  Future<void> getExternalEvent(String id) async {
    try {
      final user = await UserModel().getUserFromSharedPreferences;
      var params = <String, dynamic>{};
      params['token'] = user.token;
      params['eventID'] = id;
      var data = json.encode(params);
      var encodedData = Uri.encodeComponent(data);
      var res = await RemoteServices.getAPI("event/get_event.php", encodedData);
      var parsedRes = json.decode(res);
      exEvent.value = Event.getEventFromMap(parsedRes);
      icon.value = await SchoolController.getIcon(
          exEvent.value!.type.toString().split('.').last,
          scale: 0.5);
    } catch (e) {
      log('$e error from get external event');
    }
  }

  Future<void> getDataReadyForEdit() async {
    var s = Get.put(SchoolController());
    var schools = s.schools;
    var school = schools.firstWhereOrNull((element) {
      if (element.id == exEvent.value!.schoolID) {
        return true;
      }
      return false;
    });
    roundTrip.value = exEvent.value!.isRoundTrip!;
    selectedSchoolName.value = school!.name;
    parentName.value.text = exEvent.value!.adminName!;
    eventTitle.value.text = exEvent.value!.title!;
    if (exEvent.value!.type == EventType.IC) {
      eventSize.value.text = '${exEvent.value!.sizeLimit}';
    } else {
      String nS = '', nP = '';
      for (var x in exEvent.value!.eventMembers) {
        if (x.userID == user.userID) {
          nS = '${x.studentCount}';
          nP = '${x.parentCount}';
        }
      }
      numberOfAdults.value.text = nP;
      numberOfStudents.value.text = nS;
    }
    eventDescription.value.text = exEvent.value!.description!;
    hasSchedule.value = exEvent.value!.hasCustomSchedule!;
    if (!hasSchedule.value) {
      var t = exEvent.value!.schedule[0]!;
      everydayTime.value =
          HourFormatter(amPm: t.amPm, hour: t.hour, minute: t.minute);
    } else {
      int i = 0;
      for (var x in exEvent.value!.schedule) {
        if (x != null) {
          check[i] = true;
        } else {
          check[i] = false;
        }
        i++;
      }
      schedule.value = exEvent.value!.schedule;
    }
    edit.value = true;
    location.value = exEvent.value!.location;
    eventType.value = exEvent.value!.type;
  }

  Future<void> onRefresh() async {
    await getEvents();
    if (user.isStudent) {
      var schoolController = Get.put(SchoolController());
      if (schoolController.schools.isNotEmpty) {
        location.value = schoolController.schools.first.location;
        selectedSchoolName.value = schoolController.schools.first.name;
      }
    }
    refreshController.refreshCompleted();
  }
}
