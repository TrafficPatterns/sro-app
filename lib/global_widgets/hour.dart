import 'package:flutter/cupertino.dart';
import 'package:sro/themes/app_fonts.dart';

class Hour extends StatelessWidget {
  final Function(int, int)? onChanged;
  final int? hour;
  final int? minute;
  final String? amPm;
  const Hour({Key? key, this.onChanged, this.hour, this.minute, this.amPm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hour == null || minute == null || amPm == null) {
      return Text(
        '- -  - -',
        style: AppFonts.poppins15Grey,
      );
    } else {
      return Text(
        '${hour! < 10 ? 0 : ''}$hour:${minute! < 10 ? 0 : ''}$minute $amPm',
        style: AppFonts.poppins14Blue,
      );
    }
  }
}
