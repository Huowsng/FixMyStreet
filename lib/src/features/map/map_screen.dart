import 'package:fixmystreet/src/assets/icons/icon.dart';
import 'package:fixmystreet/src/component/icon_widget.dart';
import 'package:fixmystreet/src/features/auth/login_screen.dart';
import 'package:fixmystreet/src/features/help/help_screen.dart';
import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:fixmystreet/src/features/map/components/map_search.dart';
import 'package:fixmystreet/src/features/report/report_screen.dart';
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
  late MapState mapState;
  late AppBarStateManager appBarState;
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
    mapState = Provider.of<MapState>(context, listen: false);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = kToolbarHeight;
    double bodyHeight = screenHeight - appBarHeight;
    appBarState = Provider.of<AppBarStateManager>(context, listen: false);
    currentAppBarState = appBarState.appBarState;
    // Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: Consumer<AppBarStateManager>(
          builder: (context, mapState, child) {
            return buildAppBar(context, appBarState.appBarState);
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
                  mapState.setShowHelpScreen(true);
                  mapState.setShowIcon(false);
                  mapState.setShowTextButton(false);
                  print(mapState.showHelpScreen);
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
              visible: mapState.showHelpScreen,
              child: const Positioned(
                child: HelpScreen(),
              )),
          Visibility(
              visible: mapState.showReportScreen,
              child: const Positioned(
                child: ReportScreen(),
              )),
          Visibility(
            visible: mapState.showTextButoon,
            child: Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (appBarState.appBarState == 1) {
                        changeAppBarState(context, 2);
                        // Nếu icon đang hiển thị, thực hiện các hành động khi ấn vào "Xác thực vị trí"
                        mapState.setShowIcon(true);
                        mapState.setShowPinIcon(true);
                      } else {
                        changeAppBarState(context, 3);
                        mapController.getCenterMap();
                        mapState.setShowReportScreen(true);
                        mapState.setShowIcon(false);
                        mapState.setShowPinIcon(false);
                        mapState.setShowTextButton(false);
                      }
                    });
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
                    child: Center(
                      child: Text(
                        (appBarState.appBarState == 1)
                            ? "Báo cáo mới tại đây"
                            : (appBarState.appBarState == 2
                                ? "Xác thực vị trí"
                                : ""),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )),
          ),
          Visibility(
            visible: mapState.showIcon,
            child: Positioned(
              top: (bodyHeight - 150) /
                  2, // (Chiều cao màn hình - Chiều cao icon) / 2
              left: (screenWidth - 100) /
                  2, // (Chiều rộng màn hình - Chiều rộng icon) / 2
              child: Image.asset(
                'lib/src/assets/images/crosshairs@x2.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Visibility(
            visible: mapState.showPinIcon,
            child: Positioned(
              top: (bodyHeight - 250) /
                  2, // (Chiều cao màn hình - Chiều cao icon) / 2
              left: (screenWidth - 100) /
                  2, // (Chiều rộng màn hình - Chiều rộng icon) / 2
              child: Image.asset(
                'lib/src/assets/images/pin@x2.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Visibility(
              visible: mapState.showLogin,
              child: Positioned(
                child: LoginScreen(),
              ))
        ],
      ),
    );
  }

// ///////////////////////////////////////////

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

  void changeAppBarState(context, int newState) {
    // Use the provider to update the app bar state
    Provider.of<AppBarStateManager>(context, listen: false)
        .setAppBarState(newState);
  }

  AppBar buildAppBar(context, int state) {
    switch (state) {
      case 1:
        return buildAppBarState1(context);
      case 2:
        return buildAppBarState2(context);
      case 3:
        return buildAppBarState3(context);
      case 4:
        return buildAppBarState4(context);
      case 5:
        return buildAppBarState5(context);
      case 6:
        return buildAppBarStateLogin(context);
      default:
        return buildAppBarState1(context);
    }
  }

