import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';

import 'di/get_it.dart';
import 'services/local/local_data_helper.dart';

class GeneralConfig {
  GeneralConfig._();

  static Future<void> init() async {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await LocalDataHelper.instance.init();
    await FlutterConfig.loadEnvVariables();
    await configureDependencies();
  }
}
