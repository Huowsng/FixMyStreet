import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:fixmystreet/src/features/map/controllers/search_controller.dart';
import 'package:flutter/material.dart';

class MapSearch extends StatefulWidget {
  const MapSearch({Key? key}) : super(key: key);

  @override
  State<MapSearch> createState() => _SearchState();
}

class _SearchState extends State<MapSearch> {
  TextEditingController searchController = TextEditingController();
  bool showSecondContainer = false;
  bool showPins = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    Color backgroundColor = currentBrightness == Brightness.light
        ? Colors.white // Chọn màu cho chế độ sáng
        : Colors.black; // Chọn màu cho chế độ tối

    Color textColor = currentBrightness == Brightness.light
        ? Colors.black // Chọn màu cho chế độ sáng
        : Colors.white; // Chọn màu cho chế độ tối
    return Container(
      child: Column(
        children: [
          Container(
            color: backgroundColor,
            child: Row(
              children: [
                Icon(Icons.search, color: textColor), // Search icon
                SizedBox(width: 5.0),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: textColor),
                    // Set text color to white
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tìm kiếm hoặc cuộn bản đồ',
                      hintStyle: TextStyle(
                          color: textColor
                              .withOpacity(0.3)), // Set hint text color
                    ),

                    onChanged: (value) {
                      // Handle onChanged if needed
                    },
                    onSubmitted: (value) async {
                      await SearchControllerHelper.getAddresses(value);
                      setState(() {
                        showSecondContainer = true;
                      }); // Trigger a rebuild after the data is fetched
                    },
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
                      MapControllerHelper.displayCurrentLocation(); // Khi nhấn, đảo ngược trạng thái
                    });
                  },
                  child: Container(
                    child: Image.asset("lib/src/assets/images/location@x2.png"),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showPins = !showPins; // Khi nhấn, đảo ngược trạng thái
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
              // Adjust the height based on the number of items in the list
              height: calculateContainerHeight(),
              color: backgroundColor, // Set background color to black
              child: ListView.builder(
                itemCount: SearchControllerHelper.addresses.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          SearchControllerHelper.addresses[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                        onTap: () {
                          // Handle onTap/click event
                          print(
                              'Clicked on ${SearchControllerHelper.addresses[index]}');
                        },
                      ),
                      Divider(color: Colors.black, height: 1.0), // Divider
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateContainerHeight() {
    // Calculate the total height needed based on the number of items in the list
    double itemHeight = 40.0; // Adjust this value based on your ListTile height
    int itemCount = SearchControllerHelper.addresses.length;
    return itemHeight * itemCount;
  }
}
