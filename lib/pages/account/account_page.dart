import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/dialog_box.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/global_widgets/listing.dart';
import 'package:sro/global_widgets/scaffold_back.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/models/user_model.dart';
import 'package:sro/pages/account/you_sure.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/route/app_routes.dart';
import 'package:sro/services/globals/global_user_variables.dart';
import 'package:sro/themes/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_widgets/special_listing_widget.dart';
import '../../services/global_functions.dart';
import 'account_controller.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
        label: 'Settings',
        child: Expanded(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                children: [
                  Obx(() {
                    return SListing(
                      height: getSizeWrtHeight(110),
                      hasBorder: false,
                      expandText: true,
                      onTap: () async {
                        user = await UserModel().getUserFromSharedPreferences;
                        if (!user.isStudent) {
                          Get.toNamed(
                            AppRoutes.accountDetails,
                          );
                        } else {
                          var sc = Get.put(SchoolController());
                          sc.clearFilters();
                          sc.cityController.value = sc.schools.first.cityName!;
                          sc
                              .onChnagedType(sc.schools.first.type!)
                              .then((value) {
                            bool found = false;
                            for (var x in sc.schoolSearch.value) {
                              if (x.name == sc.schools.first.name) {
                                found = true;
                                break;
                              }
                            }
                            if (found) {
                              sc.schoolController.value =
                                  sc.schools.first.name!;
                            }
                          });
                          Get.toNamed(
                            AppRoutes.editProfile,
                          );
                        }
                      },
                      evntType: EventType.avatar,
                      heading: capitilize(controller.name.value),
                      sub: user.isStudent ? 'Student' : 'Parent',
                    );
                  }),
                  SizedBox(
                    height: getSizeWrtHeight(15),
                  ),
                  Listing(
                    color: Colors.white,
                    heigth: getSizeWrtHeight(85),
                    onTap: () {
                      Get.toNamed(AppRoutes.notificationsSettings);
                    },
                    title: 'Notification Settings',
                    expandText: true,
                    leading:
                        const GetImages(image: AppImages.notificationSettings),
                    trailing: const GetImages(image: AppImages.arrow),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 20, bottom: 4),
                      child: Text(
                        'About',
                        style: AppFonts.poppins16DarkGrey,
                      ),
                    ),
                  ),
                  Listing(
                    color: Colors.white,
                    title: 'Privacy Policy',
                    expandText: true,
                    onTap: () {
                      launchUrl(Uri.parse(privacyPolicyUrl));
                    },
                    heigth: getSizeWrtHeight(85),
                    leading: const GetImages(image: AppImages.privacySettings),
                    trailing: const GetImages(image: AppImages.arrow),
                  ),
                  Listing(
                    color: Colors.white,
                    title: 'Version',
                    expandText: true,
                    heigth: getSizeWrtHeight(85),
                    leading: const GetImages(image: AppImages.version),
                    trailing: const Text('1.0.1'),
                  ),
                  if (user.isStudent)
                    Listing(
                      color: Colors.white,
                      title: 'Location Service',
                      heigth: getSizeWrtHeight(85),
                      onTap: controller.toggleLocation,
                      leading: const GetImages(
                        image: AppImages.locTracking,
                        height: 32,
                        width: 32,
                      ),
                      trailing: Obx(() => Text(
                            controller.isLocTrackingActive.value
                                ? "Active"
                                : "Disabled",
                            style: controller.isLocTrackingActive.value
                                ? AppFonts.poppins14Green
                                : AppFonts.poppins14Red,
                          )),
                    ),
                  Listing(
                    color: Colors.white,
                    title: 'Logout',
                    expandText: true,
                    onTap: () {
                      AccountController.logout();
                    },
                    heigth: getSizeWrtHeight(85),
                    leading: const GetImages(image: AppImages.logout),
                  ),
                  Listing(
                    color: Colors.white,
                    title: 'Delete Account',
                    expandText: true,
                    onTap: () {
                      DialogBox.showCustomDialog(child: const AreYouSure());
                    },
                    heigth: getSizeWrtHeight(85),
                    leading: const GetImages(image: AppImages.delete),
                  ),
                ]),
          ),
        ));
  }
}
