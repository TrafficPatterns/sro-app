import 'package:flutter/services.dart';

import 'global_functions.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitilize(newValue.text),
      selection: newValue.selection,
    );
  }
}
