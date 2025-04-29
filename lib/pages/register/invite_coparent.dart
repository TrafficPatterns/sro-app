import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/header_widget.dart';
import 'package:sro/global_widgets/text_field.dart';
import 'package:sro/pages/register/register_controller.dart';
import 'package:sro/services/global_functions.dart';

import '../../global_widgets/scaffold_back.dart';
import '../../globals.dart';
import '../../themes/app_fonts.dart';

class InviteCoparent extends GetView<RegisterController> {
  const InviteCoparent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackScaffold(
      hasAppBar: true,
      onBackPress: () async {
        await controller.clearfilters();
        Get.back();
      },
      trailing: TextButton(
          onPressed: () {},
          child: Text(
            'Skip',
            style: AppFonts.poppinsMedium18blue,
          )),
      scrollView: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Obx(() {
              return Column(
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: HeaderWidget(head: 'Invite Co-Parent')),
                  SizedBox(height: getSizeWrtHeight(30)),
                  CustomTextField(
                      label: 'Full Name',
                      required: true,
                      onChanged: controller.onCoparentNameChanged,
                      error: controller.coparentNameError.value,
                      textController: controller.coparentName.value),
                  SizedBox(height: getSizeWrtHeight(10)),
                  CustomTextField(
                    label: 'Email',
                    required: true,
                    error: controller.coparentEmailError.value,
                    textController: controller.coparentEmail.value,
                    onChanged: controller.onCoparentEmailChanged,
                  ),
                ],
              );
            }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() {
              return CustomButton(
                height: getSizeWrtHeight(65),
                widthh: width - getSize(30),
                onTap: () async {
                  if (controller.hasWrittenCoparent()) {
                    if (!controller.validateCoparentFields()) {
                      showToas('Fields Must be properly filled');
                      return;
                    }
                  }
                  await controller.submitFunction();
                },
                text: controller.hasWrittenCoparent()
                    ? 'Invite Co-Parent'
                    : 'Skip & Finish Registration ',
                textStyle: controller.hasWrittenCoparent()
                    ? AppFonts.poppinsSemiBold16White
                    : AppFonts.poppinsMedium16blue,
                textColor: controller.hasWrittenCoparent()
                    ? Colors.white
                    : const Color(0xff164B9B),
                color: controller.hasWrittenCoparent()
                    ? const Color(0xff164B9B)
                    : Colors.white,
                borderColor: const Color(0xff164B9B),
              );
            }),
          )
        ],
      ),
    );
  }
}
