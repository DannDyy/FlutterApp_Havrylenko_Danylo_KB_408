import 'dart:async';
import 'package:flutter/services.dart';

class FlashlightPlugin {
  static const MethodChannel _channel = MethodChannel('flashlight_plugin');

  static Future<bool?> toggleFlashlight() async {
    return await _channel.invokeMethod('toggleFlashlight');
  }
}
