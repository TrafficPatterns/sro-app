import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/globals.dart';
import 'package:sro/models/file_model.dart';
import 'package:sro/services/global_functions.dart';
import 'package:intl/intl.dart';
import 'package:sro/themes/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationListingAndroid extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final DateTime? date;
  final VoidCallback? onDismiss;
  final VoidCallback? read;
  final VoidCallback? unread;
  final bool active;
  final List<FileModel> files;
  const NotificationListingAndroid(
      {Key? key,
      this.subtitle,
      this.title = '',
      this.onTap,
      this.date,
      this.active = false,
      this.files = const [],
      this.onDismiss,
      this.read,
      this.unread})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset? offset;
    return InkWell(
      onTap: onTap,
      onTapDown: (TapDownDetails details) {
        offset = details.globalPosition;
      },
      onLongPress: () {
        if (offset != null) {
          showMenu(
              context: Get.context!,
              position:
                  RelativeRect.fromLTRB(offset!.dx, offset!.dy, offset!.dx, 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              items: [
                PopupMenuItem(
                    value: 'Read',
                    onTap: read,
                    child: Text(
                      'Read',
                      style: AppFonts.poppins14Black,
                    )),
                PopupMenuItem(
                  value: 'Unread',
                  onTap: unread,
                  child: Text(
                    'Unread',
                    style: AppFonts.poppins14Black,
                  ),
                ),
                PopupMenuItem(
                  value: 'Delete',
                  onTap: onDismiss,
                  child: Text(
                    'Delete',
                    style: AppFonts.poppins14Black,
                  ),
                ),
              ]);
        }
      },
      child: SizedBox(
        width: width - getSize(30),
        child: Card(
          color: Colors.white,
          elevation: 0,
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (!active)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: getSize(8),
                                  width: getSize(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF26522),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(200)),
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: getSize(210),
                              child: Text(
                                title,
                                style: AppFonts.poppins18Black,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          getDate(date),
                          style: AppFonts.poppins13Grey,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: getSize(280),
                    child: Text(
                      subtitle ?? '',
                      style: AppFonts.poppins13Grey,
                    ),
                  ),
                  if (files.isNotEmpty)
                    SizedBox(
                      width: width - getSize(50),
                      height: getSizeWrtHeight(50),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: files.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(files[index].url!),
                                    mode: LaunchMode.externalApplication);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                height: getSize(50),
                                width: getSize(50),
                                child: const Icon(Icons.file_download),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}

String getDate(DateTime? date) {
  var now = DateTime.now();
  var difMinutes = now.difference(date ?? DateTime.now()).inMinutes;
  var difHours = now.difference(date ?? DateTime.now()).inHours;
  var difDays = now.difference(date ?? DateTime.now()).inDays;
  if (difMinutes < 0) {
    return '0 seconds ago';
  } else if (difMinutes < 60) {
    if (difMinutes == 0) {
      var difSeconds = now.difference(date ?? DateTime.now()).inSeconds;
      return '$difSeconds seconds ago';
    }
    return '$difMinutes minutes ago';
  } else if (difHours < 24) {
    return '$difHours hours ago';
  } else if (difDays <= 1) {
    return 'Yesterday';
  } else {
    return DateFormat('dd MMMM').format(date ?? DateTime.now());
  }
}
