class FlutterBitchatChannelData {
  final Set<String> joinedChannels;
  final Set<String> passwordProtectedChannels;
  final Map<String, String> channelCreators;

  const FlutterBitchatChannelData({
    required this.joinedChannels,
    required this.passwordProtectedChannels,
    required this.channelCreators,
  });

  const FlutterBitchatChannelData.empty({
    this.joinedChannels = const {},
    this.passwordProtectedChannels = const {},
    this.channelCreators = const {},
  });

  factory FlutterBitchatChannelData.fromJson(Map json) {
    final joinedChannels = json['joinedChannels'];
    final passwordProtectedChannels = json['passwordProtectedChannels'];
    final channelCreators = json['channelCreators'];
    return FlutterBitchatChannelData(
        joinedChannels: joinedChannels is List ? joinedChannels.map((
            e) => e as String).toSet() : {},
        passwordProtectedChannels: passwordProtectedChannels is List
            ? passwordProtectedChannels.map((e) => e as String).toSet()
            : {},
        channelCreators: channelCreators is Map ? channelCreators.map((key,
            value) => MapEntry(key as String, value as String)) : {}
    );
  }

  Map<String, dynamic> toJson() => {
    'joinedChannels': joinedChannels.toList(),
    'passwordProtectedChannels': passwordProtectedChannels.toList(),
    'channelCreators': channelCreators,
  };

  bool isChannelCreator(String channel, String peerID) {
    return channelCreators[channel] == peerID;
  }

  FlutterBitchatChannelData copyWith({
    Set<String>? joinedChannels,
    Set<String>? passwordProtectedChannels,
    Map<String, String>? channelCreators,
  }) {
    return FlutterBitchatChannelData(
      joinedChannels: joinedChannels ?? this.joinedChannels,
      passwordProtectedChannels:
          passwordProtectedChannels ?? this.passwordProtectedChannels,
      channelCreators: channelCreators ?? this.channelCreators,
    );
  }
}
