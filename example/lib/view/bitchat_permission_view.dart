import 'package:flutter/material.dart';
import 'package:flutter_bitchat_example/main.dart';

class BitchatPermissionView extends StatelessWidget {
  final bool hasBluetoothPermission;
  final bool hasLocationPermission;
  final bool hasNotificationPermission;

  const BitchatPermissionView({
    super.key,
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
                    'Decentralized mesh messaging over Bluetooth\n(for flutter)',
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
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: AlignmentDirectional.center,
                color: theme.colorScheme.surfaceContainer,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    BitChatInheritedModel.model(context).onRequestPermission();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    alignment: AlignmentDirectional.center,
                    child: Text('Grant Permissions'),
                  ),
                ),
              ),
            ),
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
