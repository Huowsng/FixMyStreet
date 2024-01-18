import 'dart:convert';
import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:http/http.dart' as http;

class SearchControllerHelper {
  List<String> addresses = [];
  List<double> latitudes = [];
  List<double> longitudes = [];
  String message = '';
  MapControllerHelper mapController = MapControllerHelper();

  Future<void> getAddresses(String term) async {
    try {
      final response = await http.get(Uri.parse(
          'http://103.179.189.246:8000/ajax/lookup_location?term=$term'));
      addresses.clear();
      latitudes.clear();
      longitudes.clear();
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data['locations'] != null) {
          // Trường hợp có dữ liệu về địa điểm và tọa độ
          final locations = data['locations'];

          // Clear the existing addresses and latitudes lists

          for (var location in locations) {
            final address = location['address'];
            final lat = location['lat'];
            final long = location['long'];

            // Add the address to the addresses list
            addresses.add(address);

            // Add the latitude to the latitudes list
            latitudes.add(double.parse(lat));
            longitudes.add(double.parse(long));
          }
        } else if (data['latitude'] != null && data['longitude'] != null) {
          // Trường hợp có dữ liệu tọa độ
          final double? lat = double.tryParse(data['latitude'].toString());
          final double? long = double.tryParse(data['longitude'].toString());
          mapController.changeLocation(lat, long);
        } else if (data['error'] != null) {
          final msg = data['error'];
          message = msg;
        }
      } else {
        // Handle non-200 status code if needed
      }
    } catch (error) {
      // Handle errors
    }
  }
}
