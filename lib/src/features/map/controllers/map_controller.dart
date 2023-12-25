import 'package:fixmystreet/src/models/localtion.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'package:geolocator/geolocator.dart';

class MapControllerHelper {
  static final MapController controller = MapController(
    initMapWithUserPosition:
        const UserTrackingOption(enableTracking: true, unFollowUser: false),
  );
  
  static Future<Location> displayCurrentLocation() async {
    final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final double latitude = location.latitude;
    final double longitude = location.longitude;
    final Location currentLocation =
        Location(latitude: latitude, longitude: longitude);
    controller
        .changeLocation(GeoPoint(latitude: latitude, longitude: longitude));
    controller.setZoom(zoomLevel: 17);
    // Sử dụng giá trị vị trí đã chuyển đổi
    print('Current Location - Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}');
    return currentLocation;
  }

  static Future<void> currentLocation() async {
    await controller.enableTracking(enableStopFollow: false);
    await controller.currentLocation();
    await controller.setZoom(zoomLevel: 15);
  }

  Future<void> zoomIn() async {
    await controller.zoomIn();
  }

  Future<void> zoomOut() async {
    await controller.zoomOut();
  }

  
  static Future<void> changeLocation(lat,long) async{
    controller.changeLocation(GeoPoint(latitude: lat, longitude: long));
  }
}
