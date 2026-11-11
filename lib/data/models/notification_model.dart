class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final String? type;
  final String? priority;
  final Map<String, dynamic>? data;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    this.type,
    this.priority,
    this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['message'] ?? 'Notification',
      body: json['body'] ?? json['description'] ?? '',
      isRead: json['is_read'] ?? json['read'] ?? false,
      type: json['notification_type'] ?? json['type'],
      priority: json['priority']?.toString(),
      data: json['data'] is Map
          ? Map<String, dynamic>.from(json['data'] as Map)
          : null,
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'is_read': isRead,
      'type': type,
      'created_at': createdAt,
    };
  }
}