// Build AppBar

  AppBar buildAppBarState1(context) {
    return AppBar(
      leading: buildAppBarLeadingDefault(context, screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBarTitle(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
      actions: <Widget>[
        buildAppBarAcctionDefault(context, screenWidth, screenHeight),
      ],
    );
  }

  AppBar buildAppBarState2(context) {
    return AppBar(
      leading: buildAppBarLeadingBack(context, screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBarTitle(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
    );
  }

  AppBar buildAppBarState3(context) {
    return AppBar(
      leading: buildAppBarLeadingBack(context, screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBar3(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
      actions: <Widget>[
        buildAppBarAcction3(context, screenWidth, screenHeight),
      ],
    );
  }

  AppBar buildAppBarState4(context) {
    return AppBar(
      leading: buildAppBarLeadingBack(context, screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBar4(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
      actions: <Widget>[
        buildAppBarAcction4(context, screenWidth, screenHeight),
      ],
    );
  }

  AppBar buildAppBarState5(context) {
    return AppBar(
      leading: buildAppBarLeadingBack(context, screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBar5(screenWidth),
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
    );
  }

  AppBar buildAppBarStateLogin(context) {
    return AppBar(
      leading: buildAppBarLeadingLogin(context, screenWidth, screenHeight),
      title: buildAppBarTitleLogin(screenWidth),
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 247, 200, 73),
    );
  }

  Widget buildAppBarTitleLogin(double screenWidth) {
    return Container(
      width: screenWidth * 0.33, // 1/3 của AppBar
      child: Text(
        'Đăng nhập',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildAppBarLeadingLogin(
      context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.23,
      height: screenHeight * 0.05,
      margin: EdgeInsets.only(
          top: screenHeight * 0.01,
          left: screenWidth * 0.02,
          bottom: screenHeight * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 211, 181, 47),
      ),
      child: GestureDetector(
        onTap: () {},
        child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                if (appBarState.appBarState == 6) {
                  changeAppBarState(context, 1);
                  mapState.setShowLogin(false);
                }
              });
            }),
      ),
    );
  }

  Widget buildAppBarTitle(double screenWidth) {
    return Container(
      width: screenWidth * 0.33, // 1/3 của AppBar
      child: Text(
        'FixMyStreet',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildAppBar3(double screenWidth) {
    return Container(
      width: screenWidth * 0.33, // 1/3 của AppBar
      child: Text(
        'Thêm ảnh',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildAppBar4(double screenWidth) {
    return Container(
      width: screenWidth * 0.33, // 1/3 của AppBar
      child: Text(
        'Chi tiết',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildAppBar5(double screenWidth) {
    return Container(
      width: screenWidth * 0.33, // 1/3 của AppBar
      child: Text(
        'Chi tiết của bạn',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildAppBarLeadingDefault(
      context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.33,
      margin:
          EdgeInsets.only(left: screenWidth * 0.02, bottom: screenWidth * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Color.fromARGB(255, 228, 197, 61),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GestureDetector(
          onTap: () {},
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
    );
  }

  Widget buildAppBarAcctionDefault(
      context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.23,
      height: screenHeight * 0.05,
      margin: EdgeInsets.only(
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 211, 181, 47),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              changeAppBarState(context, 6);
              mapState.setShowLogin(true);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle),
              const Text(
                'Tài khoản',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBarLeadingBack(
      context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.23,
      height: screenHeight * 0.05,
      margin: EdgeInsets.only(
          top: screenHeight * 0.01,
          left: screenWidth * 0.02,
          bottom: screenHeight * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 211, 181, 47),
      ),
      child: GestureDetector(
        onTap: () {},
        child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                if (appBarState.appBarState != 1) {
                  changeAppBarState(context, appBarState.appBarState - 1);
                  if (appBarState.appBarState == 2) {
                    mapState.setShowTextButton(true);
                    mapState.setShowIcon(true);
                    mapState.setShowPinIcon(true);
                    mapState.setShowReportScreen(false);
                  } else if (appBarState.appBarState == 1) {
                    mapState.setShowIcon(true);
                    mapState.setShowPinIcon(false);
                  } else {
                    mapState.setShowIcon(false);
                    mapState.setShowPinIcon(false);
                  }
                }
              });
            }),
      ),
    );
  }

  Widget buildAppBarAcction3(context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.23,
      height: screenHeight * 0.05,
      margin: EdgeInsets.only(
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 211, 181, 47),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              changeAppBarState(context, 4);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bỏ qua',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBarAcction4(context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.24,
      height: screenHeight * 0.05,
      margin: EdgeInsets.only(
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 211, 181, 47),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              changeAppBarState(context, 5);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tiếp theo',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
