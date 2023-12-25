import 'package:fixmystreet/src/features/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLocationFound = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
        print(_controller.value);
        if ((_controller.value - 1).abs() < 0.0001) {
          // Khi giá trị animation đạt đến giá trị cuối cùng, chuyển tới trang MapScreen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MapScreen()),
          );
        }
      });

    _initLocation();
    _controller.repeat();
  }

  Future<void> _initLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _isLocationFound = true;
      });

      // Kết thúc animation nếu định vị thành công
      _controller.stop();

      // Chuyển tới trang MapScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MapScreen()),
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth,
              height: 15,
              color: Colors.white,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _animation.value,
                    child: Container(
                      height: 30,
                      color: Colors.yellow[500],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              _isLocationFound
                  ? 'Vị trí đã được xác định'
                  : 'Đang tìm kiếm vị trí của bạn',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              child: Container(
                width: screenWidth * 0.75,
                child: Center(
                  child: Text('Hủy'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
