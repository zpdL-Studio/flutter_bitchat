import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_bitchat_platform_interface.dart';

/// An implementation of [FlutterBitchatPlatform] that uses method channels.
class MethodChannelFlutterBitchat extends FlutterBitchatPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bitchat');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
