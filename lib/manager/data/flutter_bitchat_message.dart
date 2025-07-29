import 'dart:typed_data';

import 'package:flutter_bitchat/manager/data/flutter_bitchat_delivery_status.dart';

class FlutterBitchatMessage {
  final String id;
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isRelay;
  final String? originalSender;
  final bool isPrivate;
  final String? recipientNickname;
  final String? senderPeerID;
  final int? peerRSSI;
  final List<String>? mentions;
  final String? channel;
  final ByteData? encryptedContent;
  final bool isEncrypted;
  final DeliveryStatus? deliveryStatus;

  FlutterBitchatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.isRelay = false,
    this.originalSender,
    this.isPrivate = false,
    this.recipientNickname,
    this.senderPeerID,
    this.peerRSSI,
    this.mentions,
    this.channel,
    this.encryptedContent,
    this.isEncrypted = false,
    this.deliveryStatus,
  });

  factory FlutterBitchatMessage.fromJson(Map json) {
    return FlutterBitchatMessage(
      id: json['id'],
      sender: json['sender'],
      content: json['content'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      isRelay: json['isRelay'],
      originalSender: json['originalSender'],
      isPrivate: json['isPrivate'],
      recipientNickname: json['recipientNickname'],
      peerRSSI: json['peerRSSI'],
      senderPeerID: json['senderPeerID'],
      mentions:
          json['mentions'] is List
              ? (json['mentions'] as List).map((e) => e as String).toList()
              : null,
      channel: json['channel'],
      encryptedContent: json['encryptedContent'],
      isEncrypted: json['isEncrypted'],
      deliveryStatus: DeliveryStatus.fromJson(json['deliveryStatus']),
    );
  }

  @override
  String toString() {
    return 'FlutterBitchatMessage{id: $id, sender: $sender, content: $content, timestamp: $timestamp, isRelay: $isRelay, originalSender: $originalSender, isPrivate: $isPrivate, recipientNickname: $recipientNickname, senderPeerID: $senderPeerID, peerRSSI: $peerRSSI, mentions: $mentions, channel: $channel, encryptedContent: $encryptedContent, isEncrypted: $isEncrypted, deliveryStatus: $deliveryStatus}';
  }
}
