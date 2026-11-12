class FaqModel {
  final String id;
  final String question;
  final String answer;
  final int order;
  final DateTime createdAt;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.order,
    required this.createdAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class TermsModel {
  final String content;
  final DateTime updatedAt;

  TermsModel({
    required this.content,
    required this.updatedAt,
  });

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    return TermsModel(
      content: json['content']?.toString() ?? '',
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class PrivacyModel {
  final String content;
  final DateTime updatedAt;

  PrivacyModel({
    required this.content,
    required this.updatedAt,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      content: json['content']?.toString() ?? '',
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class FeedbackModel {
  final String id;
  final String feedbackType;
  final String message;
  final String? response;
  final String status;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.feedbackType,
    required this.message,
    this.response,
    required this.status,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id']?.toString() ?? '',
      feedbackType:
          (json['feedback_type'] ?? json['subject'])?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      response: json['response']?.toString(),
      status: json['status']?.toString() ?? 'submitted',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
