import 'package:fixmystreet/src/assets/icons/icon.dart';
import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:fixmystreet/src/features/map/controllers/search_controller.dart';
import 'package:flutter/material.dart';


class MapSearch extends StatefulWidget {
  const MapSearch({
    Key? key,
  }) : super(key: key);
  @override
  State<MapSearch> createState() => _SearchState();
}

class _SearchState extends State<MapSearch> {
  TextEditingController searchController = TextEditingController();
  SearchControllerHelper controller = SearchControllerHelper();
  MapControllerHelper mapController = MapControllerHelper();
  bool showSecondContainer = false;
  bool showPins = true;
  @override
  void initState() {
    super.initState();
    mapController.mapController;
    // Bạn có thể sử dụng mapController ở đây
  }
  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    Color backgroundColor = currentBrightness == Brightness.light
        ? Colors.white // Chọn màu cho chế độ sáng
        : Colors.black; // Chọn màu cho chế độ tối

    Color textColor = currentBrightness == Brightness.light
        ? Colors.black // Chọn màu cho chế độ sáng
        : Colors.white; // Chọn màu cho chế độ tối
    String searchText = '';

    if (showSecondContainer && controller.addresses.isNotEmpty) {
      // If there are multiple matching results
      searchText = 'Đã tìm thấy nhiều kết quả phù hợp';
    } else if (controller.message.isNotEmpty) {
      // If there is an error message
      searchText = controller.message;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 40,
            color: backgroundColor,
            child: Row(
              children: [
                Container(
                  width: 35,
                  child: Icon(Icons.search, color: textColor),
                ),
                VerticalDivider(
                  color: Colors.grey,
                  thickness: 0.8,
                  width: 0,
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: searchController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tìm kiếm hoặc cuộn bản đồ',
                          hintStyle: TextStyle(
                            color: textColor,
                          ),
                        ),
                        onChanged: (value) {
                          // Handle onChanged if needed
                        },
                        onSubmitted: (value) async {
                          await controller.getAddresses(value);
                          setState(() {
                            showSecondContainer = true;
                          });
                        },
                      ),
                      if (searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              showSecondContainer = false;
                              searchController.clear();
                              // Additional logic if needed
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      mapController.currentLocation();
                    });
                  },
                  child: Container(
                    color: backgroundColor,
                    width: 35,
                    height: 35,
                    child: const Icon(MyFlutterApp.direction,
                        color: Colors.blue, size: 25.0),
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (showPins) {
                        mapController.RemoveMaker();
                      } else {
                        mapController.getReport();
                      }
                      showPins = !showPins;
                    });
                  },
                  child: Container(
                    child: Image.asset(
                      showPins
                          ? "lib/src/assets/images/show-pins-link.png"
                          : "lib/src/assets/images/hide-pins-link.png",
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Visibility(
              visible: showSecondContainer,
              child: Container(
                height: calculateContainerHeight() + 50,
                color: backgroundColor,
                child: Column(children: [
                  Text(
                    searchText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.0,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey), // Set border color
                      borderRadius: BorderRadius.circular(
                          1), // Optional: Set border radius
                    ),
                    padding: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 5,
                        right:
                            5), // Điều chỉnh khoảng cách giữa Text và ListView
                    height: calculateContainerHeight(),
                    width: 340,
                    child: ListView.builder(
                      itemCount: controller.addresses.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(11),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              double lat =
                                  controller.latitudes[index];
                              double long =
                                  controller.longitudes[index];
                              mapController.changeLocation(lat, long);
                            },
                            child: Text(
                              controller.addresses[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              ))
        ],
      ),
    );
  }

  double calculateContainerHeight() {
    // Calculate the total height needed based on the number of items in the list
    double itemHeight = 47.0; // Adjust this value based on your ListTile height
    int itemCount = controller.addresses.length;
    return itemHeight * itemCount;
  }
}
