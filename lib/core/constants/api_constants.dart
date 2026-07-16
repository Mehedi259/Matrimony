class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.amuslimmatchmaker.com';
  static const String apiPrefix = '/api';

  // Auth Endpoints
  static const String maleRegisterInitiate = '$apiPrefix/user/male/register/initiate/';
  static const String maleRegisterVerify = '$apiPrefix/user/male/register/verify/';
  static const String femaleRegisterInitiate = '$apiPrefix/user/female/register/initiate/';
  static const String femaleRegisterVerify = '$apiPrefix/user/female/register/verify/';
  static const String waliRegisterInitiate = '$apiPrefix/user/wali/register/initiate/';
  static const String waliRegisterVerify = '$apiPrefix/user/wali/register/verify/';
  
  static const String maleLogin = '$apiPrefix/user/male/login/';
  static const String femaleLogin = '$apiPrefix/user/female/login/';
  static const String waliLogin = '$apiPrefix/user/wali/login/';
  
  static const String logout = '$apiPrefix/user/logout/';
  static const String resendOtp = '$apiPrefix/user/register/resend-otp/';
  
  // Password Reset
  static const String passwordResetInitiate = '$apiPrefix/user/password-reset/initiate/';
  static const String passwordResetVerify = '$apiPrefix/user/password-reset/verify/';
  static const String passwordResetConfirm = '$apiPrefix/user/password-reset/confirm/';
  static const String changePassword = '$apiPrefix/user/password/change/';

  // User Profile
  static const String profile = '$apiPrefix/user/profile/';
  static const String profilePicture = '$apiPrefix/user/profile/picture/';
  static const String deactivate = '$apiPrefix/user/profile/deactivate/';
  static const String whyLeaving = '$apiPrefix/user/why-leaving/';

  // Questions/Profile Setup
  static const String maleBasicInfo = '$apiPrefix/questions/male/basic-info/';
  static const String femaleBasicInfo = '$apiPrefix/questions/female/basic-info/';
  static const String waliBasicInfo = '$apiPrefix/questions/wali/basic-info/';
  
  static const String malePhotos = '$apiPrefix/questions/male/photos/';
  static const String femalePhotos = '$apiPrefix/questions/female/photos/';
  static const String waliPhotos = '$apiPrefix/questions/wali/photos/';

  // Matches
  static const String matchesDirectory = '$apiPrefix/matches/directory/';
  static const String matchesDirectoryProfile = '$apiPrefix/matches/directory/'; // + userId
  static const String matches = '$apiPrefix/matches/';
  
  static const String sendRequest = '$apiPrefix/matches/requests/send/';
  static const String resendRequest = '$apiPrefix/matches/requests/resend/';
  static const String sentRequests = '$apiPrefix/matches/requests/sent/';
  static const String receivedRequests = '$apiPrefix/matches/requests/received/';
  static const String respondRequest = '$apiPrefix/matches/requests/'; // + id + /respond/
  static const String cancelRequest = '$apiPrefix/matches/requests/'; // + id + /cancel/

  // Matchmaking
  static const String myMatchmakingRequest = '$apiPrefix/matchmaking/my-request/';

  // Chat
  static const String myChatRoom = '$apiPrefix/chat/my-room/';
  static const String myChatMessages = '$apiPrefix/chat/my-room/messages/';
  static const String markMessagesRead = '$apiPrefix/chat/my-room/mark-read/';
  static const String downloadAttachment = '$apiPrefix/chat/my-room/messages/'; // + messageId + /download/

  // Support
  static const String faqs = '$apiPrefix/supports/faqs/';
  static const String terms = '$apiPrefix/supports/terms/';
  static const String privacy = '$apiPrefix/supports/privacy/';
  static const String privacyHeader = '$apiPrefix/supports/privacy-header/';
  static const String submitFeedback = '$apiPrefix/supports/feedback/submit/';
  static const String myFeedbacks = '$apiPrefix/supports/feedback/my-feedbacks/';

  // Notifications
  static const String notifications = '$apiPrefix/notification/';

  // Wishlists
  static const String wishlists = '$apiPrefix/wishlists/';

  // WebSocket
  static const String wsBaseUrl = 'wss://api.amuslimmatchmaker.com';
  static const String wsNotifications = '/ws/notifications/';
  static const String wsChat = '/ws/chat/'; // + roomId + /

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
