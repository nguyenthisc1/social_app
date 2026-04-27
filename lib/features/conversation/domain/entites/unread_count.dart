import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UnreadCount extends Equatable {
  final int count;
  final String? lastReadMessageId;
  final Timestamp? lastReadAt;

  const UnreadCount({
    required this.count,
    this.lastReadAt,
    this.lastReadMessageId,
  });

  @override
  List<Object?> get props => [count, lastReadMessageId, lastReadAt];

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'lastReadAt': lastReadAt,
      'lastReadMessageId': lastReadMessageId,
    };
  }

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    final lastReadAtRaw = json['lastReadAt'];

    return UnreadCount(
      count: json['count'] ?? 0,
      lastReadAt: switch (lastReadAtRaw) {
        Timestamp value => value,
        int value => Timestamp.fromMillisecondsSinceEpoch(value),
        Map<String, dynamic> value
            when value['millisecondsSinceEpoch'] is int =>
          Timestamp.fromMillisecondsSinceEpoch(
            value['millisecondsSinceEpoch'] as int,
          ),
        Map value when value['millisecondsSinceEpoch'] is int =>
          Timestamp.fromMillisecondsSinceEpoch(
            value['millisecondsSinceEpoch'] as int,
          ),
        _ => null,
      },
      lastReadMessageId: json['lastReadMessageId'] as String?,
    );
  }

  UnreadCount copyWith({
    int? count,
    String? lastReadMessageId,
    Timestamp? lastReadAt,
  }) {
    return UnreadCount(
      count: count ?? this.count,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
    );
  }
}
