import 'package:fixmystreet/src/providers/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/constants.dart';
import '../../services/draft_service.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _titleDetailController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  late Color backgroundColor;
  late Color textColor;
  @override
  Widget build(context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    AppBarStateManager appBarState =
        Provider.of<AppBarStateManager>(context, listen: true);
    MapState mapState = Provider.of<MapState>(context, listen: true);
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    backgroundColor = currentBrightness == Brightness.light
        ? Colors.white // Chọn màu cho chế độ sáng
        : Colors.black; // Chọn màu cho chế độ tối

    textColor = currentBrightness == Brightness.light
        ? Colors.black // Chọn màu cho chế độ sáng
        : Colors.white; // Chọn màu cho chế độ tối
    return Container(
        color: Colors.black.withOpacity(0.2),
        width: screenWidth,
        height: screenHeight,
        padding: EdgeInsets.all(10),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: backgroundColor,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _titleDetailController,
                  decoration: InputDecoration(labelText: 'Title Detail'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Content'),
                  maxLines: null,
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final Draft draft = Draft(
                        title: _titleController.text,
                        titleDetail: _titleDetailController.text,
                        content: _contentController.text,
                      );
                      await DraftService.saveDraft(draft);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Draft saved successfully'),
                        ),
                      );
                    },
                    child: Text('Save Draft'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
