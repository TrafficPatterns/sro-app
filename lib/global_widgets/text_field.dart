import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/services/upper_case_formatter.dart';
import 'package:sro/themes/app_fonts.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      this.isName = false,
      this.height,
      this.autofocus = false,
      this.width,
      this.textController,
      this.focusNode,
      this.label,
      this.maxLength,
      this.error,
      this.required,
      this.onChanged,
      this.isPass = false,
      this.hasShowHide = false,
      this.onSubmit,
      this.textInputType,
      this.readOnly = false,
      this.formatters,
      this.oneditingComplete,
      this.border,
      this.focusedBorder})
      : super(key: key);

  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final bool? autofocus;
  final InputBorder? border;
  final String? error;
  final FocusNode? focusNode;
  final InputBorder? focusedBorder;
  final List<TextInputFormatter>? formatters;
  final bool hasShowHide;
  final double? height;
  final bool isPass;
  final String? label;
  final int? maxLength;
  final VoidCallback? oneditingComplete;
  final bool readOnly;
  final bool? required;
  final TextEditingController? textController;
  final TextInputType? textInputType;
  final double? width;
  final bool? isName;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late StreamSubscription<bool> keyboardSubscription;

  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) async {
      if (!visible) {
        unfocus();
      }
    });
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: getSizeWrtHeight(widget.height ?? 80) +
            (widget.error == null ? 0 : 20),
        width: getSize(widget.width ?? 315),
        child: TextField(
            onEditingComplete: widget.oneditingComplete,
            autofocus: widget.autofocus!,
            inputFormatters: widget.formatters ??
                (widget.isName! ? [UpperCaseTextFormatter()] : null),
            maxLength: widget.maxLength,
            maxLengthEnforcement: widget.maxLength == null
                ? MaxLengthEnforcement.none
                : MaxLengthEnforcement.enforced,
            controller: widget.textController,
            keyboardType: widget.textInputType,
            readOnly: widget.readOnly,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmit,
            obscureText: (widget.isPass && _isHidden),
            cursorColor: const Color(0xff164B9B),
            style: AppFonts.poppins14Black,
            decoration: InputDecoration(
                isDense: true,
                border: widget.border,
                errorText: widget.error,
                focusedBorder: widget.focusedBorder ??
                    const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff164B9B)),
                    ),
                floatingLabelStyle: AppFonts.poppinsBold14Grey,
                hintStyle: AppFonts.poppinsBold14Grey,
                suffixIcon: widget.hasShowHide
                    ? InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xff164B9B),
                        ),
                      )
                    : null,
                labelText:
                    '${widget.label}${(widget.required ?? false) ? ' *' : ''}')));
  }
}
