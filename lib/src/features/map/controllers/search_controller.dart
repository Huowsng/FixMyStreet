import 'dart:convert';

import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:http/http.dart' as http;

class SearchControllerHelper {
  static List<String> addresses = [];
  static Future<void> getAddresses(String term) async {
    try {
      final response = await http.get(Uri.parse(
          'http://103.179.189.246:8000/ajax/lookup_location?term=$term'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<String> address = List<String>.from(data['suggestions']);
        addresses = address;
        print(addresses);

        if (data['latitude'] != null) {
          // Trường hợp có dữ liệu tọa độ
          final lat = data['latitude'];
          final long = data['longitude'];
          MapControllerHelper.changeLocation(lat, long);
        } else if (data['suggestions'] != null) {
          // Trường hợp có gợi ý và địa điểm liên quan
          final suggestions = data['suggestions'];
          final locations = data['locations'];
        } else {
          // Trường hợp lỗi khác
          final errorMsg = data['error'];
        }
      } else {}
    } catch (error) {}
  }
}
