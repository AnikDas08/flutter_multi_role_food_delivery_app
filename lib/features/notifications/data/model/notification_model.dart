class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String linkId;
  final String type;
  final String role;
  final String receiver;
  final int v;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    this.title = '',
    required this.message,
    required this.linkId,
    required this.type,
    required this.role,
    required this.receiver,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? linkId,
    String? type,
    String? role,
    String? receiver,
    int? v,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      linkId: linkId ?? this.linkId,
      type: type ?? this.type,
      role: role ?? this.role,
      receiver: receiver ?? this.receiver,
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic>? json) {
    return NotificationModel(
      id: json?['_id'] ?? '',
      title: json?['title'] ?? (json?['type'] ?? 'Notification'),
      message: json?['message'] ?? '',
      linkId: json?['linkId'] ?? '',
      type: json?['type'] ?? '',
      role: json?['role'] ?? '',
      receiver: json?['receiver'] ?? '',
      v: json?['__v'] ?? 0,
      createdAt:
          DateTime.tryParse(json?['createdAt'] ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json?['updatedAt'] ?? '') ??
          DateTime.now(),
      isRead: json?['isRead'] ?? false,
    );
  }
}
