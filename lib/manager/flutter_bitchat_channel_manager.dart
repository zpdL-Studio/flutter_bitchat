import 'dart:async';

abstract interface class FlutterBitchatChannelManager {
  Future<String> loadNickname();

  Future<void> saveNickname(String nickname);
}

