import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'mini_app_navigator.dart';

class MiniAppScreen extends StatefulWidget {
  const MiniAppScreen({super.key});

  @override
  State<MiniAppScreen> createState() => _MiniAppScreenState();
}

class _MiniAppScreenState extends State<MiniAppScreen> {
  static const MethodChannel _channel = MethodChannel('com.example.flutter/method_channel');
  String _result = 'Chưa gọi native';

  Future<void> _callGetNativeData(String type) async {
    try {
      final result = await _channel.invokeMethod('getNativeData', {'type': type});
      setState(() {
        _result = 'Kết quả: $result';
      });
      print('Flutter: Nhận được dữ liệu từ native: $result');
    } catch (e) {
      setState(() {
        _result = 'Lỗi: $e';
      });
      print('Flutter: Lỗi khi gọi native: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Flutter Mini App'),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Container(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Xin chào từ Flutter Mini App!',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _callGetNativeData('userInfo');
                    // Hiển thị SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã gọi getNativeData (userInfo)'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                  child: const Text('Gọi getNativeData (userInfo)'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _callGetNativeData('deviceInfo');
                    // Hiển thị Dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thông báo'),
                        content: const Text('Đã gọi getNativeData (deviceInfo)'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Gọi getNativeData (deviceInfo)'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _callGetNativeData('default');
                    // Hiển thị SnackBar với action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Đã gọi getNativeData (default)'),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.green,
                        action: SnackBarAction(
                          label: 'Đóng',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  child: const Text('Gọi getNativeData (default)'),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
