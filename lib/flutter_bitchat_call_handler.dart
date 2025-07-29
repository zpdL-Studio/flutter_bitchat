import 'package:flutter_bitchat/manager/data/flutter_bitchat_message.dart';

abstract interface class FlutterBitchatCallHandler {
  Future<String?> getNickname();

  void didConnectToPeer(String peerID);

  void didUpdatePeerList(List<String> peers);

  void registerPeerPublicKey(String peerID, String fingerprint);

  void didReceiveMessage(FlutterBitchatMessage message);
}
