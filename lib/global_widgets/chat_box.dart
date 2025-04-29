import 'package:flutter/material.dart';
import 'package:sro/themes/app_fonts.dart';

class ChatBox extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  const ChatBox({Key? key, this.controller, this.focusNode, this.suffixIcon, this.onChanged, this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        enableInteractiveSelection: false,
        controller: controller,
        onSubmitted: onSubmit,
        focusNode: focusNode,
        onChanged: onChanged,
        onEditingComplete: (){},
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.all(8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20.0),
            ),
            filled: true,
            hintStyle: AppFonts.poppins15Grey,
            hintText: 'Write a message',
            fillColor: Colors.white70),
      ),
    );
  }
}
