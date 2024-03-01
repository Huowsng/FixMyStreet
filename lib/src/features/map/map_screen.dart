import 'package:fixmystreet/src/assets/icons/icon.dart';
import 'package:fixmystreet/src/features/auth/constants.dart';
import 'package:fixmystreet/src/features/draft/constants.dart';
import 'package:fixmystreet/src/features/map/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import '../../component/constants.dart';
import '../../models/constants.dart';
import '../../providers/constants.dart';
import '../../services/draft_service.dart';
import '../help/constants.dart';
import '../report/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Draft draftModel = Draft();
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
      await Future.delayed(const Duration(seconds: 2));
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
      mapController.mapController.listenerMapSingleTapping
          .addListener(() async {
        if (mapController.mapController.listenerMapSingleTapping.value !=
            null) {
          setState(() {
            mapState.setShowPinDetail(false);
          });
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
    mapState = Provider.of<MapState>(context, listen: true);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = kToolbarHeight;
    double bodyHeight = screenHeight - appBarHeight;
    appBarState = Provider.of<AppBarStateManager>(context, listen: true);
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
                        color: AppColors.appBarColor,
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
                        style: const TextStyle(
                          color: AppColors.black,
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
            child: Consumer<MapState>(
              builder: (context, mapState, child) {
                return Positioned(child: LoginScreen());
              },
            ),
          ),
          Visibility(
              visible: mapState.showRegister,
              child: Positioned(
                child: Consumer<MapState>(
                  builder: (context, mapState, child) {
                    return RegisterScreen();
                  },
                ),
              )),
          Visibility(
              visible: mapState.showPinDetail,
              child: Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight * 0.8,
                  child: bottomDetailsSheet(selectedPinId, selectedPinTitle),
                ),
              )),
          Visibility(
              visible: mapState.showDraft,
              child: Positioned(
                child: Consumer<MapState>(builder: (context, mapState, child) {
                  return DraftScreen();
                }),
              ))
        ],
      ),
    );
  }

// ///////////////////////////////////////////

  void handleGeoPointClicked(GeoPoint geoPoint) {
    for (Pin pin in mapController.pinData) {
      double lat = pin.latitude;
      double long = pin.longitude;
      print(pin.id);
      if (lat == geoPoint.latitude && long == geoPoint.longitude) {
        String id = pin.id;
        String title = pin.title;

        setState(() {
          mapState.setShowPinDetail(true);
          selectedPoint = geoPoint;
          selectedPinId = id;
          selectedPinTitle = title;
        });
      }
    }
  }

  Widget bottomDetailsSheet(String id, String title) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned(
                top: -10,
                child: Container(
                  width: 100,
                  height: 7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.black),
                )),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    Text('ID: $id'),
                    Text('Title: $title'),
                    Text('Title: $title'),
                    Text('Title: $title'),
                    // Thêm các widget khác cần thiết tại đây
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
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
      case 7:
        return buildAppBarStateRegister(context);
      case 8:
        return buildAppBarStateDraft(context);
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
      backgroundColor: AppColors.appBarColor,
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
      backgroundColor: AppColors.appBarColor,
    );
  }

  AppBar buildAppBarState3(context) {
    return AppBar(
      leading: buildAppBarLeadingBack(context, screenWidth, screenHeight),
      centerTitle: true,
      title: buildAppBar3(screenWidth),
      backgroundColor: AppColors.appBarColor,
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
      backgroundColor: AppColors.appBarColor,
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
      backgroundColor: AppColors.appBarColor,
    );
  }

  AppBar buildAppBarStateLogin(context) {
    return AppBar(
      leading: buildAppBarLeadingLogin(context, screenWidth, screenHeight),
      title: buildAppBarTitleLogin(screenWidth),
      centerTitle: true,
      backgroundColor: AppColors.appBarColor,
    );
  }

  AppBar buildAppBarStateRegister(context) {
    return AppBar(
      leading: buildAppBarLeadingLogin(context, screenWidth, screenHeight),
      title: buildAppBarTitleRegister(screenWidth),
      centerTitle: true,
      backgroundColor: AppColors.appBarColor,
    );
  }

  AppBar buildAppBarStateDraft(context) {
    return AppBar(
      leading: buildAppBarLeadingLogin(context, screenWidth, screenHeight),
      title: buildAppBarTitleDraft(screenWidth),
      centerTitle: true,
      backgroundColor: AppColors.appBarColor,
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

  Widget buildAppBarTitleRegister(double screenWidth) {
    return Container(
      width: screenWidth * 0.33, // 1/3 của AppBar
      child: Text(
        'Đăng kí',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildAppBarTitleDraft(double screenWidth) {
    return Container(
      width: screenWidth * 0.33, // 1/3 của AppBar
      child: Text(
        'Bản nháp',
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
        color: AppColors.appBarColorComponent,
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
                if (appBarState.appBarState > 5) {
                  changeAppBarState(context, 1);
                  mapState.setShowLogin(false);
                  mapState.setShowRegister(false);
                  mapState.setShowDraft(false);
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
        color: AppColors.appBarColorComponent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GestureDetector(
          onTap: () {
            mapState.setShowDraft(true);
            appBarState.setAppBarState(8);
          },
          child: Stack(
            children: [
              Icon(Icons.drafts, size: 50), // Biểu tượng
              FutureBuilder<int>(
                future: DraftService.getDraftCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // Hiển thị gì đó khi đang đợi dữ liệu
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final draftCount = snapshot.data;
                    return draftCount! >= 0
                        ? Positioned(
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                '$draftCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container();
                  }
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
      width: screenWidth * 0.25,
      height: screenHeight * 0.055,
      margin: EdgeInsets.only(
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.appBarColorComponent,
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
        color: AppColors.appBarColorComponent,
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
        color: AppColors.appBarColorComponent,
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
        color: AppColors.appBarColorComponent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              changeAppBarState(context, 5);
            });
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
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
