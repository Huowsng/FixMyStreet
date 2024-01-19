import 'package:fixmystreet/src/models/map_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/features/map/map_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MapState(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Chế độ sáng
      darkTheme: ThemeData.dark(),
      routes: {
        '/': (context) => MapScreen(),
        // Thêm các routes khác nếu cần
      },
      debugShowCheckedModeBanner: false,
      title: 'Dự án',
    );
  }
}
