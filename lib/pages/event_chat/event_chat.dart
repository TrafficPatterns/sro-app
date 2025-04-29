import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/chat_box.dart';
import 'package:sro/global_widgets/circle_container_with_image.dart';
import 'package:sro/global_widgets/message.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/globals.dart';
import 'package:sro/models/message_model.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/pages/events/events_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

import '../../global_widgets/get_images.dart';
import '../../global_widgets/header_widget.dart';
import '../school/school_controller.dart';

class EventChat extends GetView<EventsController> {
  const EventChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.active.value = '';
        controller.textController.value.clear();
        controller.sortList();
        return true;
      },
      child: GestureDetector(
        onTap: unfocus,
        child: Obx(() => HeaderScaffold(
            leading: BackButton(
                color: Colors.black,
                onPressed: (() {
                  controller.active.value = '';
                  Get.back();
                })),
            headerStyle: AppFonts.poppins18BlackBold,
            titleWidget: InkWell(
              onTap: () async {
                controller.exEvent.value =
                    controller.eventsList[controller.currentMessageList.value];
                controller.icon.value = await SchoolController.getIcon(
                    controller.exEvent.value!.type.toString().split('.').last,
                    scale: 0.5);
                Get.toNamed(AppRoutes.eventDetails, arguments: true);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CircleImage(
                      size: 35,
                      eventType: controller
                          .eventsList[controller.currentMessageList.value].type,
                    ),
                  ),
                  HeaderWidget(
                    head: controller
                        .eventsList[controller.currentMessageList.value].title,
                    headStyle: AppFonts.poppins18BlackBold,
                  ),
                ],
              ),
            ),
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: controller
                              .eventsList[controller.currentMessageList.value]
                              .messages!
                              .length,
                          itemBuilder: ((context, index) {
                            int length = controller
                                .eventsList[controller.currentMessageList.value]
                                .messages!
                                .length;
                            return Column(
                              children: [
                                if (index == length - 1 &&
                                    !(((controller
                                                    .eventsList[controller
                                                        .currentMessageList
                                                        .value]
                                                    .offset +
                                                1) *
                                            20) >
                                        length))
                                  TextButton(
                                      onPressed: () {
                                        controller.getMessagesForEvent(
                                            index: controller
                                                .currentMessageList.value,
                                            offset: ++controller
                                                .eventsList[controller
                                                    .currentMessageList.value]
                                                .offset);
                                      },
                                      child: Text(
                                        'Load More',
                                        style: AppFonts.poppins14Blue,
                                      )),
                                Message(
                                  messageModel: controller
                                      .eventsList[
                                          controller.currentMessageList.value]
                                      .messages![index],
                                ),
                              ],
                            );
                          }));
                    }),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                        height: getSizeWrtHeight(65),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        width: width,
                        color: const Color(0xffF5F8FA),
                        child: ChatBox(
                          onSubmit: (_) async {
                            if (controller.message.value.trim().isEmpty) {
                              return;
                            }
                            final user =
                                await UserModel().getUserFromSharedPreferences;
                            controller.addMessage(MessageModel(
                                dateSent: DateTime.now(),
                                fromMe: true,
                                senderName: user.getFullName(),
                                text: controller.message.value));
                            controller.textController.value.clear();
                            controller.message.value = '';
                          },
                          onChanged: controller.onChangedMessage,
                          controller: controller.textController.value,
                          suffixIcon: GetImages(
                            color: controller.message.value.trim().isEmpty
                                ? Colors.grey
                                : null,
                            image: AppImages.send,
                            onTap: () async {
                              if (controller.message.value.trim().isEmpty) {
                                return;
                              }
                              final user = await UserModel()
                                  .getUserFromSharedPreferences;
                              controller.addMessage(MessageModel(
                                  dateSent: DateTime.now(),
                                  fromMe: true,
                                  senderName: user.getFullName(),
                                  text: controller.message.value));
                              controller.textController.value.clear();
                              controller.message.value = '';
                            },
                          ),
                        )),
                  ),
                ],
              ),
            ))),
      ),
    );
  }
}
