import 'package:fixmystreet/src/features/map/map_screen.dart';
import 'package:fixmystreet/src/features/map/modules/map_search.dart';
import 'package:flutter/material.dart';
class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      theme: ThemeData.light(), // Chế độ sáng
      darkTheme: ThemeData.dark(),
      routes: {
        // '/' : (context) =>  LoadingScreen(),
        // '/MapScreen' : (context) => MapScreen(),
        '/' : (context) => MapScreen(),
        // '/' : (context) => SearchPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Project',
    );
  }

}
