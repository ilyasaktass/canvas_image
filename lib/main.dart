import 'dart:async';
import 'dart:ui';

import 'package:canvas_image/canvas/canvas_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  configLoading();

  // Flutter framework hataları için
  FlutterError.onError = (FlutterErrorDetails details) {
    logError(details.exception, details.stack);
    FlutterError.dumpErrorToConsole(details);
  };

  // Platform (Dart VM) hataları için
  PlatformDispatcher.instance.onError = (error, stack) {
    logError(error, stack);
    return true;
  };

  // runZonedGuarded ile diğer hatalar için
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    logError(error, stackTrace);
  });
}

void logError(Object error, StackTrace? stackTrace) {
  // Hata detaylarını loglayın veya bir hata izleme aracına gönderin
  debugPrint('Caught error: $error');
  if (stackTrace != null) {
    debugPrint('Stack trace: $stackTrace');
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DrawingBoard(),
      builder: EasyLoading.init(),
    );
  }
}
