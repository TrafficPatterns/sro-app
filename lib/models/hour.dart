class HourFormatter {
  int? hour;
  int? minute;
  String? amPm;
  HourFormatter({this.hour, this.minute, this.amPm});
  bool get validate {
    if (hour != null && minute != null && amPm != null) {
      return true;
    }
    return false;
  }

  static bool compare(HourFormatter h1, HourFormatter h2) {
    if ((h1.amPm != h2.amPm) ||
        (h1.hour != h2.hour) ||
        (h1.minute != h2.minute)) return false;
    return true;
  }
}
