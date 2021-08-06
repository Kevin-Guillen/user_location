import 'dart:async';

import 'package:flutter/services.dart';

import 'utils/methods_strings.dart';

class UserLocationPlugin {
  static const _permissionEventChannel =
      EventChannel(MethodsStrings.permissionEventChannel);
  static Stream<dynamic> permissionEventChannelStream =
      _permissionEventChannel.receiveBroadcastStream();

  static const MethodChannel _channel =
      const MethodChannel(MethodsStrings.userLocationPlugIn);

  static Future<String?> get platformVersion async {
    final String? version =
        await _channel.invokeMethod(MethodsStrings.getPlatformVersion);
    return version;
  }

  static Future<void> get initializePlugin async {
    await _channel.invokeMethod(MethodsStrings.initializePlugin);
    return;
  }

  static Future<void> get requestPermission async {
    await _channel.invokeMethod(MethodsStrings.requestPermission);
    return;
  }

  static Future<bool> get checkPermission async {
    final bool granted =
        await _channel.invokeMethod(MethodsStrings.checkPermission);
    return granted;
  }
}
