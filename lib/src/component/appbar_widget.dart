import 'package:flutter/material.dart';

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
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}

Widget buildAppBarLeadingDefault(double screenWidth, double screenHeight) {
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
  );
}

Widget buildAppBarAcctionDefault(double screenWidth, double screenHeight) {
  return Container(
    width: screenWidth * 0.29,
    height: screenWidth * 0.1,
    margin:
        EdgeInsets.only(right: screenWidth * 0.02, bottom: screenWidth * 0.02),
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
  );
}

Widget buildAppBarLeadingBack(double screenWidth, double screenHeight) {
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
      onTap: () {
        // Xử lý khi nhấn vào phần leading
        print('leading clicked');
      },
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 30,
        ),
        onPressed: () {
          // Xử lý khi nút "Back" được nhấn
        },
      ),
    ),
  );
}

Widget buildAppBarAcction3(double screenWidth, double screenHeight) {
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
        onTap: () {},
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

Widget buildAppBarAcction4(double screenWidth, double screenHeight) {
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
        onTap: () {},
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
