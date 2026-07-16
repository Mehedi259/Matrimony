import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/support/support_models.dart';

class SupportRepository {
  final ApiClient _apiClient = ApiClient();

  // ========== FAQs ==========

  Future<List<FaqModel>> getFaqs() async {
    final response = await _apiClient.get(ApiConstants.faqs);
    return (response.data as List)
        .map((faq) => FaqModel.fromJson(faq))
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
  }) async {
    final response = await _apiClient.post(
      ApiConstants.submitFeedback,
      data: {
        'feedback_type': feedbackType,
        'message': message,
      },
    );
    return response.data;
  }

  Future<List<FeedbackModel>> getMyFeedbacks() async {
    final response = await _apiClient.get(ApiConstants.myFeedbacks);
    return (response.data as List)
        .map((feedback) => FeedbackModel.fromJson(feedback))
        .toList();
  }
}
