import 'package:fixmystreet/src/assets/icons/icon.dart';
import 'package:fixmystreet/src/component/wiget_icon.dart';
import 'package:fixmystreet/src/features/help/help_screen.dart';
import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:fixmystreet/src/features/map/modules/map_search.dart';
import 'package:fixmystreet/src/models/map_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isLocationAvailable = false;
  String selectedPinId = '';
  String selectedPinTitle = '';
  GeoPoint selectedPoint = GeoPoint(latitude: 0, longitude: 0);
  int startLate = 0;
  int endLate = 0;
  MapControllerHelper mapController = MapControllerHelper();
  setDataControllerMap(int timeout) {
    startLate = DateTime.now().millisecond;
    endLate = startLate + timeout;
    setDataLate();
  }

  setDataLate() async {
    if (DateTime.now().millisecond > endLate) return;
    try {
      mapController.mapController.osmBaseController.getZoom();
      mapController.displayCurrentLocation();
      await Future.delayed(const Duration(seconds: 5));
      mapController.mapController.listenerRegionIsChanging
          .addListener(() async {
        if (mapController.mapController.listenerRegionIsChanging.value !=
            null) {
          mapController.getData();
          await Future.delayed(const Duration(seconds: 1));
          mapController.getReport();
        }
      });
      print("Time Current: ${DateTime.now().millisecond}");
      print("Time max: $endLate");
      return;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1), () => {setDataLate()});
    }
  }

  @override
  void initState() {
    super.initState();
    mapController.mapController;
    setDataControllerMap(5000);
  }

  @override
  Widget build(BuildContext context) {
    bool showHelpScreen = Provider.of<MapState>(context).showHelpScreen;
    double screenWidth = MediaQuery.of(context).size.width;
    // Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: screenWidth * 0.33,
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
        title: Container(
          width: screenWidth * 0.33, // 1/3 của AppBar
          child: Text(
            'FixMyStreet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
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
                  mapController.currentLocation();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: () {},
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
      ),
      body: Stack(
        children: [
          Positioned(
              child: OSMFlutter(
            osmOption: OSMOption(
              isPicker: true,
              zoomOption: const ZoomOption(
                initZoom: 13.0,
                minZoomLevel: 3.0,
                maxZoomLevel: 19.0,
                stepZoom: 1.0,
              ),
              markerOption: MarkerOption(
                  advancedPickerMarker: MarkerIcon(
                    iconWidget: build_Icon(),
                  ),
                  defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56,
                    ),
                  )),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Color.fromARGB(255, 21, 111, 38),
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
            ),
            controller: mapController.mapController,
            onGeoPointClicked: handleGeoPointClicked,
          )),
          Positioned(
            top: 70,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  Provider.of<MapState>(context, listen: false)
                  .setShowHelpScreen(true);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 247, 200, 73), // Đặt góc bo
                ),
                width: 25,
                height: 50,
                child: const Icon(MyFlutterApp.help,
                    color: Colors.grey, size: 25.0),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              child: MapSearch(),
            ),
          ),
          Visibility(
            visible: showHelpScreen,
            child: const Positioned(
              child: HelpScreen(),
          ))
        ],
      ),
    );
  }

  void handleGeoPointClicked(GeoPoint geoPoint) {
    for (Map<String, dynamic> pinDetail in mapController.pinDetails) {
      double lat = pinDetail['lat'];
      double long = pinDetail['long'];

      if (lat == geoPoint.latitude && long == geoPoint.longitude) {
        String id = pinDetail['id'];
        String title = pinDetail['title'];

        // Thay thế showDialog bằng DraggableScrollableSheet
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.5, // Kích thước ban đầu của sheet
              minChildSize: 0.2, // Kích thước tối thiểu của sheet
              maxChildSize: 0.8, // Kích thước tối đa của sheet
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Báo cáo: $title',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {},
                        child: const Text(
                          'Chi tiết',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      // Thêm nội dung khác của bạn vào đây
                    ],
                  ),
                );
              },
            );
          },
        );

        setState(() {
          selectedPoint = geoPoint;
          selectedPinId = id;
          selectedPinTitle = title;
        });
      }
    }
  }
}
