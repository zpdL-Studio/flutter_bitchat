import 'package:flutter_bitchat/manager/data/flutter_bitchat_message.dart';

class FlutterBitchatMessageManager {
  final void Function(List<FlutterBitchatMessage> messages) didUpdateMessage;

  FlutterBitchatMessageManager(this.didUpdateMessage);

  // ignore: non_constant_identifier_names
  int MESSAGE_DEDUP_TIMEOUT = 30000;

  // ignore: non_constant_identifier_names
  int SYSTEM_EVENT_DEDUP_TIMEOUT = 5000;

  final List<FlutterBitchatMessage> _messages = [];
  final Set<String> _processedUIMessages = {};
  final Map<String, int> _recentSystemEvents = {};

  void addMessage(FlutterBitchatMessage message) {
    _messages.add(message);
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    didUpdateMessage([..._messages]);
  }

  void clearMessage() {
    _messages.clear();
    didUpdateMessage([]);
  }

  String generateMessageKey(FlutterBitchatMessage message) {
    final senderKey = message.senderPeerID ?? message.sender;
    final contentHash = message.content.hashCode;
    return '$senderKey-${message.timestamp.millisecondsSinceEpoch}-$contentHash';
  }

  bool isMessageProcessed(String messageKey) {
    return _processedUIMessages.contains(messageKey);
  }

  void markMessageProcessed(String messageKey) {
    _processedUIMessages.add(messageKey);
  }

  bool isDuplicateSystemEvent(String eventType, String peerID) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final eventKey = '$eventType-$peerID';
    final lastEvent = _recentSystemEvents[eventKey];

    if (lastEvent != null && (now - lastEvent) < SYSTEM_EVENT_DEDUP_TIMEOUT) {
      return true; // Duplicate event
    }

    _recentSystemEvents[eventKey] = now;
    return false;
  }

  void cleanupDeduplicationCaches() {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Clean up processed UI messages (remove entries older than 30 seconds)
    if (_processedUIMessages.length > 1000) {
      _processedUIMessages.clear();
    }

    // Clean up recent system events (remove entries older than timeout)
    final entries =
        _recentSystemEvents.entries.toList()..removeWhere((e) {
          return now - e.value > SYSTEM_EVENT_DEDUP_TIMEOUT * 2;
        });
    _recentSystemEvents.clear();
    _recentSystemEvents.addEntries(entries);
  }

  // List<String> parseMentions(String content, Set<String> peerNicknames, String? currentNickname) {
  //   final mentionRegex = RegExp('@([a-zA-Z0-9_]+)');
  //   final allNicknames = {
  //     ...peerNicknames,
  //     if(currentNickname != null) currentNickname
  //   };
  //
  // return mentionRegex.allMatches(content)
  //     .map((e) => e.group(1))
  //     .where((e) => allNicknames.contains(e))
  //     .distinct()
  //     .toList();
  // }
  //
  // fun parseChannels(content: String): List<String> {
  // val channelRegex = "#([a-zA-Z0-9_]+)".toRegex()
  // return channelRegex.findAll(content)
  //     .map { it.groupValues[0] } // Include the #
  //     .distinct()
  //     .toList()
  // }

  void clearAllMessages() {
    _messages.clear();
    _processedUIMessages.clear();
    _recentSystemEvents.clear();

    didUpdateMessage([]);
  }
}
