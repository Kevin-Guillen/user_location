import 'dart:async';

import 'package:flutter/services.dart';

class UserLocationPlugin {
  static const _permissionEventChannel =
      EventChannel("permission_event_channel");
  static Stream<dynamic> permissionEventChannelStream =
      _permissionEventChannel.receiveBroadcastStream();

  static const MethodChannel _channel =
      const MethodChannel('user_location_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> get initializePlugin async {
    await _channel.invokeMethod("initializePlugin");
    return;
  }

  static Future<bool> get checkPermission async {
    final bool granted = await _channel.invokeMethod('checkPermission');
    return granted;
  }

  static Future<void> get requestPermission async {
    await _channel.invokeMethod('requestPermission');
    return;
  }
}
