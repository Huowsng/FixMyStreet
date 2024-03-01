import 'package:fixmystreet/src/providers/map_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  late Color backgroundColor;
  late Color textColor;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    MapState mapState = Provider.of<MapState>(context, listen: false);
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
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            'Bạn chưa đăng nhập!',
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email của bạn',
                                labelStyle: TextStyle(color: textColor)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mật khẩu của bạn',
                                labelStyle: TextStyle(color: textColor)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(
                            obscureText: true,
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nhập lại mật khẩu',
                                labelStyle: TextStyle(color: textColor)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            child: ElevatedButton(
                              child: const Text('Đăng kí'),
                              onPressed: () {
                                print(nameController.text);
                                print(passwordController.text);
                              },
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            const Text('Bạn đã có tài khoản?'),
                            TextButton(
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                //signup screen
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
