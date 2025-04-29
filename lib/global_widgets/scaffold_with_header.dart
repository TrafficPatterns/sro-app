import 'package:flutter/material.dart';

import 'header_widget.dart';

class HeaderScaffold extends StatelessWidget {
  final Widget? child;
  final Widget? trailing;
  final String? label;
  final Widget? leading;
  final TextStyle? headerStyle;
  final bool? hasAppBar;
  final Widget? titleWidget;
  final VoidCallback? onTrailingTap;
  final EdgeInsetsGeometry? headerPadding;
  final bool? hasDivider;
  final bool? centerTitle;
  const HeaderScaffold(
      {Key? key,
      this.leading,
      this.headerStyle,
      this.child,
      this.label,
      this.headerPadding,
      this.titleWidget,
      this.centerTitle = false,
      this.hasAppBar = true,
      this.trailing,
      this.onTrailingTap,
      this.hasDivider = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: hasAppBar!
          ? AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              shadowColor: Colors.white,
              centerTitle: centerTitle,
              leading: leading,
              title: titleWidget ??
                  HeaderWidget(
                    head: label ?? '',
                    headStyle: headerStyle,
                  ),
              actions: trailing == null ? null : [trailing!],
            )
          : null,
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        if (hasAppBar! && hasDivider!)
          const Divider(
            color: Color(0xffECEDEE),
            thickness: 2,
            height: 2,
          ),
        if (child != null) child!,
      ]),
    );
  }
}
