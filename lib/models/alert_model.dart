import 'package:html_character_entities/html_character_entities.dart';
import 'package:sro/models/file_model.dart';

class AlertModel {
  String? subject;
  String? message;
  String? notificationID;
  DateTime? date;
  bool? isRead;
  bool? isFromAdmin;
  String? senderName;
  String? senderID;
  List<FileModel> files;
  AlertModel(
      {this.date,
      this.isFromAdmin,
      this.isRead,
      this.message,
      this.senderName,
      this.notificationID,
      this.subject,
      this.senderID,
      this.files = const []});

  static AlertModel getModelFromMap(dynamic map) {
    var temp = <FileModel>[];
    if (map['files'] != null) {
      for (var x in map['files']) {
        temp.add(FileModel.getFileFromMap(x));
      }
    }
    return AlertModel(
        date: DateTime.tryParse(map['date']),
        isFromAdmin: map['senderID'] == null ||
            map['senderID'] == '' ||
            map['senderID'] == 'null' ||
            (map['senderID'] as String).isEmpty,
        isRead: map['isRead'] == '1' || map['isRead'] == 1,
        message: HtmlCharacterEntities.decode(map['message'] ?? ''),
        notificationID: map['notificationID'],
        senderID: map['senderID'],
        senderName: '${map['firstName']} ${map['lasttName']}',
        subject: HtmlCharacterEntities.decode(map['subject'] ?? ''),
        files: temp);
  }
}
