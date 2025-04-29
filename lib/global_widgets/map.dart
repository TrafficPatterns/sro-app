import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final CameraPosition? initialPosition;
  final Completer<GoogleMapController>? controller;
  final bool? hasZoom;
  final bool? hasCompass;
  final bool? lockGestures;
  final bool? liteMode;
  final bool? myLocation;
  final bool? markerAtInitial;
  final Set<Marker>? markers;
  final MinMaxZoomPreference? minMaxZoomPreference;
  final Set<Circle>? circles;
  final Set<Polyline>? polylines;
  final Set<Polygon>? polygons;
  final BitmapDescriptor? initialMarker;
  final VoidCallback? onIdle;
  final Function(CameraPosition)? onCameraMove;
  final Function(LatLng)? onTap;
  const MapView(
      {Key? key,
      this.initialPosition,
      this.controller,
      this.hasZoom = true,
      this.markerAtInitial = false,
      this.onCameraMove,
      this.liteMode = false,
      this.lockGestures = false,
      this.hasCompass = true,
      this.markers,
      this.onTap,
      this.circles,
      this.polygons,
      this.polylines,
      this.initialMarker,
      this.minMaxZoomPreference,
      this.onIdle,
      this.myLocation = false})
      : super(key: key);

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late Completer<GoogleMapController> _controller;
  @override
  void initState() {
    _controller = widget.controller ?? Completer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initial;
    if (widget.initialPosition == null) {
      initial = const CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(37.43296265331129, -122.08832357078792),
          zoom: 19.151926040649414);
    } else {
      initial = widget.initialPosition!;
    }
    var temp = (widget.markers ?? {});
    if (widget.markerAtInitial! && widget.initialPosition != null) {
      temp.add(Marker(
          markerId: const MarkerId('initial'),
          position: initial.target,
          icon: widget.initialMarker ?? BitmapDescriptor.defaultMarker));
    }
    return GoogleMap(
      minMaxZoomPreference:
          widget.minMaxZoomPreference ?? const MinMaxZoomPreference(0, 20),
      markers: temp,
      onTap: widget.onTap ?? (_) {},
      circles: widget.circles ?? {},
      onCameraIdle: widget.onIdle,
      onCameraMove: widget.onCameraMove,
      zoomControlsEnabled: widget.hasZoom!,
      compassEnabled: widget.hasCompass!,
      scrollGesturesEnabled: !widget.lockGestures!,
      myLocationEnabled: widget.myLocation ?? false,
      tiltGesturesEnabled: !widget.lockGestures!,
      zoomGesturesEnabled: !widget.lockGestures!,
      rotateGesturesEnabled: !widget.lockGestures!,
      liteModeEnabled: false,
      polygons: widget.polygons ?? {},
      polylines: widget.polylines ?? {},
      mapType: MapType.normal,
      initialCameraPosition: initial,
      buildingsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
    );
  }

  Future<void> goTo(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }
}
