
import 'package:fixmystreet/src/models/map_states.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<HelpScreen> createState() => _SearchState();
}

class _SearchState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    Color backgroundColor = currentBrightness == Brightness.light
        ? Colors.white // Chọn màu cho chế độ sáng
        : Colors.black; // Chọn màu cho chế độ tối

    Color textColor = currentBrightness == Brightness.light
        ? Colors.black // Chọn màu cho chế độ sáng
        : Colors.white; // Chọn màu cho chế độ tối
    return Container(
      color: Colors.black.withOpacity(0.2),
      width: screenWidth,
      height: screenHeight,
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 5),
            width: screenWidth,
            color: backgroundColor,
            child: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Các câu hỏi thường gặp",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("FixMyStreet là gì?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  Text(
                      "  FixMyStreet là một trang web và ứng dụng giúp mọi người báo cáo các vấn đề ở địa phương họ đã tìm thấy đến chính quyền.",
                      style: TextStyle(fontSize: 17)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Làm thế nào để sử dụng ứng dụng này?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                      "  Ứng dụng sẽ cố gắng tự động xác định vị trí của bạn nhưng nếu không thể hoặc bạn muốn báo cáo một vấn đề ở nơi khác bạn có thể tìm kiếm theo mã bưu điện hoặc vị trí. Để bắt đầu báo cáo sự cố, hãy cuộn bản đồ cho đến khi dấu thập vượt qua vị trí của sự cố và nhân 'Báo cáo mới tại đây'.",
                      style: TextStyle(fontSize: 17)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Điều gì xảy ra với thông tin tôi cung cấp?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 17),
                      text: "  ",
                      children: [
                        TextSpan(
                          text:
                              "Tất cả thông tin bạn cung cấp sẽ được gửi đến chính quyền.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              " Tiêu đề, danh mục và chi tiết báo cáo của bạn sẽ được hiển thị trên trang mạng. Mặc định tên của bạn sẽ không hiển thị trên website nhưng bạn có thể chọn hiển thị thông tin này. Chúng tôi sẽ ",
                        ),
                        TextSpan(
                          text:
                              "không bao giờ hiển thị email hoặc số điện thoại của bạn trên trang web.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Nếu tôi muốn ẩn danh thì sao?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text.rich(TextSpan(
                      style: TextStyle(fontSize: 17),
                      text: "  ",
                      children: [
                        TextSpan(
                            text:
                                "Theo mặc định tên của bạn sẽ không được hiển thị trên trang web. Nếu bạn chọn 'Hiển thị tên tôi một cách công khai' khi nhập thông tin chi tiết của bạn thì tên của bạn sẽ được hiển thị trên trang web. "),
                        TextSpan(
                          text:
                              "Tên, email và số điện thoại của bạn, nếu bạn cung cấp, sẽ luôn được gửi đến chính quyền.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Điều gì xảy ra nếu tôi vô tình đưa thông tin cá nhân vào báo cáo?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text.rich(
                    TextSpan(
                      text: "  Để có một email chỉnh sửa báo cáo ",
                      style: TextStyle(fontSize: 17),
                      children: [
                        TextSpan(
                          mouseCursor: SystemMouseCursors.click,
                          text: "support@fixmystreet.com",
                          style: TextStyle(
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                            color: Colors.blue, // Màu của liên kết
                          ),
                        ),
                        TextSpan(
                          text: " với chi tiết báo cáo.",
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Tôi quên mật khẩu, làm cách nào để đặt lại?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                      "  Nếu bạn quên mật khẩu, bạn có thể đặt lại mật khẩu bằng cách chọn 'đặt mật khẩu' khi gửi báo cáo lần tiếp theo. Xin lưu ý rằng bạn phải nhấp vào liên kết trong email xác nhận để kích hoạt hoặc thay đổi mật khẩu.",
                      style: TextStyle(fontSize: 17)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Tôi nên báo cáo loại vấn đề gì FixMyStreet?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text.rich(TextSpan(
                      text: "  ",
                      style: TextStyle(fontSize: 17),
                      children: [
                        TextSpan(
                            text:
                                "FixMyStreet chủ yếu là để báo cáo những điều "),
                        TextSpan(
                          text:
                              "bị hỏng hoặc bẩn hoặc bị hư hỏng hoặc bị đổ và cần sửa chữa, làm sạch.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  Text("FixMyStreet báo cáo cái gì?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  Text(
                      "  FixMyStreet không phải là cách để liên lạc với chính quyền của bạn về mọi vấn đề - vui lòng sử dụng FixMyStreet chỉ dành cho những vấn đề như trên.",
                      style: TextStyle(fontSize: 17)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Nó có miền phí không?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  Text.rich(TextSpan(
                      text: "  ",
                      style: TextStyle(fontSize: 17),
                      children: [
                        TextSpan(
                            text:
                                "Trang web và ứng dụng này được sử dụng miễn phí, vâng. Tuy nhiên FixMyStreet được điều hành bởi một tổ chức từ thiện đã đăng kí, vì vậy nếu bạn muốn đóng góp,"),
                        TextSpan(
                          text: "vui lòng thực hiện.",
                          style: TextStyle(
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                            color: Colors.blue, // Màu của liên kết
                          ),
                        ),
                        TextSpan(text: " Để biết thêm thông tin, hãy xem "),
                        TextSpan(
                          text: "website",
                          style: TextStyle(
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                            color: Colors.blue, // Màu của liên kết
                          ),
                        ),
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Ai đã xây dựng FixMyStreet?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  Text.rich(TextSpan(
                      text: "  Trang web và ứng dụng được xây dựng bởi",
                      style: TextStyle(fontSize: 17),
                      children: [
                        TextSpan(
                          text: "mySociety",
                          style: TextStyle(
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                            color: Colors.blue, // Màu của liên kết
                          ),
                        ),
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Nhờ vào...",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text.rich(
                    TextSpan(
                        text: "  ",
                        style: TextStyle(fontSize: 17),
                        children: [
                          TextSpan(
                            text: "Ordnance Survey ",
                            style: TextStyle(
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                              color: Colors.blue, // Màu của liên kết
                            ),
                          ),
                          TextSpan(
                              text:
                                  "(Cho bản đồ, mã bưu điện của vương quốc Anh và địa chỉ của Vương quốc Anh - dữ liệu © Crown bản quyền, Đã đăng kí bản quyền, Bộ Tư Pháp 100037819 2008), toàn bộ cộng đồng phần mềm miễn phí(dự án cụ thể này được cung cấp bởi Phonegap, Backbone, Jquery mobile và số 161.290) và"),
                          TextSpan(
                            text: "Bytemark",
                            style: TextStyle(
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                              color: Colors.blue, // Màu của liên kết
                            ),
                          ),

                          TextSpan(
                              text:
                                  "(những người vui lòng lưu trữ tất cả các máy chủ của chúng tôi). Cho chúng tôi biết nếu chúng tôi đã bỏ lỡ bất cứ ai.")
                        ]),
                  )
                  // ...Thêm các Text khác vào đây
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 35,
                ),
                onPressed: () {
                  setState(() {
                    Provider.of<MapState>(context, listen: false)
                        .setShowHelpScreen(false);
                  });
                },
              )),
        ],
      ),
    );
  }
  _launchEmail(email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(_emailLaunchUri)) {
      await launchUrl(_emailLaunchUri);
    } else {
      throw 'Không thể mở ứng dụng email.';
    }
  }
}
