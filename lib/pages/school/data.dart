import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sro/global_widgets/school_picker.dart';
import 'package:sro/pages/school/filters.dart';
import 'package:sro/pages/school/legend.dart';
import 'package:sro/pages/school/school_controller.dart';
import 'package:sro/services/globals/global_user_variables.dart';

import '../../global_widgets/get_images.dart';
import '../../global_widgets/map.dart';
import '../../global_widgets/scaffold_back.dart';
import '../../global_widgets/search.dart';
import '../../global_widgets/special_listing_widget.dart';
import '../../services/global_functions.dart';
import '../../themes/app_fonts.dart';

class Data extends GetView<SchoolController> {
  const Data({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.mapOpen.value
          ? controller.legendOpen.value
              ? const Legend()
              : Expanded(
                  child: Stack(
                    children: [
                      GetBuilder<SchoolController>(builder: (controller) {
                        return MapView(
                          myLocation: true,
                          minMaxZoomPreference:
                              const MinMaxZoomPreference(12.5, 22),
                          onCameraMove: (camera) {
                            controller.zoomLog.value = camera.zoom;
                          },
                          controller:
                              user.isStudent ? controller.mapController : null,
                          onIdle: () async {
                            if (controller.zoomLog.value !=
                                controller.zoomVal.value) {
                              await controller.resizeMarkers(
                                  (controller.whichList.value == 0
                                          ? controller
                                              .schools[controller.index.value]
                                          : controller.allSchools[
                                              controller.index.value])
                                      .id!,
                                  controller.zoomLog.value);
                              controller.zoomVal.value =
                                  controller.zoomLog.value;
                              controller.update();
                            }
                          },
                          initialPosition: CameraPosition(
                              target: controller.whichList.value == 0
                                  ? controller
                                      .schools[controller.index.value].location!
                                  : controller
                                      .allSchools[controller.index.value]
                                      .location!,
                              zoom: 15.0),
                          markers: (controller.whichList.value == 0
                                  ? controller
                                      .schools[controller.index.value].markers
                                  : controller
                                      .allSchools[controller.index.value]
                                      .markers)
                              .toSet(),
                          circles: controller.whichList.value == 0
                              ? controller
                                  .schools[controller.index.value].circles
                              : controller
                                  .allSchools[controller.index.value].circles,
                          polygons: controller.whichList.value == 0
                              ? controller
                                  .schools[controller.index.value].polygons
                              : controller
                                  .allSchools[controller.index.value].polygons,
                          polylines: controller.whichList.value == 0
                              ? controller
                                  .schools[controller.index.value].polylines
                              : controller
                                  .allSchools[controller.index.value].polylines,
                        );
                      }),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => controller.legendOpen.value = true,
                                child: Container(
                                  height: getSizeWrtHeight(40),
                                  padding: const EdgeInsets.all(5),
                                  width: getSize(130),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 4,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Map Legend',
                                      style: AppFonts.poppins14BlackBold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: getSize(20)),
                              InkWell(
                                onTap: () => controller.takeMeToMaps(),
                                child: Container(
                                  height: getSizeWrtHeight(40),
                                  padding: const EdgeInsets.all(5),
                                  width: getSize(120),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff164B9B),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 4,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 2),
                                          child: GetImages(
                                              height: getSize(25),
                                              color: Colors.white,
                                              width: getSize(30),
                                              image: AppImages.directions),
                                        ),
                                        Text(
                                          'Directions',
                                          style: AppFonts.poppinsMedium16White,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
          : controller.schoolFilter.value
              ? const Filters()
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child:
                          GetBuilder<SchoolController>(builder: (controller) {
                        return SmartRefresher(
                            controller: controller.refreshController,
                            enablePullDown: true,
                            header: const WaterDropHeader(),
                            onRefresh: controller.onRefresh,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.schools.length +
                                    controller.allSchools.length +
                                    3,
                                itemBuilder: (_, int index) {
                                  if (index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Search(
                                        onChange: controller.search,
                                        onSubmit: unfocus,
                                        controller: controller.searchController,
                                      ),
                                    );
                                  } else if (index == 1) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: isGuest
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 8, right: 8),
                                              child: SchoolPicker(
                                                expand: true,
                                                hasSchool: false,
                                                cities: controller.cities
                                                    .map((element) =>
                                                        DropdownMenuItem(
                                                          value: element.name!,
                                                          child: Text(
                                                              element.name!),
                                                        ))
                                                    .toList(),
                                                onChangeType: controller
                                                    .onChangeTypeGuest,
                                                onChangeCity: controller
                                                    .onChangeCityGuest,
                                                typeValue:
                                                    controller.typeGuest.value,
                                                cityValue:
                                                    controller.cityGuest.value,
                                              ),
                                            )
                                          : controller.schools.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: Text(
                                                    'My Schools',
                                                    style: AppFonts
                                                        .poppins14BlackBold,
                                                  ),
                                                )
                                              : const SizedBox(),
                                    );
                                  } else if (index - 2 <
                                      controller.schools.length) {
                                    if (controller
                                        .schools[index - 2].duplicate!) {
                                      return const SizedBox();
                                    }
                                    return SListing(
                                      expandText: true,
                                      height: getSizeWrtHeight(98),
                                      headingStyle:
                                          AppFonts.poppinsSemiBold16White,
                                      subHeadingStyle: AppFonts.poppins15Grey,
                                      hasBorder: false,
                                      color: const Color(0xff164B9B),
                                      heading:
                                          controller.schools[index - 2].name,
                                      sub: controller
                                          .schools[index - 2].cityName,
                                      circleColor: Colors.white,
                                      icon: AppImages.maps,
                                      onTap: () async {
                                        controller.update();
                                        controller.openMap(
                                            i: index - 2, whichlist: 0);
                                      },
                                    );
                                  } else if (index ==
                                      controller.schools.length + 2) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                          '${isGuest ? '' : 'All'} Schools',
                                          style: AppFonts.poppins14BlackBold,
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (controller
                                        .allSchools[index -
                                            controller.schools.length -
                                            3]
                                        .hidden!) {
                                      return const SizedBox();
                                    }
                                    return SListing(
                                      expandText: true,
                                      height: getSizeWrtHeight(98),
                                      subHeadingStyle: AppFonts.poppins15Grey,
                                      hasBorder: false,
                                      color: Colors.white,
                                      heading: controller
                                          .allSchools[index -
                                              controller.schools.length -
                                              3]
                                          .name,
                                      sub: controller
                                          .allSchools[index -
                                              controller.schools.length -
                                              3]
                                          .cityName,
                                      circleColor: const Color(0xffECEDEE),
                                      icon: AppImages.maps,
                                      onTap: () async {
                                        controller.openMap(
                                            whichlist: 1,
                                            i: index -
                                                controller.schools.length -
                                                3);
                                      },
                                    );
                                  }
                                }));
                      }),
                    ),
                  ),
                ),
    );
  }
}
