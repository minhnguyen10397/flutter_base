import 'package:flutter/material.dart';
import 'package:flutter_mini_app/flutter_mini_app.dart';

void main() => runApp(const HostApp());

class HostApp extends StatefulWidget {
  const HostApp({super.key});

  @override
  State<HostApp> createState() => _HostAppState();
}

class _HostAppState extends State<HostApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Setup Method Channel từ mini app
    MiniAppNavigator.setup(_navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Host App',
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Set background transparent cho MaterialApp
      builder: (context, child) {
        return Container(
          color: Colors.transparent,
          child: child,
        );
      },
      // Named routes từ mini app
      initialRoute: '/',
      routes: MiniAppNavigator.getRoutes(),
    );
  }
}
