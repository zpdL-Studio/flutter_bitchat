import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_bitchat/data/flutter_bitchat_permission_status.dart';
import 'package:flutter_bitchat/flutter_bitchat.dart';
import 'package:flutter_bitchat/flutter_bitchat_call_handler.dart';
import 'package:flutter_bitchat/manager/data/flutter_bitchat_channel_data.dart';
import 'package:flutter_bitchat/manager/data/flutter_bitchat_message.dart';
import 'package:flutter_bitchat/manager/flutter_bitchat_data_manager.dart';
import 'package:flutter_bitchat/manager/flutter_bitchat_message_manager.dart';
import 'package:flutter_bitchat_example/view/bitchat_chatting_view.dart';
import 'package:flutter_bitchat_example/view/bitchat_permission_view.dart';
import 'package:flutter_bitchat_example/view/bitchat_splash_view.dart';
import 'package:flutter_inherited_model/flutter_inherited_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'main.g.dart';

void main() {
  runApp(const BitchatApp());
}

@FlutterInheritedModel(name: 'BitChatInheritedModel', useAsyncWorker: true)
class BitChatModel with $BitChatModel implements FlutterBitchatCallHandler {
  BitChatModel._();

  bool _bitchatInit = false;
  final bitchat = FlutterBitchat();
  final dataManager = BitchatDataManager();
  late final messageManager = FlutterBitchatMessageManager(
    (messages) => this.messages = messages,
  );

  @inheritedModelState
  FlutterBitchatPermissionStatus? permissionStatus;

  @inheritedModelState
  String? nickName;
  @inheritedModelState
  FlutterBitchatChannelData channelData =
      const FlutterBitchatChannelData.empty();
  @inheritedModelState
  var channelMembers = <String, Set<String>>{};

  @inheritedModelState
  var connectedPeers = <String>[];
  @inheritedModelState
  var isConnected = false;

  @inheritedModelState
  List<FlutterBitchatMessage> messages = [];

  @override
  void onInitState() async {
    bitchat.delegate = this;
    permissionStatus = await bitchat.getPermissionStatus();
    debugPrint('permissionStatus: $permissionStatus');
    if (permissionStatus?.hasAllPermissions == true) {
      _startMeshService();
    }
  }

  @override
  void onDispose() {
    bitchat.delegate = null;
    super.onDispose();
  }

  void onRequestPermission() async {
    asyncWorker(() async {
      final result = await bitchat.requestPermission();
      permissionStatus = await bitchat.getPermissionStatus();
      debugPrint(
        'onRequestPermission -> result: $result, permissionStatus: $permissionStatus',
      );
      if (permissionStatus?.hasAllPermissions == true) {
        _startMeshService();
      }
    });
  }

  void _startMeshService() {
    asyncWorker(() async {
      if (!_bitchatInit) {
        _bitchatInit = true;
        nickName = await dataManager.loadNickname();
        channelData = await dataManager.loadChannelData();
        Future.delayed(const Duration(seconds: 1)).then((_) {
          if (connectedPeers.isEmpty && messages.isEmpty) {
            final welcomeMessage = FlutterBitchatMessage(
              id: Uuid().v4(),
              sender: "system",
              content:
                  "get people around you to download bitchat…and chat with them here!",
              timestamp: DateTime.now(),
              isRelay: false,
            );
            messageManager.addMessage(welcomeMessage);
          }
        });
      }
      await bitchat.startMeshService();
    }, (e, stackTrace) {});
  }

  @override
  void didReceiveMessage(FlutterBitchatMessage message) {
    debugPrint('BitChatModel.didReceiveMessage -> message: $message');
    final messageKey = messageManager.generateMessageKey(message);
    if (messageManager.isMessageProcessed(messageKey)) {
      return;
    }
    messageManager.markMessageProcessed(messageKey);
    final senderPeerID = message.senderPeerID;
    if (senderPeerID != null) {
      // if (privateChatManager.isPeerBlocked(senderPeerID)) {
      //   return@launch
      // }
    }
    // // Trigger haptic feedback
    // onHapticFeedback()

    if(message.isPrivate) {
      /// TODO
    } else if(message.channel != null) {
      /// TODO
    } else {
      messageManager.addMessage(message);
    }

    // Periodic cleanup
    if (messageManager.isMessageProcessed("cleanup_check_${DateTime
        .now()
        .millisecondsSinceEpoch / 30000}")) {
      messageManager.cleanupDeduplicationCaches();
    }
  }

  @override
  Future<String?> getNickname() async {
    return nickName;
  }

