import 'package:fixmystreet/src/providers/appbar_states.dart';
import 'package:fixmystreet/src/providers/map_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/features/map/map_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapState()),
        ChangeNotifierProvider(create: (context) => AppBarStateManager()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Chế độ sáng
      darkTheme: ThemeData.dark(),
      routes: {
        '/': (context) => MapScreen(),
      },
      title: 'Dự án',
    );
  }
}
