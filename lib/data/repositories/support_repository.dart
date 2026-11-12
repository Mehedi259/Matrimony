import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/storage_service.dart';
import '../models/support/support_models.dart';

class SupportRepository {
  final ApiClient _apiClient = ApiClient();

  static List<dynamic> extractListPayload(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) return results;
    }
    return const [];
  }

  String _resolveUserEmail(String? explicitEmail) {
    final trimmed = explicitEmail?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    try {
      final userData = StorageService().getUserData();
      final storedEmail = userData?['email']?.toString().trim();
      if (storedEmail != null && storedEmail.isNotEmpty) {
        return storedEmail;
      }
    } catch (_) {}
    return 'user@amuslimmatchmaker.com';
  }

  // ========== FAQs ==========

  Future<List<FaqModel>> getFaqs() async {
    final response = await _apiClient.get(ApiConstants.faqs);
    return extractListPayload(response.data)
        .map((faq) => FaqModel.fromJson(faq as Map<String, dynamic>))
        .toList();
  }

  Future<FaqModel> getFaqById(String id) async {
    final response = await _apiClient.get('${ApiConstants.faqs}$id/');
    return FaqModel.fromJson(response.data);
  }

  // ========== TERMS & PRIVACY ==========

  Future<TermsModel> getTerms() async {
    final response = await _apiClient.get(ApiConstants.terms);
    return TermsModel.fromJson(response.data);
  }

  Future<PrivacyModel> getPrivacy() async {
    final response = await _apiClient.get(ApiConstants.privacy);
    return PrivacyModel.fromJson(response.data);
  }

  Future<String> getPrivacyHeader() async {
    final response = await _apiClient.get(ApiConstants.privacyHeader);
    return response.data['header'] ?? '';
  }

  // ========== FEEDBACK ==========

  Future<Map<String, dynamic>> submitFeedback({
    required String feedbackType,
    required String message,
    String? email,
  }) async {
    final trimmedSubject = feedbackType.trim();
    final response = await _apiClient.post(
      ApiConstants.submitFeedback,
      data: {
        'subject': trimmedSubject.isNotEmpty ? trimmedSubject : 'General Feedback',
        'email': _resolveUserEmail(email),
        'message': message.trim(),
      },
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
  }

  Future<List<FeedbackModel>> getMyFeedbacks() async {
    final response = await _apiClient.get(ApiConstants.myFeedbacks);
    return extractListPayload(response.data)
        .map((feedback) => FeedbackModel.fromJson(feedback as Map<String, dynamic>))
        .toList();
  }
}
