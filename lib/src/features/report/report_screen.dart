import 'dart:io';
import 'package:fixmystreet/src/providers/appbar_states.dart';
import 'package:fixmystreet/src/providers/map_states.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  XFile? _image;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  late Color backgroundColor;
  late Color textColor;
  String selectedOption = "";
  List<String> options = ['Option 1', 'Option 2', 'Option 3'];
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    AppBarStateManager appBarState =
        Provider.of<AppBarStateManager>(context, listen: false);
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
        child: Consumer<AppBarStateManager>(
          builder: (context, mapState, child) {
            return buildBody(context, appBarState.appBarState);
          },
        ));
  }

  Container buildBody(context, int state) {
    switch (state) {
      case 3:
        return buildBody3(context);
      case 4:
        return buildBody4(context);
      case 5:
        return buildBody5(context);
      default:
        return buildBody3(context);
    }
  }

  Container buildBody3(context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: screenWidth,
        height: screenHeight,
        color: backgroundColor,
        child: Column(
          children: [
            Text(
              "Thêm một ảnh (tùy chọn)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              width: screenWidth,
              height: screenHeight - 295,
              child: _image != null
                  ? Image.file(
                      File(_image!.path),
                    )
                  : Image.asset(
                      'lib/src/assets/images/camera.jpg',
                    ),
            ),
            GestureDetector(
              onTap: () => {_selectImage(), print("avc")},
              child: Container(
                width: screenWidth,
                height: 50,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/src/assets/images/photos.png',
                      width: 50,
                      height: 50,
                    ),
                    Text(
                      "Thêm một ảnh có sẵn",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () => {_pickImage()},
              child: Container(
                width: screenWidth,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 211, 190, 7),
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/src/assets/images/camera.png',
                      width: 50,
                      height: 50,
                    ),
                    Text(
                      "Chụp một ảnh mới",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Container buildBody4(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: screenWidth,
      height: screenHeight,
      color: backgroundColor,
      child: Column(
        children: [
          Container(
            width: screenWidth,
            height: 50,
            child: DropdownButton(
              items: options.map((String option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
                // Handle the selected value here
                print('Selected value: $newValue');
              },
              hint: Text(
                selectedOption == '' ? '--Chọn một danh mục' : selectedOption,
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ),
          ),
          SizedBox(
            width: screenWidth,
            height: 50,
            child: TextField(
              controller: titleController,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Cung cấp một vấn đề',
                  labelStyle: TextStyle(color: textColor)),
            ),
          ),
          SizedBox(
            width: screenWidth,
            child: TextField(
              controller: detailController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Vui lòng nhập chi tiết vấn đề',
                  labelStyle: TextStyle(color: textColor)),
            ),
          ),
        ],
      ),
    );
  }

  Container buildBody5(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: screenWidth,
      height: screenHeight,
      color: backgroundColor,
      child: Column(
        children: [
          SizedBox(
            width: screenWidth,
            height: 50,
            child: TextField(
              controller: emailController,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Vui lòng nhập địa chỉ Email của bạn',
                  labelStyle: TextStyle(color: textColor)),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Ứng dụng này cần gửi cho bạn Email xác nhận trước khi chúng tôi có thể gửi báo cáo của bạn đến chính quyền.",
            style: TextStyle(fontSize: 18, color: textColor),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Để bỏ qua bước này trong tương lai, bạn có thể đặt mật khẩu ngay bây giờ",
            style: TextStyle(fontSize: 18, color: textColor),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 211, 190, 7),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Tôi không muốn thiết lập mật khẩu",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 211, 190, 7),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Tôi muốn thiết lập một mật khẩu",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 211, 190, 7),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Tôi đã có - Đăng nhập",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
}
