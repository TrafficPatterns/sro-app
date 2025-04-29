import 'package:flutter/cupertino.dart';
import 'package:sro/models/message_model.dart';
import 'package:sro/themes/app_fonts.dart';

class Message extends StatelessWidget {
  final MessageModel? messageModel;

  const Message({Key? key, this.messageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Align(
          alignment: messageModel!.fromMe
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: messageModel!.fromMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: messageModel!.fromMe
                        ? const Color(0xffDAECF8)
                        : const Color(0xff164B9B),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      bottomRight: messageModel!.fromMe
                          ? const Radius.circular(0)
                          : const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: messageModel!.fromMe
                          ? const Radius.circular(20)
                          : const Radius.circular(0),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!messageModel!.fromMe)
                      Text(
                        '${messageModel!.senderName ?? ''}\n',
                        style: AppFonts.poppins12WhiteBold,
                      ),
                    Text(
                      messageModel!.text ?? '',
                      style: messageModel!.fromMe
                          ? AppFonts.poppins14Black
                          : AppFonts.poppins14White,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  messageModel!.getFormattedDate,
                  style: AppFonts.poppins14Grey,
                ),
              )
            ],
          )),
    );
  }
}
