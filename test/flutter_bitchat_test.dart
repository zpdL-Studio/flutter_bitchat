// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bitchat/flutter_bitchat.dart';
// import 'package:flutter_bitchat/flutter_bitchat_platform_interface.dart';
// import 'package:flutter_bitchat/flutter_bitchat_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockFlutterBitchatPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterBitchatPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final FlutterBitchatPlatform initialPlatform = FlutterBitchatPlatform.instance;
//
//   test('$MethodChannelFlutterBitchat is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterBitchat>());
//   });
//
//   test('getPlatformVersion', () async {
//     FlutterBitchat flutterBitchatPlugin = FlutterBitchat();
//     MockFlutterBitchatPlatform fakePlatform = MockFlutterBitchatPlatform();
//     FlutterBitchatPlatform.instance = fakePlatform;
//
//     expect(await flutterBitchatPlugin.getPlatformVersion(), '42');
//   });
// }
