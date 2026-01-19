import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mini_app/flutter_mini_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  
  // Setup MethodChannel để nhận method calls từ Android
  const MethodChannel channel = MethodChannel('com.example.flutter/method_channel');
  channel.setMethodCallHandler((call) async {
    switch (call.method) {
      case 'getData':
        // Ví dụ: trả về dữ liệu từ Flutter
        final arguments = call.arguments as Map<dynamic, dynamic>?;
        final key = arguments?['key'] as String?;
        return {'result': 'Data from Flutter: $key', 'timestamp': DateTime.now().millisecondsSinceEpoch};
      
      case 'calculate':
        // Ví dụ: tính toán và trả về kết quả
        final arguments = call.arguments as Map<dynamic, dynamic>?;
        final a = arguments?['a'] as int? ?? 0;
        final b = arguments?['b'] as int? ?? 0;
        return {'sum': a + b, 'product': a * b};
      
      case 'getUserInfo':
        // Ví dụ: trả về thông tin user
        return {
          'name': 'Flutter User',
          'id': '12345',
          'email': 'user@example.com'
        };
      
      default:
        throw PlatformException(
          code: 'METHOD_NOT_IMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  });
  
  runApp(const HostApp());
}

class HostApp extends StatelessWidget {
  const HostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Host App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
        cardColor: Colors.transparent,
        dialogBackgroundColor: Colors.transparent,
      ),
      // Set background transparent cho MaterialApp
      builder: (context, child) {
        return Listener(
          // QUAN TRỌNG: HitTestBehavior.translucent cho phép touch events đi qua
          // vùng transparent để MainActivity có thể nhận được
          behavior: HitTestBehavior.translucent,
          child: Container(
            color: Colors.transparent,
            child: child,
          ),
        );
      },
      home: const MiniAppScreen(), // Hiển thị mini app luôn
    );
  }
}
