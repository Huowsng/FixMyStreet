import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class Location {
  final double latitude;
  final double longitude;
  Location({required this.latitude, required this.longitude});
}

class Pin {
  final double latitude;
  final double longitude;
  final String id;
  final String title;

  Pin(
      {required this.latitude,
      required this.longitude,
      required this.id,
      required this.title});
}
class Data {
  List<Map<String, dynamic>> pinDetails = [];
  List<GeoPoint> listGeoPoint = [];
  Map<String, String> idTitleMap = {};
  List<String> ids = [];
}