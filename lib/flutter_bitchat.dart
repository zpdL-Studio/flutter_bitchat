import 'dart:async';

import 'package:flutter_bitchat/data/flutter_bitchat_permission_status.dart';

import 'flutter_bitchat_call_handler.dart';
import 'flutter_bitchat_platform_interface.dart';

class FlutterBitchat {
  static FlutterBitchat get instance => _instance;

  static final FlutterBitchat _instance = FlutterBitchat._();

  factory FlutterBitchat() {
    return _instance;
  }

  FlutterBitchat._();

  set delegate(FlutterBitchatCallHandler? value) {
    FlutterBitchatPlatform.instance.setMethodCallHandler(value);
  }

  Future<FlutterBitchatPermissionStatus> getPermissionStatus() {
    return FlutterBitchatPlatform.instance.getPermissionStatus();
  }

  Future<bool> requestPermission() {
    return FlutterBitchatPlatform.instance.requestPermission();
  }

  Future<String> myPeerID() => FlutterBitchatPlatform.instance.myPeerID();

  Future<void> startMeshService() =>
      FlutterBitchatPlatform.instance.startMeshService();

  Future<void> stopMeshService() =>
      FlutterBitchatPlatform.instance.stopMeshService();
}

// class FlutterBitchatBluetoothMeshDelegateEventChannel {
//   static FlutterBitchatBluetoothMeshDelegateEventChannel get instance =>
//       _instance;
//
//   static final FlutterBitchatBluetoothMeshDelegateEventChannel _instance =
//       FlutterBitchatBluetoothMeshDelegateEventChannel._();
//
//   factory FlutterBitchatBluetoothMeshDelegateEventChannel() {
//     return _instance;
//   }
//
//   FlutterBitchatBluetoothMeshDelegateEventChannel._();
//
//   final EventChannel _eventChannel = EventChannel(
//     'flutter_bitchat_bluetooth_mesh_delegate',
//   );
//
//   StreamSubscription? _subscription;
//
//   final _eventValue = ValueNotifier<dynamic>(null);
//
//   dynamic get value => _eventValue.value;
//
//   void addListener(VoidCallback listener) {
//     _subscription ??= _eventChannel.receiveBroadcastStream().listen((event) {
//       debugPrint('flutter_bitchat_bluetooth_mesh_delegate -> $event');
//       _eventValue.value = event;
//     });
//
//     _eventValue.addListener(listener);
//   }
//
//   void removeListener(VoidCallback listener) {
//     _eventValue.removeListener(listener);
//   }
// }
