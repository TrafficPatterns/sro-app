import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/flutter_svg.dart';

enum AppImages {
  park,
  appLogoBlack,
  appLogoWhite,
  mapGig,
  delete,
  add,
  settings,
  notifications,
  events,
  maps,
  bike,
  bus,
  car,
  arrow,
  avatar,
  notificationSettings,
  privacySettings,
  termsSettings,
  version,
  logout,
  search,
  send,
  marker,
  filter,
  aWStop,
  flashingCrosswalk,
  parkingWalk,
  studentDrop,
  shape,
  connectorPath,
  eb,
  ic,
  wSB,
  bT,
  bP,
  sP,
  tS,
  cG,
  wB,
  directions,
  walking,
  locTracking,
  read,
  mC,
}

class GetImages extends StatelessWidget {
  final double? width;
  final double? height;
  final AppImages? image;
  final double? scale;
  final Function? onTap;
  final Color? color;
  final bool? hasColor;
  final BoxFit? fit;

  const GetImages(
      {Key? key,
      this.width,
      this.height,
      this.image,
      this.scale,
      this.onTap,
      this.color,
      this.fit,
      this.hasColor = false})
      : super(key: key);

  get imagesMap => {
        AppImages.appLogoBlack: "assets/images/logo.png",
        AppImages.appLogoWhite: "assets/images/logo_white.png",
        AppImages.mapGig: "assets/gif/map.gif",
        AppImages.marker: "assets/images/markerS.png",
        AppImages.aWStop: "assets/images/markers/AW_STOP.png",
        AppImages.flashingCrosswalk: "assets/images/markers/FC.png",
        AppImages.parkingWalk: "assets/images/markers/PW.png",
        AppImages.studentDrop: "assets/images/markers/SD.png",
        AppImages.park: "assets/images/markers/park.png",
        AppImages.shape: "assets/images/markers/P.png",
        AppImages.connectorPath: "assets/images/markers/CP.png",
        AppImages.ic: "assets/images/markers/IC.png",
        AppImages.wSB: "assets/images/markers/WSB.png",
        AppImages.bT: "assets/images/markers/BT.png",
        AppImages.bP: "assets/images/markers/BP.png",
        AppImages.sP: "assets/images/markers/SP.png",
        AppImages.tS: "assets/images/markers/TS.png",
        AppImages.cG: "assets/images/markers/CG.png",
        AppImages.wB: "assets/images/markers/WB.png",
        AppImages.eb: "assets/images/markers/EB.png",
        AppImages.mC: "assets/images/markers/MC.png",
        AppImages.directions: "assets/images/directions.png",
        AppImages.walking: "assets/images/walking.png",
        AppImages.locTracking: "assets/images/tracking.png",
        AppImages.read: "assets/images/read.png",
      };
  get svgMap => {
        AppImages.delete: "assets/svg/delete.svg",
        AppImages.add: "assets/svg/add.svg",
        AppImages.settings: "assets/svg/settings.svg",
        AppImages.notifications: "assets/svg/notifications.svg",
        AppImages.events: "assets/svg/events.svg",
        AppImages.maps: "assets/svg/maps.svg",
        AppImages.bike: "assets/svg/bike.svg",
        AppImages.bus: "assets/svg/bus.svg",
        AppImages.car: "assets/svg/car.svg",
        AppImages.arrow: "assets/svg/arrow.svg",
        AppImages.avatar: "assets/svg/avatar.svg",
        AppImages.notificationSettings:
            "assets/svg/notifiactions_settings_bg.svg",
        AppImages.privacySettings: "assets/svg/privacy_bg.svg",
        AppImages.termsSettings: "assets/svg/terms_bg.svg",
        AppImages.version: "assets/svg/versio_bg.svg",
        AppImages.logout: "assets/svg/logout_bg.svg",
        AppImages.search: "assets/svg/search.svg",
        AppImages.send: "assets/svg/send.svg",
        AppImages.filter: "assets/svg/filter.svg"
      };
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap as void Function()?,
          customBorder: const CircleBorder(),
          child: SizedBox(
              width: width,
              height: height,
              child: imagesMap[image] != null
                  ? Image.asset(
                      imagesMap[image],
                      // width: width,
                      color: color,
                      // height: height,
                      scale: scale ?? 1.0,
                      fit: BoxFit.scaleDown,
                    )
                  : SvgPicture.asset(
                      svgMap[image],
                      width: width,
                      height: height,
                      color: color,
                      fit: fit ?? BoxFit.scaleDown,
                    )),
        ));
  }
}
