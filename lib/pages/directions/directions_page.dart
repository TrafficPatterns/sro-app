import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/map.dart';
import 'package:sro/global_widgets/scaffold_with_header.dart';
import 'package:sro/pages/directions/directions_controller.dart';
import 'package:sro/themes/app_fonts.dart';

enum TravelMode { bike, walking, car }

// ignore: non_constant_identifier_names
var TravelModeMap = <TravelMode, String>{
  TravelMode.car: 'driving',
  TravelMode.bike: 'bicycling',
  TravelMode.walking: 'walking',
};

// ignore: non_constant_identifier_names
var TravelModeMapReverse = <String, TravelMode>{
  'driving': TravelMode.car,
  'bicycling': TravelMode.bike,
  'walking': TravelMode.walking,
  'DRIVING': TravelMode.car,
  'BICYCLING': TravelMode.bike,
  'WALKING': TravelMode.walking,
};

class DirectionsPage extends GetView<DirectionsController> {
  const DirectionsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.resetParams();
        return true;
      },
      child: HeaderScaffold(
        leading: BackButton(
          onPressed: () {
            controller.resetParams();
            Get.back();
          },
          color: Colors.black,
        ),
        label: 'Directions to ${controller.school.value.name}',
        headerStyle: AppFonts.poppins14BlackBold,
        centerTitle: true,
        child: GetBuilder<DirectionsController>(builder: (controller) {
          return Expanded(
            child: Stack(
              children: [
                MapView(
                  myLocation: true,
                  polylines: controller.getRoute,
                  controller: controller.mapController,
                  markers: controller.markers.value,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.showFullDirections();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.all(10),
                              child: HtmlWidget(
                                controller.instruction,
                                textStyle: AppFonts.poppins18Black,
                              )),
                        ),
                        if (controller.meters.value != null)
                          const SizedBox(height: 10),
                        if (controller.meters.value != null)
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              controller.meter,
                              style: AppFonts.poppins18Black,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (controller.offTrack.value ||
                    controller.reached.value != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300]!.withOpacity(0.5)),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                controller.reached.value ??
                                    'Your are going off the calculate route!',
                                style: AppFonts.poppins14Black,
                              ),
                              TextButton(
                                  onPressed: () {
                                    if (controller.reached.value == null) {
                                      controller.calculateRoute(
                                          recalculte: true);
                                    } else {
                                      Get.back();
                                    }
                                  },
                                  child: Text(
                                    controller.reached.value == null
                                        ? 'Recalculate Route'
                                        : 'Exit Route',
                                    style: AppFonts.poppins14Blue,
                                  ))
                            ],
                          )),
                    ),
                  )
              ],
            ),
          );
        }),
      ),
    );
  }
}
