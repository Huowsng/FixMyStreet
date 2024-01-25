import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapControllerHelper {
  static final MapControllerHelper _instance = MapControllerHelper._internal();
  List<String> ids = [];
  Map<String, String> idTitleMap = {};
  List<Map<String, dynamic>> pinDetails = [];
  List<GeoPoint> ListGeoPoint = [];
  late MapController mapController;
  factory MapControllerHelper() {
    return _instance;
  }
  MapControllerHelper._internal() {
    mapController = MapController(
        initMapWithUserPosition: const UserTrackingOption(
            enableTracking: true, unFollowUser: false));
  }

  Future<void> displayCurrentLocation() async {
    final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final double latitude = location.latitude;
    final double longitude = location.longitude;
    mapController
        .changeLocation(GeoPoint(latitude: latitude, longitude: longitude));
    mapController.enableTracking(disableUserMarkerRotation: false);
    mapController.setZoom(zoomLevel: 17);
  }

  Future<void> currentLocation() async {
    mapController.enableTracking();
    mapController.currentLocation();
    mapController.setZoom(zoomLevel: 17);
  }

  Future<void> changeLocation(lat, long) async {
    mapController.changeLocation(GeoPoint(latitude: lat, longitude: long));
    await mapController.setZoom(zoomLevel: 17);
  }

  Future<void> getCenterMap() async {
    GeoPoint center_map = await mapController.centerMap;
    print(center_map);
  }

  Future<List<dynamic>> getData() async {
    try {
      double zoom = await mapController.getZoom();
      BoundingBox bounds = await mapController.bounds;
      print(zoom);
      print(bounds);
      final response = await http.get(Uri.parse(
        'http://103.179.189.246:8000/reports/FMS+Th%C3%A0nh+Ph%E1%BB%91+%C4%90%C3%A0+N%E1%BA%B5ng?ajax=1&sort=updated-desc&p=1&zoom=$zoom&bbox=${bounds.north},${bounds.east},${bounds.south},${bounds.west},',
      ));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        final pins = data['pins'];
        print(pins);
        pinDetails.clear();
        ListGeoPoint.clear();
        for (List<dynamic> pin in pins) {
          double latitude = pin[0];
          double longitude = pin[1];
          String id = pin[3].toString();
          String title = pin[4].toString();
          ids.add(id);
          idTitleMap[id] = title;
          Map<String, dynamic> pinDetail = {
            'id': id,
            'lat': latitude,
            'long': longitude,
            'title': title,
          };
          pinDetails.add(pinDetail);
        }
        return data['pins'];
      } else {
        print('Error - Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle errors
      return [];
    }
  }

  Future<void> getReport() async {
    List<GeoPoint> geoPoints = await mapController.geopoints;
    List<dynamic> pins = await getData();
    for (List<dynamic> pin in pins) {
      double latitude = pin[0];
      double longitude = pin[1];
      geoPoints.add(GeoPoint(latitude: latitude, longitude: longitude));
      ListGeoPoint.add(GeoPoint(latitude: latitude, longitude: longitude));
      GeoPoint p = GeoPoint(latitude: latitude, longitude: longitude);
      mapController.addMarker(p,
          markerIcon: MarkerIcon(
            iconWidget: InkWell(
              child: Image.asset(
                'lib/src/assets/images/pin-yellow-big.png',
                width: 50,
                height: 50,
              ),
            ),
          ));
    }
  }

  Future<void> removeReport() async {
    mapController.removeMarkers(ListGeoPoint);
  }
}
