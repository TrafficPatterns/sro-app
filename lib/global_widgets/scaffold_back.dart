import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/themes/app_fonts.dart';

import '../services/global_functions.dart';

class BackScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? trailing;
  final Color? color;
  final String? label;
  final bool? resizeToAvoidInset;
  final bool? scrollView;
  final VoidCallback? onBackPress;
  final bool? hasAppBar;
  final Widget? leading;
  final bool? hasPadding;
  final EdgeInsets? padding;
  final bool? clear;
  const BackScaffold(
      {Key? key,
      @required this.body,
      this.trailing,
      this.color,
      this.leading,
      this.label,
      this.hasAppBar,
      this.hasPadding = true,
      this.onBackPress,
      this.padding,
      this.scrollView = true,
      this.resizeToAvoidInset = true,
      this.clear = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidInset!,
        appBar: ((hasAppBar ?? false) && !clear!)
            ? AppBar(
                title: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (leading != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: leading ?? const SizedBox(),
                          ),
                        Text(
                          label ?? '',
                          style: AppFonts.poppins18Black,
                        )
                      ]),
                ),
                toolbarHeight: 40,
                actions: [if (trailing != null) trailing ?? const SizedBox()],
                backgroundColor: Colors.white,
                shadowColor: Colors.white,
                foregroundColor: Colors.white,
                elevation: 0,
                leading: InkWell(
                    onTap: onBackPress ?? Get.back,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BackButton(
                          color: Colors.black,
                          onPressed: onBackPress ?? Get.back),
                    )),
              )
            : null,
        backgroundColor: color,
        body: !clear!
            ? (hasPadding!
                ? Padding(
                    padding: padding ??
                        const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 10),
                    child: scrollView!
                        ? ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: SingleChildScrollView(child: body))
                        : body!,
                  )
                : scrollView!
                    ? ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(child: body))
                    : body!)
            : Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          hasPadding!
                              ? Padding(
                                  padding: padding ??
                                      const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 20,
                                          top: 10),
                                  child: scrollView!
                                      ? ScrollConfiguration(
                                          behavior: MyBehavior(),
                                          child: SingleChildScrollView(
                                              child: body))
                                      : body!,
                                )
                              : scrollView!
                                  ? ScrollConfiguration(
                                      behavior: MyBehavior(),
                                      child: SingleChildScrollView(child: body))
                                  : body!,
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Expanded(
                        child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: const Color(0xffe4e5eb),
                                  borderRadius: BorderRadius.circular(10)),
                              child: BackButton(
                                color: Colors.black,
                                onPressed: onBackPress ?? Get.back,
                              ),
                            ),
                          ),
                        ),
                        if (trailing != null)
                          Align(
                              alignment: Alignment.topRight, child: trailing!),
                      ],
                    )),
                  )
                ],
              ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
