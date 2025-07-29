import 'package:flutter/foundation.dart';

sealed class DeliveryStatus {
  static DeliveryStatus? fromJson(dynamic json) {
    if (json is! Map) {
      return null;
    }

    try {
      final type = DeliveryStatusType.values.byName(json['type']);
      switch (type) {
        case DeliveryStatusType.Sending:
          return DeliveryStatusSending();
        case DeliveryStatusType.Sent:
          throw DeliveryStatusSent();
        case DeliveryStatusType.Delivered:
          return DeliveryStatusDelivered(
            to: json['to'],
            at: DateTime.fromMillisecondsSinceEpoch(json['at']),
          );
        case DeliveryStatusType.Read:
          return DeliveryStatusRead(
            by: json['by'],
            at: DateTime.fromMillisecondsSinceEpoch(json['at']),
          );
        case DeliveryStatusType.Failed:
          return DeliveryStatusFailed(reason: json['reason']);
        case DeliveryStatusType.PartiallyDelivered:
          return DeliveryStatusPartiallyDelivered(
            reached: json['reached'],
            total: json['total'],
          );
      }
    } catch (e) {
      debugPrint('DeliveryStatus.fromJson -> e: $e');
    }

    return null;
  }
}

enum DeliveryStatusType {
  Sending,
  Sent,
  Delivered,
  Read,
  Failed,
  PartiallyDelivered,
}

class DeliveryStatusSending implements DeliveryStatus {

  @override
  String toString() {
    return 'DeliveryStatusSending{}';
  }
}

class DeliveryStatusSent implements DeliveryStatus {

  @override
  String toString() {
    return 'DeliveryStatusSent{}';
  }
}

class DeliveryStatusDelivered implements DeliveryStatus {
  final String to;
  final DateTime at;

  DeliveryStatusDelivered({required this.to, required this.at});

  @override
  String toString() {
    return 'DeliveryStatusDelivered{to: $to, at: $at}';
  }
}

class DeliveryStatusRead implements DeliveryStatus {
  final String by;
  final DateTime at;

  DeliveryStatusRead({required this.by, required this.at});

  @override
  String toString() {
    return 'DeliveryStatusRead{by: $by, at: $at}';
  }
}

class DeliveryStatusFailed implements DeliveryStatus {
  final String reason;

  DeliveryStatusFailed({required this.reason});

  @override
  String toString() {
    return 'DeliveryStatusFailed{reason: $reason}';
  }
}

class DeliveryStatusPartiallyDelivered implements DeliveryStatus {
  final int reached;
  final int total;

  DeliveryStatusPartiallyDelivered({
    required this.reached,
    required this.total,
  });

  @override
  String toString() {
    return 'DeliveryStatusPartiallyDelivered{reached: $reached, total: $total}';
  }
}
