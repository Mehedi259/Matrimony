class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final String? type;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    this.type,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['message'] ?? 'Notification',
      body: json['body'] ?? json['description'] ?? '',
      isRead: json['is_read'] ?? json['read'] ?? false,
      type: json['type'],
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
