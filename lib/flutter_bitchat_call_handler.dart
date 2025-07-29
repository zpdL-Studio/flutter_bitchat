abstract interface class FlutterBitchatCallHandler {
  Future<String?> getNickname();

  void didConnectToPeer(String peerID);

  void didUpdatePeerList(List<String> peers);

  void registerPeerPublicKey(String peerID, String fingerprint);
}
