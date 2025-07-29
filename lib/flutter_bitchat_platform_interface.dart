import 'package:flutter_bitchat/data/flutter_bitchat_permission_status.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_bitchat_call_handler.dart';
import 'flutter_bitchat_method_channel.dart';

abstract class FlutterBitchatPlatform extends PlatformInterface {
  /// Constructs a FlutterBitchatPlatform.
  FlutterBitchatPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBitchatPlatform _instance = MethodChannelFlutterBitchat();

  /// The default instance of [FlutterBitchatPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBitchat].
  static FlutterBitchatPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBitchatPlatform] when
  /// they register themselves.
  static set instance(FlutterBitchatPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void setMethodCallHandler(FlutterBitchatCallHandler? callHandler) {
    throw UnimplementedError(
      'setMethodCallHandler() has not been implemented.',
    );
  }

  Future<FlutterBitchatPermissionStatus> getPermissionStatus() {
    throw UnimplementedError('getPermissionStatus() has not been implemented.');
  }

  Future<bool> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<String> myPeerID() {
    throw UnimplementedError('myPeerID() has not been implemented.');
  }

  Future<void> startMeshService() {
    throw UnimplementedError('startService() has not been implemented.');
  }

  Future<void> stopMeshService() {
    throw UnimplementedError('stopMeshService() has not been implemented.');
  }

  Future<void> sendMessage({
    required String content,
    List<String> mentions = const [],
    String? channel,
  }) {
    throw UnimplementedError(
      'sendMessage(content, mentions, channel) has not been implemented.',
    );
  }
}
