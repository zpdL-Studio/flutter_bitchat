import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
