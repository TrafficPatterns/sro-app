import 'package:flutter/material.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class Search extends StatelessWidget {
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Function? onSubmit;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? width;
  final String? hint;
  final bool? isAutoFocused;

  const Search(
      {Key? key,
      this.hint,
      this.onTap,
      this.onChange,
      this.onSubmit,
      this.controller,
      this.width = 335,
      this.isAutoFocused = false,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: getSize(width!),
        height: getSizeWrtHeight(60),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFECEDEE)),
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: getSize(9.51), end: getSize(9)),
                  child: GetImages(
                    image: AppImages.search,
                    height: getSizeWrtHeight(20),
                  ),
                ),
                SizedBox(
                  height: getSizeWrtHeight(37),
                  width: getSize(width! - 90),
                  child: TextFormField(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: hint ?? 'What school are you looking for?',
                      border: InputBorder.none,
                      hintStyle: AppFonts.poppins13Grey,
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: onChange,
                    onFieldSubmitted: (data) {
                      if (onChange != null) {
                        onChange!(data);
                      }
                      if (onSubmit != null) {
                        onSubmit!();
                      }
                    },
                    controller: controller,
                    focusNode: focusNode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
