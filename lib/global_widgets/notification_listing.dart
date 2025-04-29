import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sro/global_widgets/notification_listing_android.dart';
import 'package:sro/global_widgets/notification_listing_ios.dart';

import '../models/file_model.dart';

class NotificationListing extends StatelessWidget {
  const NotificationListing(
      {Key? key,
      required this.title,
      this.subtitle,
      this.onTap,
      this.date,
      this.onDismiss,
      this.read,
      this.unread,
      required this.active,
      required this.files})
      : super(key: key);

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final DateTime? date;
  final VoidCallback? onDismiss;
  final VoidCallback? read;
  final VoidCallback? unread;
  final bool active;
  final List<FileModel> files;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return NotificationListingAndroid(
        title: title,
        active: active,
        date: date,
        files: files,
        onDismiss: onDismiss,
        onTap: onTap,
        read: read,
        subtitle: subtitle,
        unread: unread,
      );
    } else {
      return NotificationListingIOS(
        title: title,
        active: active,
        date: date,
        files: files,
        onDismiss: onDismiss,
        onTap: onTap,
        read: read,
        subtitle: subtitle,
        unread: unread,
      );
    }
  }
}
