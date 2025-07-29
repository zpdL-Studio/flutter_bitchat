import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bitchat/data/flutter_bitchat_permission_status.dart';

import 'flutter_bitchat_call_handler.dart';
import 'flutter_bitchat_platform_interface.dart';

/// An implementation of [FlutterBitchatPlatform] that uses method channels.
class MethodChannelFlutterBitchat extends FlutterBitchatPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bitchat');

  Future<dynamic> Function(MethodCall call)? handler;

  @override
  void setMethodCallHandler(FlutterBitchatCallHandler? callHandler) {
    if (callHandler == null) {
      methodChannel.setMethodCallHandler(null);
      return;
    }
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'FlutterBitchat@getNickname':
          return await callHandler.getNickname();
        case 'FlutterBitchat@didConnectToPeer':
          callHandler.didConnectToPeer(call.arguments['peerID']);
          break;
        case 'FlutterBitchat@didUpdatePeerList':
          callHandler.didUpdatePeerList((call.arguments as List).map((e) => e as String).toList());
          break;
        case 'FlutterBitchat@registerPeerPublicKey':
          callHandler.registerPeerPublicKey(
            call.arguments['peerID'],
            call.arguments['fingerprint'],
          );
          break;
        default:
          throw MissingPluginException('${call.method} is not implements');
      }
    });
  }

  @override
  Future<FlutterBitchatPermissionStatus> getPermissionStatus() async {
    final status = await methodChannel.invokeMethod<Map>(
      'FlutterBitchat@getPermissionStatus',
    );
    return FlutterBitchatPermissionStatus(
      hasBluetoothPermission: status?['hasBluetoothPermission'] ?? false,
      hasLocationPermission: status?['hasLocationPermission'] ?? false,
      hasNotificationPermission: status?['hasNotificationPermission'] ?? false,
    );
  }

  @override
  Future<bool> requestPermission() async {
    final result = await methodChannel.invokeMethod<bool>(
      'FlutterBitchat@requestPermission',
    );
    return result == true;
  }

  @override
  Future<String> myPeerID() async {
    return (await methodChannel.invokeMethod<String>(
        'FlutterBitchat@myPeerID'))!;
  }



  @override
  Future<void> startMeshService() =>
      methodChannel.invokeMethod<void>('FlutterBitchat@startMeshService');

  @override
  Future<void> stopMeshService() =>
      methodChannel.invokeMethod<void>('FlutterBitchat@stopMeshService');
}
