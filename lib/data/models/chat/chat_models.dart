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
    final dynamic lastMsg = json['last_message'];
    final dynamic rawLastMessageAt = json['last_message_at'] ??
        (lastMsg is Map ? lastMsg['created_at'] : null) ??
        json['updated_at'];

    return ChatRoomModel(
      id: json['id'].toString(),
      roomId: (json['room_id'] ?? json['id']).toString(),
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      lastMessageAt: rawLastMessageAt != null
          ? DateTime.tryParse(rawLastMessageAt.toString())
          : null,
      createdAt: DateTime.parse(json['created_at'].toString()),
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
      id: json['id'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderRole: json['sender_is_admin'] == true ? 'admin' : (json['sender_role'] ?? 'user'),
      message: json['text'] ?? json['message'] ?? '',
      attachment: json['attachment_url'] ?? json['attachment'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}
