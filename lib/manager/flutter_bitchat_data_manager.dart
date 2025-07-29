import 'dart:async';

import 'package:flutter_bitchat/manager/data/flutter_bitchat_channel_data.dart';

abstract interface class FlutterBitchatDataManager {
  Future<String> loadNickname();

  Future<void> saveNickname(String nickname);

  Future<FlutterBitchatChannelData> loadChannelData();

  Future<void> saveChannelData(FlutterBitchatChannelData data);
}
