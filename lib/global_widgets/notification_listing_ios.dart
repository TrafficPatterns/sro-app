import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
import '../models/file_model.dart';
import '../services/global_functions.dart';
import '../themes/app_fonts.dart';
import 'notification_listing_android.dart';

class NotificationListingIOS extends StatelessWidget {
  const NotificationListingIOS(
      {Key? key,
      required this.title,
      this.subtitle,
      this.onTap,
      this.date,
      required this.active,
      required this.files,
      this.onDismiss,
      this.read,
      this.unread})
      : super(key: key);

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final DateTime? date;
  final bool active;
  final VoidCallback? onDismiss;
  final VoidCallback? read;
  final VoidCallback? unread;
  final List<FileModel> files;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width - getSize(30),
        child: Slidable(
          key: UniqueKey(),
          closeOnScroll: true,
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            if (active)
              SlidableAction(
                  onPressed: (_) {
                    if (unread != null) unread!();
                  },
                  backgroundColor: Colors.green,
                  icon: Icons.remove_done_sharp)
            else
              SlidableAction(
                  onPressed: (_) {
                    if (read != null) read!();
                  },
                  backgroundColor: Colors.blue,
                  icon: Icons.done_all),
          ]),
          endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                onDismissed: () {
                  if (onDismiss != null) onDismiss!();
                },
              ),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    if (onDismiss != null) onDismiss!();
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                ),
              ]),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(200)),
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
                        )),
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
      ),
    );
  }
}
