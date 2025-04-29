import 'package:flutter/material.dart';
import 'package:sro/themes/app_fonts.dart';

import '../services/global_functions.dart';

class CustomDropDown extends StatelessWidget {
  final List<DropdownMenuItem>? values;
  final Function(dynamic)? onChanged;
  final String? selected;
  final double? height;
  final double? width;
  final String? label;
  final bool? required;
  final String? error;
  const CustomDropDown(
      {Key? key,
      this.values,
      this.width,
      this.onChanged,
      this.selected,
      this.height,
      this.label,
      this.required = true,
      this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? getSize(315),
      child: DropdownButtonFormField(
        items: values,
        focusColor: Colors.white,
        borderRadius: BorderRadius.circular(15),
        style: AppFonts.poppins14Black,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: AppFonts.poppinsBold14Grey,
            focusColor: const Color(0xff164B9B),
            floatingLabelStyle: AppFonts.poppinsBold14Grey,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff164B9B)),
            ),
            errorText: error),
        value: selected,
        onChanged: (dynamic value) {
          if (onChanged != null) {
            onChanged!(value);
          }
          unfocus();
        },
        isDense: true,
      ),
    );
  }
}
