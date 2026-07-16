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
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      order: json['order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
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
      content: json['content'],
      updatedAt: DateTime.parse(json['updated_at']),
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
      content: json['content'],
      updatedAt: DateTime.parse(json['updated_at']),
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
      id: json['id'],
      feedbackType: json['feedback_type'],
      message: json['message'],
      response: json['response'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
