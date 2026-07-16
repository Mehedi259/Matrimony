class ChatRoomModel {
  final String id;
  final String roomId;
  final int unreadCount;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  ChatRoomModel({
    required this.id,
    required this.roomId,
    required this.unreadCount,
    this.lastMessageAt,
    required this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'],
      roomId: json['room_id'],
      unreadCount: json['unread_count'] ?? 0,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderRole;
  final String message;
  final String? attachment;
  final bool isRead;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderRole,
    required this.message,
    this.attachment,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      senderRole: json['sender_role'],
      message: json['message'],
      attachment: json['attachment'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
