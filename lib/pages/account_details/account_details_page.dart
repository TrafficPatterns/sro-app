import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/circle_container_with_image.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/global_widgets/dialog_box.dart';
import 'package:sro/global_widgets/field_and_button.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/global_widgets/special_listing_widget.dart';
import 'package:sro/pages/account/account_controller.dart';
import 'package:sro/pages/account_details/account_details_controller.dart';
import 'package:sro/pages/account_details/student_options.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class AccountDetailsPage extends GetView<AccountDetailsController> {
  const AccountDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 0, top: 25),
          child: Text('Account', style: AppFonts.poppinsSemiBold16Black),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 0),
            child: Row(
              children: [
                SizedBox(
                    height: getSizeWrtHeight(18),
                    width: getSize(18),
                    child: BackButton(
                      color: Colors.black,
                      onPressed: Get.back,
                    )),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: unfocus,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleImage(
                      iconFit: BoxFit.fill,
                      iconPadding: const EdgeInsets.all(10),
                      eventType: EventType.avatar,
                      size: getSize(80),
                    ),
                  ),
                  GetBuilder<AccountController>(
                    builder: (controller) => Text(
                        capitilize(controller.name.value),
                        style: AppFonts.poppins18BlackBold),
                  ),
                  SizedBox(height: getSizeWrtHeight(10)),
                  Obx(
                    () => Text(controller.users.value.role.toString(),
                        style: AppFonts.poppins14Black),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                      height: getSizeWrtHeight(54),
                      widthh: getSize(150),
                      radius: BorderRadius.circular(60),
                      onTap: () {
                        Get.toNamed(AppRoutes.editProfile);
                      },
                      text: 'Edit Profile',
                      textStyle: AppFonts.poppinsSemiBold16White,
                      color: const Color(0xff164B9B),
                      textColor: Colors.white,
                      borderColor: const Color(0xff164B9B)),
                  SizedBox(
                    height: getSizeWrtHeight(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Students',
                          style: AppFonts.poppins14BlackBold,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.addStudentSettings);
                          },
                          child: Text(
                            'Add',
                            style: AppFonts.poppins14Blue,
                          ))
                    ],
                  ),
                  GetBuilder<SchoolController>(builder: (controller) {
                    return ListView.builder(
                      itemCount: controller.schools.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return SListing(
                          heading: controller
                              .schools[index].studentName!.capitalizeFirst,
                          sub: controller.schools[index].name,
                          leading: GetImages(
                            image: AppImages.delete,
                            onTap: () {
                              DialogBox.showCustomDialog(
                                  child: StudentOptions(
                                name: controller.schools[index].studentName!
                                    .capitalizeFirst,
                                id: controller.schools[index].id,
                              ));
                            },
                          ),
                          height: getSizeWrtHeight(90),
                          evntType: EventType.avatar,
                          hasBorder: false,
                        );
                      },
                    );
                  }),
                  Obx(() => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        child: controller.loading.value
                            ? const CircularProgressIndicator()
                            : controller.coParent.value == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 25),
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 8),
                                          child: Text(
                                            'My Parent Code',
                                            style: AppFonts.poppins14BlackBold,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: FieldAndButton(
                                            label: 'Generate Code',
                                            readonly: true,
                                            text: true,
                                            textValue:
                                                controller.generatedCode.value,
                                            onTapText: () {
                                              if (controller.generatedCode
                                                          .value !=
                                                      null &&
                                                  controller.generatedCode
                                                      .value!.isNotEmpty) {
                                                controller.copyCode();
                                              } else {
                                                controller.generateCode();
                                              }
                                            },
                                            onTap: () async {
                                              controller.generateCode();
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: RichText(
                                          text: TextSpan(
                                            style: AppFonts.poppins12ItalicRed,
                                            children: <TextSpan>[
                                              const TextSpan(text: '* '),
                                              TextSpan(
                                                text:
                                                    'Sharing this code with your coparent will show them the events you are a member of, as well as your list of students.',
                                                style: AppFonts
                                                    .poppins12ItalicGrey,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 8),
                                          child: Text(
                                            'Apply Coparent Code',
                                            style: AppFonts.poppins14BlackBold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: FieldAndButton(
                                          label: 'Apply Code',
                                          controller:
                                              controller.applyController.value,
                                          onChanged: (s) {},
                                          onSubmit: (s) {},
                                          onTap: () async {
                                            if (controller.applyController.value
                                                .text.isEmpty) {
                                              showToas(
                                                  'Please type your code first');
                                            } else {
                                              var res =
                                                  await controller.applyCode();
                                              if (res != null) {
                                                showToas(res.toString());
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const SizedBox(height: 25),
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 8),
                                          child: Text(
                                            'My Co-Parent',
                                            style: AppFonts.poppins14BlackBold,
                                          ),
                                        ),
                                      ),
                                      SListing(
                                        evntType: EventType.avatar,
                                        heading: controller.coParent.value,
                                        leading: GetImages(
                                          image: AppImages.delete,
                                          onTap: () {
                                            DialogBox.showCustomDialog(
                                                child: StudentOptions(
                                              name: controller.coParent.value,
                                              parent: true,
                                            ));
                                          },
                                        ),
                                        hasBorder: false,
                                      ),
                                    ],
                                  ),
                      )),
                ]),
          ),
        ),
      ),
    );
  }
}
