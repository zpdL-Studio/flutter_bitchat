import 'package:flutter_bitchat/data/flutter_bitchat_permission_status.dart';

import 'flutter_bitchat_platform_interface.dart';

class FlutterBitchat {
  static Future<FlutterBitchatPermissionStatus> getPermissionStatus() {
    return FlutterBitchatPlatform.instance.getPermissionStatus();
  }

  static Future<bool> requestPermission() {
    return FlutterBitchatPlatform.instance.requestPermission();
  }
}
