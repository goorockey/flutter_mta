import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMta {
  static const MethodChannel _channel = const MethodChannel('flutter_mta');

  static Future<bool> init(
      {final String androidAppKey = '',
      final String iosAppKey = '',
      final bool debug = false}) async {
    return await _channel.invokeMethod('init', {
      'androidAppKey': androidAppKey,
      'iosAppKey': iosAppKey,
      'debug': debug,
    });
  }

  static Future<void> trackCustomKVEvent(final String eventId,
      {final Map<String, String> properties}) async {
    await _channel.invokeMethod('trackCustomKVEvent', {
      'eventId': eventId,
      'properties': properties ?? {},
    });
  }
}
