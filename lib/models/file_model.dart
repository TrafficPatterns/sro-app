class FileModel {
  String? fileName;
  String? url;
  FileModel({this.fileName, this.url});
  static FileModel getFileFromMap(dynamic map) {
    return FileModel(
        fileName: map['realName'] ?? '',
        url:
            'http://user.schoolroutes.org/uploads/notifications/${map['fileName']}');
  }

  bool isImage() {
    return fileName!.split('.').last == 'png' ||
        fileName!.split('.').last == 'jpg';
  }

  bool isSVG() {
    return fileName!.split('.').last == 'svg';
  }
}
