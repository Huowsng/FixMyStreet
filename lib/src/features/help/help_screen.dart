import 'package:fixmystreet/src/assets/icons/icon.dart';
import 'package:fixmystreet/src/features/map/controllers/map_controller.dart';
import 'package:fixmystreet/src/features/map/controllers/search_controller.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<HelpScreen> createState() => _SearchState();
}

class _SearchState extends State<HelpScreen> {
  TextEditingController searchController = TextEditingController();
  bool showSecondContainer = false;
  bool showPins = true;

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    Color backgroundColor = currentBrightness == Brightness.light
        ? Colors.white // Chọn màu cho chế độ sáng
        : Colors.black; // Chọn màu cho chế độ tối

    Color textColor = currentBrightness == Brightness.light
        ? Colors.black // Chọn màu cho chế độ sáng
        : Colors.white; // Chọn màu cho chế độ tối
    return Container(
    );
  }
}
