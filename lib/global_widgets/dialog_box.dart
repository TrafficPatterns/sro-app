import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogBox extends StatelessWidget {
  const DialogBox(
      {Key? key, this.child, this.onPop, this.dismissable = true, this.onTap})
      : super(key: key);

  final Widget? child;
  final VoidCallback? onPop;
  final VoidCallback? onTap;
  final bool? dismissable;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onPop != null) onPop!();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          if (dismissable!) {
            Get.back();
          }
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () {
              if (onTap != null) onTap!();
            },
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  static void showCustomDialog({Widget? child, VoidCallback? onPop}) {
    showDialog(
        context: Get.context!,
        builder: (_) => DialogBox(
              onPop: onPop,
              child: child,
            ));
  }
}