  @override
  void didConnectToPeer(String peerID) {
    debugPrint('BitChatModel.didConnectToPeer -> peerID: $peerID');
    if (messageManager.isDuplicateSystemEvent('connect', peerID)) {
      return;
    }

    final systemMessage = FlutterBitchatMessage(
      id: Uuid().v4(),
      sender: "system",
      content: "$peerID connected",
      timestamp: DateTime.now(),
      isRelay: false,
    );
    messageManager.addMessage(systemMessage);
  }

  @override
  void didUpdatePeerList(List<String> peers) {
    debugPrint('BitChatModel.didUpdatePeerList -> peers: $peers');
    connectedPeers = peers;
    isConnected = peers.isNotEmpty;

    //   // Clean up channel members who disconnected
    //   channelManager.cleanupDisconnectedMembers(peers, getMyPeerID())
    //
    //   // Exit private chat if peer disconnected
    //   state.getSelectedPrivateChatPeerValue()?.let { currentPeer ->
    //   if (!peers.contains(currentPeer)) {
    //   privateChatManager.cleanupDisconnectedPeer(currentPeer)
    //   }
    // }
  }

  @override
  void registerPeerPublicKey(String peerID, String fingerprint) {
    debugPrint(
      'BitChatModel.registerPeerPublicKey -> peerID: $peerID, fingerprint: $fingerprint,',
    );
  }
}

class BitchatDataManager implements FlutterBitchatDataManager {
  @override
  Future<String> loadNickname() async {
    String? nickName = (await SharedPreferences.getInstance()).getString(
      'bitchat_nick_name',
    );
    if (nickName != null) {
      return nickName;
    }

    nickName = "anon${math.Random().nextInt(8999) + 1000}";
    await saveNickname(nickName);
    return nickName;
  }

  @override
  Future<bool> saveNickname(String nickname) async {
    return await (await SharedPreferences.getInstance()).setString(
      'bitchat_nick_name',
      nickname,
    );
  }

  @override
  Future<FlutterBitchatChannelData> loadChannelData() async {
    try {
      final jsonString = (await SharedPreferences.getInstance()).getString(
        'bitchat_channel_data',
      );
      return FlutterBitchatChannelData.fromJson(
        json.decode(jsonString ?? '{}'),
      );
    } catch (e) {
      debugPrint('BitchatDataManager.loadChannelData -> e: $e');
    }

    return const FlutterBitchatChannelData.empty();
  }

  @override
  Future<void> saveChannelData(FlutterBitchatChannelData data) async {
    (await SharedPreferences.getInstance()).setString(
      'bitchat_channel_data',
      json.encode(data.toJson()),
    );
  }

  //
  // @override
  // Future<(List<String>, List<String>)> loadChannelData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final savedChannels = prefs.getStringList("joined_channels") ?? [];
  //   final savedProtectedChannels = prefs.getStringList("password_protected_channels") ?? [];
  //
  //   try {
  //     final creatorsJson = prefs.getString("channel_creators");
  //     if(creatorsJson != null) {
  //       final map = json.decode(creatorsJson);
  //       if(map is Map) {
  //
  //       }
  //     }
  //   } catch(_) {}
  //
  // }
  //
  // @override
  // Future<void> saveChannelData(List<String> joinedChannels, List<String> passwordProtectedChannels) {
  //   // TODO: implement saveChannelData
  //   throw UnimplementedError();
  // }
}

class BitchatApp extends StatelessWidget {
  const BitchatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
        ),
      ),
      // supportedLocales: const [Locale('ko', 'KR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          return BitChatInheritedModel(child: _BitchatApp());
        },
      ),
    );
  }
}

class _BitchatApp extends StatelessWidget {
  const _BitchatApp();

  @override
  Widget build(BuildContext context) {
    final permissionStatus = BitChatInheritedModel.permissionStatusOf(context);
    if (permissionStatus == null) {
      return const BitchatSplashView();
    }
    final hasBluetoothPermission = permissionStatus.hasBluetoothPermission;
    final hasLocationPermission = permissionStatus.hasLocationPermission;
    final hasNotificationPermission =
        permissionStatus.hasNotificationPermission;
    if (!hasBluetoothPermission ||
        !hasLocationPermission ||
        !hasNotificationPermission) {
      return BitchatPermissionView(
        hasBluetoothPermission: hasBluetoothPermission,
        hasLocationPermission: hasLocationPermission,
        hasNotificationPermission: hasNotificationPermission,
      );
    }
    return BitchatChattingView();
  }
}
