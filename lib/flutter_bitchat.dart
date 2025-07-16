
import 'flutter_bitchat_platform_interface.dart';

class FlutterBitchat {
  Future<String?> getPlatformVersion() {
    return FlutterBitchatPlatform.instance.getPlatformVersion();
  }
}
