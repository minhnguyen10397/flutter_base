import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:gold/app.dart';
import 'package:gold/main_general.dart';

EventBus eventBus = EventBus();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GeneralConfig.init();

  runApp(
    const App(),
  );
}