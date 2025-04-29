// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/check_box3.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/globals.dart';
import 'package:sro/pages/notifications_settings/notifications_settings_controller.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class NotificationsSettingsPage
    extends GetView<NotificationsSettingsdController> {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 0, top: 25),
          child: Text('Notifications Settings',
              style: AppFonts.poppinsSemiBold16Black),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 0),
            child: Row(
              children: [
                SizedBox(
                    height: getSizeWrtHeight(18),
                    width: getSize(18),
                    child: BackButton(
                      color: Colors.black,
                      onPressed: Get.back,
                    )),
              ],
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, bottom: 4),
                    child: Text(
                      'Event Notifications',
                      style: AppFonts.poppinsMedium16Black,
                    ),
                  ),
                ),
                CheckBoxText3(
                    title: 'A new member joins my event',
                    valueApp: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["memberJoinWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["eventNotiSettings"] == null
                            ? false
                            : controller.map.value["eventNotiSettings"]
                                    ["memberJoinEmail"] ==
                                "1",
                    valueText: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["memberJoinPhone"] ==
                            "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["memberJoinWeb"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["memberJoinWeb"] = "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["memberJoinEmail"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["memberJoinEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["memberJoinPhone"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["memberJoinPhone"] = "0";
                      }
                    }),
                CheckBoxText3(
                    title: 'A member leaves my event',
                    valueApp: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["memberLeaveWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["eventNotiSettings"] == null
                            ? false
                            : controller.map.value["eventNotiSettings"]
                                    ["memberLeaveEmail"] ==
                                "1",
                    valueText: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["memberLeavePhone"] ==
                            "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["memberLeaveWeb"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["memberLeaveWeb"] = "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["memberLeaveEmail"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["memberLeaveEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["memberLeavePhone"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["memberLeavePhone"] = "0";
                      }
                    }),
                CheckBoxText3(
                    title: 'An event I am a member of is deleted',
                    valueApp: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["eventDeleteWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["eventNotiSettings"] == null
                            ? false
                            : controller.map.value["eventNotiSettings"]
                                    ["eventDeleteEmail"] ==
                                "1",
                    valueText: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["eventDeletePhone"] ==
                            "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventDeleteWeb"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventDeleteWeb"] = "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventDeleteEmail"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventDeleteEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventDeletePhone"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventDeletePhone"] = "0";
                      }
                    }),
                CheckBoxText3(
                    title: 'I get kicked from an event',
                    valueApp: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["kickedWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["eventNotiSettings"] == null
                            ? false
                            : controller.map.value["eventNotiSettings"]
                                    ["kickedEmail"] ==
                                "1",
                    valueText: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["kickedPhone"] ==
                            "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]["kickedWeb"] =
                            "1";
                      } else {
                        controller.map.value["eventNotiSettings"]["kickedWeb"] =
                            "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["kickedEmail"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["kickedEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["kickedPhone"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["kickedPhone"] = "0";
                      }
                    }),
                CheckBoxText3(
                    title: 'An event I am a member of gets updated',
                    valueApp: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["eventUpdateWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["eventNotiSettings"] == null
                            ? false
                            : controller.map.value["eventNotiSettings"]
                                    ["eventUpdateEmail"] ==
                                "1",
                    valueText: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["eventUpdatePhone"] ==
                            "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventUpdateWeb"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventUpdateWeb"] = "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventUpdateEmail"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventUpdateEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventUpdatePhone"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventUpdatePhone"] = "0";
                      }
                    }),
                CheckBoxText3(
                    title: 'My event gets approved',
                    valueApp: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["eventApprovedWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["eventNotiSettings"] == null
                            ? false
                            : controller.map.value["eventNotiSettings"]
                                    ["eventApprovedEmail"] ==
                                "1",
                    valueText: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["eventApprovedPhone"] ==
                            "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventApprovedWeb"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventApprovedWeb"] = "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventApprovedEmail"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventApprovedEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventApprovedPhone"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventApprovedPhone"] = "0";
                      }
                    }),
                CheckBoxText3(
                    title: 'My event gets disapproved',
                    valueApp: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["eventDisapprovedWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["eventNotiSettings"] == null
                            ? false
                            : controller.map.value["eventNotiSettings"]
                                    ["eventDisapprovedEmail"] ==
                                "1",
                    valueText: controller.map.value["eventNotiSettings"] == null
                        ? false
                        : controller.map.value["eventNotiSettings"]
                                ["eventDisapprovedPhone"] ==
                            "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventDisapprovedWeb"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventDisapprovedWeb"] = "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventDisapprovedEmail"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventDisapprovedEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["eventNotiSettings"]
                            ["eventDisapprovedPhone"] = "1";
                      } else {
                        controller.map.value["eventNotiSettings"]
                            ["eventDisapprovedPhone"] = "0";
                      }
                    }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, bottom: 4),
                    child: Text(
                      'Personal Notifications',
                      style: AppFonts.poppinsMedium16Black,
                    ),
                  ),
                ),
                CheckBoxText3(
                    title: 'I change my profile information',
                    valueApp: controller.map.value["globalNotiSettings"] == null
                        ? false
                        : controller.map.value["globalNotiSettings"]
                                ["profileUpdateWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["globalNotiSettings"] == null
                            ? false
                            : controller.map.value["globalNotiSettings"]
                                    ["profileUpdateEmail"] ==
                                "1",
                    valueText:
                        controller.map.value["globalNotiSettings"] == null
                            ? false
                            : controller.map.value["globalNotiSettings"]
                                    ["profileUpdatePhone"] ==
                                "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["globalNotiSettings"]
                            ["profileUpdateWeb"] = "1";
                      } else {
                        controller.map.value["globalNotiSettings"]
                            ["profileUpdateWeb"] = "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["globalNotiSettings"]
                            ["profileUpdateEmail"] = "1";
                      } else {
                        controller.map.value["globalNotiSettings"]
                            ["profileUpdateEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["globalNotiSettings"]
                            ["profileUpdatePhone"] = "1";
                      } else {
                        controller.map.value["globalNotiSettings"]
                            ["profileUpdatePhone"] = "0";
                      }
                    }),
                CheckBoxText3(
                    title: 'I change my password',
                    valueApp: controller.map.value["globalNotiSettings"] == null
                        ? false
                        : controller.map.value["globalNotiSettings"]
                                ["passwordUpdateWeb"] ==
                            "1",
                    valueEmail:
                        controller.map.value["globalNotiSettings"] == null
                            ? false
                            : controller.map.value["globalNotiSettings"]
                                    ["passwordUpdateEmail"] ==
                                "1",
                    valueText:
                        controller.map.value["globalNotiSettings"] == null
                            ? false
                            : controller.map.value["globalNotiSettings"]
                                    ["passwordUpdatePhone"] ==
                                "1",
                    onChangedApp: (e) {
                      if (e) {
                        controller.map.value["globalNotiSettings"]
                            ["passwordUpdateWeb"] = "1";
                      } else {
                        controller.map.value["globalNotiSettings"]
                            ["passwordUpdateWeb"] = "0";
                      }
                    },
                    onChangedEmail: (e) {
                      if (e) {
                        controller.map.value["globalNotiSettings"]
                            ["passwordUpdateEmail"] = "1";
                      } else {
                        controller.map.value["globalNotiSettings"]
                            ["passwordUpdateEmail"] = "0";
                      }
                    },
                    onChangedText: (e) {
                      if (e) {
                        controller.map.value["globalNotiSettings"]
                            ["passwordUpdatePhone"] = "1";
                      } else {
                        controller.map.value["globalNotiSettings"]
                            ["passwordUpdatePhone"] = "0";
                      }
                    }),
                SizedBox(height: getSize(20)),
                CustomButton(
                    height: getSizeWrtHeight(65),
                    widthh: width - getSize(30),
                    onTap: () async {
                      var res = await controller.updateNotification();
                      showToas(res.toString());
                    },
                    text: 'Save',
                    textStyle: AppFonts.poppinsMedium16White,
                    color: const Color(0xff164B9B),
                    textColor: Colors.white,
                    borderColor: const Color(0xff164B9B)),
                SizedBox(height: getSize(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
