class FlutterBitchatPermissionStatus {
  final bool hasBluetoothPermission;
  final bool hasLocationPermission;
  final bool hasNotificationPermission;

  const FlutterBitchatPermissionStatus({
    required this.hasBluetoothPermission,
    required this.hasLocationPermission,
    required this.hasNotificationPermission,
  });

  @override
  String toString() {
    return 'FlutterBitchatPermissionStatus{hasBluetoothPermission: $hasBluetoothPermission, hasLocationPermission: $hasLocationPermission, hasNotificationPermission: $hasNotificationPermission}';
  }
}
