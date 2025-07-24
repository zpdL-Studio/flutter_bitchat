import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bitchat/data/flutter_bitchat_permission_status.dart';

import 'flutter_bitchat_platform_interface.dart';

/// An implementation of [FlutterBitchatPlatform] that uses method channels.
class MethodChannelFlutterBitchat extends FlutterBitchatPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bitchat');

  @override
  Future<FlutterBitchatPermissionStatus> getPermissionStatus() async {
    final status = await methodChannel.invokeMethod<Map>(
        'FlutterBitchat@getPermissionStatus');
    return FlutterBitchatPermissionStatus(
      hasBluetoothPermission: status?['hasBluetoothPermission'] ?? false,
      hasLocationPermission: status?['hasLocationPermission'] ?? false,
      hasNotificationPermission: status?['hasNotificationPermission'] ?? false,
    );
  }

  @override
  Future<bool> requestPermission() async {
    final result = await methodChannel.invokeMethod<bool>(
        'FlutterBitchat@requestPermission');
    return result == true;
  }
}
