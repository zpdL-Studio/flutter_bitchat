import 'package:flutter/material.dart';

import 'package:flutter_bitchat/data/flutter_bitchat_permission_status.dart';
import 'package:flutter_bitchat/flutter_bitchat.dart';
import 'package:flutter_inherited_model/flutter_inherited_model.dart';

part 'main.g.dart';

void main() {
  runApp(const BitchatApp());
}

@FlutterInheritedModel(name: 'BitChatInheritedModel')
class BitChatModel with $BitChatModel {
  BitChatModel._();

  final bitchat = FlutterBitchat();

  @inheritedModelState
  FlutterBitchatPermissionStatus? permissionStatus;

  @override
  void onInitState() async {
    super.onInitState();
    permissionStatus = await FlutterBitchat.getPermissionStatus();
    debugPrint('permissionStatus: $permissionStatus');
  }
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
      home: BitChatInheritedModel(child: _BitchatApp()),
    );
  }
}

class _BitchatApp extends StatelessWidget {
  const _BitchatApp();

  @override
  Widget build(BuildContext context) {
    final permissionStatus = BitChatInheritedModel.permissionStatusOf(context);
    if (permissionStatus == null) {
      return const _BitchatSplash();
    }
    final hasBluetoothPermission = permissionStatus.hasBluetoothPermission;
    final hasLocationPermission = permissionStatus.hasLocationPermission;
    final hasNotificationPermission =
        permissionStatus.hasNotificationPermission;
    if (!hasBluetoothPermission ||
        !hasLocationPermission ||
        !hasNotificationPermission) {
      return _BitchatPermission(
        hasBluetoothPermission: hasBluetoothPermission,
        hasLocationPermission: hasLocationPermission,
        hasNotificationPermission: hasNotificationPermission,
      );
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Running on: \n')),
      ),
    );
  }
}

class _BitchatSplash extends StatelessWidget {
  const _BitchatSplash();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'bitchat*',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'for flutter',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(),
            const SizedBox(height: 128),
            Text(
              'Initializing mesh network',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BitchatPermission extends StatelessWidget {
  final bool hasBluetoothPermission;
  final bool hasLocationPermission;
  final bool hasNotificationPermission;

  const _BitchatPermission({
    required this.hasBluetoothPermission,
    required this.hasLocationPermission,
    required this.hasNotificationPermission,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 64,
                bottom: 80,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  Text(
                    'Welcome to bitchat*',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Decentralized mesh messaging over Bluetooth (for flutter)',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            '🔒 Your Privacy is Protected',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '''
• bitchat doesn't track you or collect personal data
• No servers, no internet required, no data logging
• Location permission is only used by Android for Bluetooth scanning
• Your messages stay on your device and peer devices only''',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'To work properly, bitchat needs these permissions:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      _buildPermission(
                        theme,
                        '📱',
                        'Nearby Devices',
                        'Required to discover bitchat users via Bluetooth',
                        hasBluetoothPermission,
                      ),
                      _buildPermission(
                        theme,
                        '📍',
                        'Precise Location',
                        'Required by Android to discover nearby bitchat users via Bluetooth',
                        hasLocationPermission,
                      ),
                      _buildPermission(
                        theme,
                        '🔔',
                        'Notifications',
                        'Receive notifications when you receive private messages',
                        hasNotificationPermission,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(alignment: AlignmentDirectional.bottomCenter, child: Container(
              width: double.infinity,
              height: 60,
              alignment: AlignmentDirectional.center,
              color: theme.colorScheme.surfaceContainer,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(onPressed: () {}, child: Container(
                width: double.infinity,
                height: 44,
                alignment: AlignmentDirectional.center,
                child: Text('Grant Permissions'),
              )),
            ),)
          ],
        ),
      ),
    );
  }

  Widget _buildPermission(
    ThemeData theme,
    String icon,
    String name,
    String desc,
    bool hasPermission,
  ) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Text(icon, style: theme.textTheme.titleLarge),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                hasPermission ? Icon(Icons.check) : Icon(Icons.do_not_disturb),
              ],
            ),
            Text(desc, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
