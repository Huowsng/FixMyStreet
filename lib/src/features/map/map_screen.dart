import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:fixmystreet/src/features/map/modules/map_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Position currentPosition;
  bool isLocationAvailable = false;

  @override
  void initState() {
    super.initState();

    MapControllerHelper.displayCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: screenWidth * 0.29,
          height: screenWidth * 0.1,
          margin: EdgeInsets.only(
              left: screenWidth * 0.02, bottom: screenWidth * 0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Color.fromARGB(255, 228, 197, 61),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: GestureDetector(
              onTap: () {
                // Xử lý khi nhấn vào phần leading
                print('leading clicked');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Tài khoản',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      // Xử lý khi nhấn vào biểu tượng tài khoản
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        centerTitle: true,
        title:
            Text('FixMyStreet', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 247, 200, 73),
        actions: <Widget>[
          Container(
            width: screenWidth * 0.29,
            height: screenWidth * 0.1,
            margin: EdgeInsets.only(
                right: screenWidth * 0.02, bottom: screenWidth * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Color.fromARGB(255, 228, 197, 61),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: GestureDetector(
                onTap: () {
                  // Handle the onPressed event for the padding area
                  print('av');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: () {
                        // Xử lý khi nhấn vào biểu tượng tài khoản
                      },
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Tài khoản',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          child: SizedBox(height: 10.0), // Đặt chiều cao để tạo khoảng cách
          preferredSize:
              Size.fromHeight(0.0), // Đặt chiều cao là 0 để ẩn bottom space
        ),
      ),
      body: Stack(
        children: [
          OSMFlutter(
              controller: MapControllerHelper.controller,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(
                  initZoom: 13,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                markerOption: MarkerOption(
                    defaultMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 56,
                  ),
                )),
              )),
          Positioned(
            top: 50,
            left: 20,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                child: MapSearch(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
