import 'package:html_character_entities/html_character_entities.dart';
import 'package:intl/intl.dart';
import 'package:sro/models/user_model.dart';

class MessageModel {
  String? text;
  String? userID;
  bool fromMe;
  String? senderId;
  String? senderName;
  DateTime? dateSent = DateTime.now();
  MessageModel(
      {this.dateSent,
      this.fromMe = true,
      this.userID,
      this.senderName,
      this.text});

  String get getFormattedDate {
    final now = DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, dateSent!.hour, dateSent!.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  static Future<MessageModel> getMessageModelFromMap(dynamic map) async {
    final user = await UserModel().getUserFromSharedPreferences;
    return MessageModel(
        dateSent: DateTime.tryParse(map['time']) ?? DateTime.now(),
        fromMe: user.userID == map['userID'],
        senderName: '${map['firstName']} ${map['lastName']}',
        text: map['message'] == null
            ? map['message']
            : HtmlCharacterEntities.decode(map['message']),
        userID: map['userID']);
  }
}
