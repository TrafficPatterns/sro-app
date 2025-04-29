import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sro/pages/events/events_controller.dart';

import '../../global_widgets/custom_button.dart';
import '../../global_widgets/map.dart';
import '../../services/global_functions.dart';
import '../../themes/app_fonts.dart';

class MapChooser extends StatefulWidget {
  const MapChooser({Key? key}) : super(key: key);

  @override
  State<MapChooser> createState() => _MapChooserState();
}

class _MapChooserState extends State<MapChooser> {
  LatLng? latLng;
  late EventsController _controller;
  @override
  void initState() {
    _controller = Get.put(EventsController());
    latLng = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: latLng!,
      zoom: 19.151926040649414,
    );
    return WillPopScope(
      onWillPop: () async {
        _controller.location.value = latLng;
        // Get.offAndToNamed(AppRoutes.addEvents);
        Get.back();
        _controller.location.refresh();
        return false;
      },
      child: Scaffold(
          body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            MapView(
                initialPosition: initialPosition,
                hasCompass: false,
                onCameraMove: (value) {
                  setState(() {
                    latLng = value.target;
                  });
                },
                markers: {
                  Marker(
                    icon: _controller.icon.value,
                    markerId: const MarkerId('location'),
                    position: latLng!,
                  )
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                  height: getSizeWrtHeight(65),
                  widthh: getSize(90),
                  onTap: () {
                    _controller.location.value = latLng;
                    Get.back();
                    _controller.location.refresh();
                  },
                  text: 'Done',
                  textStyle: AppFonts.poppinsMedium16White,
                  color: const Color(0xff164B9B),
                  textColor: Colors.white,
                  borderColor: const Color(0xff164B9B),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
