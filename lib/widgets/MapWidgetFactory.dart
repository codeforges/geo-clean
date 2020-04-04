import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoclean/geofence_trigger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget {
  GoogleMapController _controller;
  static final LatLng _center = LatLng(
      GeofenceTrigger.homeRegion.location.latitude,
      GeofenceTrigger.homeRegion.location.longitude);

  Set<Circle> circles = Set.from([
    new Circle(
        circleId: CircleId("123rqwed"),
        radius: GeofenceTrigger.homeRegion.radius,
        center: _center)
  ]);

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Widget _map;

  MapWidget.build() {
    _map = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      circles: circles,
    );
  }

  Widget get map => _map;

  GoogleMapController get controller => _controller;
}
