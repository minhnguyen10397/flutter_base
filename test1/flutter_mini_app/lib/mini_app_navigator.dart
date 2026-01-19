import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mini_app/flutter_mini_app.dart';

/// Mini App Navigator với Method Channel support
class MiniAppNavigator {
  static const MethodChannel _channel = MethodChannel('flutter_host_app/navigation');
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Setup Method Channel và Navigator
  static void setup(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'navigateToRoute') {
        final String route = call.arguments as String? ?? '/mini-app';
        if (_navigatorKey?.currentState != null) {
          _navigatorKey!.currentState!.pushNamed(route);
        }
      }
      return null;
    });
  }

  /// Get routes cho MaterialApp
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const MiniAppScreen(), // Empty screen mặc định
      '/mini-app': (context) => const MiniAppScreen(),
      // Có thể thêm các routes khác ở đây
    };
  }
}

