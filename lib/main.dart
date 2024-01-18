import 'package:flutter/material.dart';
import 'src/features/map/map_screen.dart';


void main() {
  runApp( App());
}
class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      theme: ThemeData.light(), // Chế độ sáng
      darkTheme: ThemeData.dark(),
      routes: {
        // '/' : (context) =>  LoadingScreen(),
        '/' : (context) => MapScreen(),
        // '/MapSearch' : (context) => MapSearch(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Project',
    );
  }

}  
