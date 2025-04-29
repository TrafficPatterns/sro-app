import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/get_images.dart';
import 'package:sro/pages/school/school_controller.dart';

import '../../global_widgets/listing.dart';
import '../../services/global_functions.dart';
import '../../themes/app_fonts.dart';

class Legend extends GetView<SchoolController> {
  const Legend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SchoolController>(builder: (controller) {
      return Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            //routes
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Routes',
                style: AppFonts.poppins14BlackBold,
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.connectorPath,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Connector Path',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[0],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) async {
                  await controller.toggleLegend(0, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.studentDrop,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Student Dropoff',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[1],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) async {
                  await controller.toggleLegend(1, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.eb,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Exisiting Bike Path',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[2],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) async {
                  await controller.toggleLegend(2, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.wB,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Suggested Walking and Biking Route',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[3],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) async {
                  await controller.toggleLegend(3, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            // routes
            // shapes
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Shapes',
                style: AppFonts.poppins14BlackBold,
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.park,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Park',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[4],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) async {
                  await controller.toggleLegend(4, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.shape,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Custom Shapes',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[5],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) async {
                  await controller.toggleLegend(5, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            // shapes
            //Markers
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Markers',
                style: AppFonts.poppins14BlackBold,
              ),
            ),
            // Markers
            Listing(
              leading: GetImages(
                image: AppImages.aWStop,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'All-Way Stop',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[6],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) async {
                  await controller.toggleLegend(6, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.flashingCrosswalk,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Flashing Crosswalk',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[7],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(7, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.parkingWalk,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Park and Walk Location',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[8],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(8, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.bT,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Bike Train',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[9],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(9, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.ic,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Carpool',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[10],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(10, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.wSB,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Walking School Bus',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[11],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(11, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.bP,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Bike Path',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[12],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(12, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.sP,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Student Pick Up Location',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[13],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(13, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.tS,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Traffic Signal',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[14],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(14, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.cG,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Crossing Guard',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[15],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(15, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
            Listing(
              leading: GetImages(
                image: AppImages.mC,
                height: getSize(50),
                width: getSize(50),
              ),
              color: Colors.white,
              heigth: getSizeWrtHeight(82),
              title: 'Marked Crosswalk',
              titleStyle: AppFonts.poppins16Black,
              onTraillingTap: null,
              trailing: FlutterSwitch(
                value: controller.legends.value[16],
                height: getSizeWrtHeight(30),
                width: getSize(50),
                onToggle: (value) {
                  controller.toggleLegend(16, value);
                },
                activeColor: const Color(0xff65c466),
              ),
            ),
          ],
        ),
      );
    });
  }
}
