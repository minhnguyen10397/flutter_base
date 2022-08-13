import 'package:flutter/material.dart';
import 'features/splash/pages/splash_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Đầu Tư Vàng',
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
