import 'package:fixmystreet/main.dart';
import 'package:fixmystreet/src/assets/icons/icon.dart';
import 'package:fixmystreet/src/component/appbar_widget.dart';
import 'package:fixmystreet/src/component/icon_widget.dart';
import 'package:fixmystreet/src/features/help/help_screen.dart';
import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:fixmystreet/src/features/map/modules/map_search.dart';
import 'package:fixmystreet/src/providers/map_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';

import '../../providers/appbar_states.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  bool isLocationAvailable = false;
  String selectedPinId = '';
  String selectedPinTitle = '';
  GeoPoint selectedPoint = GeoPoint(latitude: 0, longitude: 0);
  int startLate = 0;
  int endLate = 0;
  int currentAppBarState = 1;
  MapControllerHelper mapController = MapControllerHelper();
  setDataControllerMap(int timeout) {
    startLate = DateTime.now().millisecond;
    endLate = startLate + timeout;
    setDataLate();
  }

  setDataLate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (DateTime.now().millisecond > endLate) return;
    try {
      mapController.mapController.osmBaseController.getZoom();
      mapController.displayCurrentLocation();
      await Future.delayed(const Duration(seconds: 5));
      mapController.mapController.listenerRegionIsChanging
          .addListener(() async {
        if (mapController.mapController.listenerRegionIsChanging.value !=
            null) {
          setState(() {
            Provider.of<MapState>(context, listen: false).setShowIcon(true);
          });
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
    bool showIcon = Provider.of<MapState>(context).showIcon;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = kToolbarHeight;
    double bodyHeight = screenHeight - appBarHeight;
    // Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: Builder(
          builder: (BuildContext appBarContext) {
            // Access the provider to get the current app bar state
            currentAppBarState = Provider.of<AppBarStateManager>(appBarContext)
                .appBarState
                .state;

            // Build the app bar based on the current state
            return buildAppBar(currentAppBarState);
          },
        ),
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
                  Provider.of<MapState>(context, listen: false)
                      .setShowIcon(false);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 211, 190, 7), // Đặt góc bo
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
              )),
          Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => {
                  changeAppBarState(context, 2),
                  mapController.getCenterMap(),
                  Provider.of<MapState>(context, listen: false)
                      .setShowIcon(false),
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 211, 190, 7),
                      border: Border.all(
                        color: Colors.black, // Màu sắc của đường viền
                        width: 0.5, // Độ dày của đường viền
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  width: screenWidth,
                  height: 50,
                  // color: Color.fromARGB(255, 211, 190, 7),
                  child: const Center(
                    child: Text(
                      "Báo cáo mới tại đây",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
          Visibility(
            visible: showIcon,
            child: Positioned(
              top: (bodyHeight - 125) /
                  2, // (Chiều cao màn hình - Chiều cao icon) / 2
              left: (screenWidth - 75) /
                  2, // (Chiều rộng màn hình - Chiều rộng icon) / 2
              child: Image.asset(
                'lib/src/assets/images/crosshairs@x2.png',
                width: 75,
                height: 75,
              ),
            ),
          )
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

  void changeAppBarState(BuildContext context, int newState) {
    // Use the provider to update the app bar state
    Provider.of<AppBarStateManager>(context, listen: false)
        .setAppBarState(newState);
  }

  AppBar buildAppBar(int state) {
    switch (state) {
      case 1:
        return buildAppBarState1();
      case 2:
        return buildAppBarState2();
      case 3:
        return buildAppBarState3();
      case 4:
        return buildAppBarState4();
      case 5:
        return buildAppBarState5();
      // ... thêm các trạng thái app bar khác ...
      default:
        return buildAppBarState1();
    }
  }

  AppBar buildAppBarState1() {
    return AppBar(
      leading: buildAppBarLeadingDefault(screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBarTitle(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
      actions: <Widget>[
        buildAppBarAcctionDefault(screenWidth, screenHeight),
      ],
    );
  }

  AppBar buildAppBarState2() {
    return AppBar(
      leading: buildAppBarLeadingBack(screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBarTitle(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
    );
  }

  AppBar buildAppBarState3() {
    return AppBar(
      leading: buildAppBarLeadingBack(screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBar3(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
      actions: <Widget>[
        buildAppBarAcction3(screenWidth, screenHeight),
      ],
    );
  }

  AppBar buildAppBarState4() {
    return AppBar(
      leading: buildAppBarLeadingBack(screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBar4(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
      actions: <Widget>[
        buildAppBarAcction4(screenWidth, screenHeight),
      ],
    );
  }

  AppBar buildAppBarState5() {
    return AppBar(
      leading: buildAppBarLeadingBack(screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBar5(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
    );
  }
}
