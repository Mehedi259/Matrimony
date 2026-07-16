import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/chat/chat_models.dart';

class ChatRepository {
  final ApiClient _apiClient = ApiClient();

  // ========== CHAT ROOM ==========

  Future<ChatRoomModel> getMyChatRoom() async {
    final response = await _apiClient.get(ApiConstants.myChatRoom);
    return ChatRoomModel.fromJson(response.data);
  }

  // ========== MESSAGES ==========

  Future<List<ChatMessageModel>> getMessages({
    int page = 1,
    int pageSize = 50,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };

    final response = await _apiClient.get(
      ApiConstants.myChatMessages,
      queryParameters: queryParams,
    );

    if (response.data is Map && response.data['results'] != null) {
      return (response.data['results'] as List)
          .map((msg) => ChatMessageModel.fromJson(msg))
          .toList();
    } else if (response.data is List) {
      return (response.data as List)
          .map((msg) => ChatMessageModel.fromJson(msg))
          .toList();
    }
    return [];
  }

  Future<ChatMessageModel> sendMessage({
    required String message,
    String? attachmentPath,
  }) async {
    if (attachmentPath != null) {
      final response = await _apiClient.uploadFile(
        ApiConstants.myChatMessages,
        filePath: attachmentPath,
        fieldName: 'attachment',
        additionalData: {'message': message},
      );
      return ChatMessageModel.fromJson(response.data);
    } else {
      final response = await _apiClient.post(
        ApiConstants.myChatMessages,
        data: {'message': message},
      );
      return ChatMessageModel.fromJson(response.data);
    }
  }

  Future<void> markMessagesAsRead() async {
    await _apiClient.post(ApiConstants.markMessagesRead);
  }

  Future<String> getAttachmentDownloadUrl(String messageId) async {
    return '${ApiConstants.myChatMessages}$messageId/download/';
  }
}
