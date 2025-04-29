import 'package:flutter/material.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/globals.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class FieldAndButton extends StatelessWidget {
  final String? label;
  final bool readonly;
  final bool text;
  final String? textValue;
  final Function? onTap;
  final VoidCallback? onTapText;
  final Function? onSubmit;
  final Function? onChanged;
  final TextEditingController? controller;
  const FieldAndButton(
      {Key? key,
      this.label,
      this.readonly = false,
      this.onTap,
      this.onChanged,
      this.onSubmit,
      this.controller,
      this.onTapText,
      this.text = false,
      this.textValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTapText,
          child: SizedBox(
            width: width - getSize(150),
            child: text
                ? Text(
                    textValue ?? '',
                    style: AppFonts.poppins14Black,
                  )
                : CustomTextField(
                    focusedBorder: InputBorder.none,
                    label: '',
                    border: InputBorder.none,
                    textController: controller,
                    required: false,
                    readOnly: readonly,
                    onSubmit: (s) => onSubmit!(s),
                    onChanged: (s) => onChanged!(s),
                  ),
          ),
        ),
        SizedBox(
          height: getSizeWrtHeight(55),
          width: getSize(139),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.zero,
              bottomLeft: Radius.zero,
            ),
            child: ElevatedButton(
              onPressed: () => onTap!.call(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff164B9B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              child: Text(
                label!,
                style: AppFonts.poppins14White,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
