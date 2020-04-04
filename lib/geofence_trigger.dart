import 'dart:async';

import 'package:geofencing/geofencing.dart';
import 'package:geolocator/geolocator.dart';

abstract class GeofenceTrigger {
  // Geofencing state.
  static final _androidSettings = AndroidGeofencingSettings(initialTrigger: [
    GeofenceEvent.enter,
    GeofenceEvent.exit,
  ], notificationResponsiveness: 0, loiteringDelay: 0);

  static bool _isInitialized = false;
  static StreamSubscription _locationUpdates;

  static Future<void> _initialize() async {
    if (!_isInitialized) {
      _isInitialized = true;
    }
  }

  static Future<void> _startUpdates() async {
    print('Starting location updates');
    await GeofencingManager.promoteToForeground();
    _locationUpdates =
        (await Geolocator().getPositionStream()).listen(_handleLocationUpdate);
  }

  static Future<void> _stopUpdates() async {
    await _locationUpdates?.cancel();
    _locationUpdates = null;
    await GeofencingManager.demoteToBackground();
  }

  static Future<void> _handleLocationUpdate(Position p) async {
    final home = homeRegion.location;
    final distance = await Geolocator().distanceBetween(
        p.latitude, p.longitude, home.latitude, home.longitude);
    print('Distance to home: $distance');
    if (distance < 100.0) {
      await _stopUpdates();
    }
  }

  static final homeRegion = GeofenceRegion(
      'home',
      0.0,
      0.0,
      1000.0,
      <GeofenceEvent>[
        GeofenceEvent.enter,
        GeofenceEvent.exit,
      ],
      androidSettings: _androidSettings);

  static Future<void> homeGeofenceCallback(
      List<String> id, Location location, GeofenceEvent event) async {
    await _initialize();
    if (event == GeofenceEvent.enter) {
      await _startUpdates();
    } else if ((event == GeofenceEvent.exit) && (_locationUpdates != null)) {
      await _stopUpdates();
    }
  }
}
