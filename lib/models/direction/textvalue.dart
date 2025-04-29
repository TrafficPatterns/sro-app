import 'dart:developer';

class TextValue {
  String? text;
  num? value;
  TextValue({this.text, this.value});

  static TextValue? parseTextValue(dynamic map) {
    if (map == null) {
      return null;
    }
    try {
      return TextValue(text: map['text'], value: map['value']);
    } catch (e) {
      log('error from parse text value ${e.toString()}');
      return null;
    }
  }
}
