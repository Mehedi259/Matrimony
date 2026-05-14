# Design Document: Authentication and Onboarding Flow

## Overview

This design document specifies the technical architecture and implementation details for a comprehensive authentication and onboarding system for a Muslim matrimonial matchmaking Flutter application. The system encompasses 18 distinct screens with sophisticated UI/UX patterns including multi-step forms, social authentication, real-time validation, photo management, and subscription handling.

### Design Goals

1. **User Experience Excellence**: Provide smooth, delightful interactions with thoughtful animations and micro-interactions
2. **Cultural Sensitivity**: Respect Islamic values and cultural norms throughout the user journey
3. **Privacy and Security**: Implement robust security measures for sensitive personal data and photos
4. **Accessibility**: Ensure the application is usable by people with diverse abilities
5. **Performance**: Deliver fast, responsive experiences even on lower-end devices
6. **Maintainability**: Create a modular, testable architecture that scales with feature growth

### Technology Stack

- **Framework**: Flutter 3.11.5+
- **Language**: Dart 3.11.5+
- **State Management**: Provider pattern with ChangeNotifier
- **Navigation**: GoRouter for declarative routing
- **Local Storage**: SharedPreferences for simple data, Hive for complex objects
- **Network**: Dio for HTTP requests with interceptors
- **Authentication**: Firebase Authentication for social auth, custom JWT for email/password
- **Image Handling**: image_picker, image_cropper, cached_network_image
- **Form Validation**: Custom validators with reactive forms
- **Animation**: Flutter's built-in Animation framework
- **Testing**: flutter_test, mockito, integration_test

## Architecture

### High-Level Architecture

The application follows a layered architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  (Screens, Widgets, Animations, Theme)                      │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────────────┐
│                   Business Logic Layer                       │
│  (Providers, ViewModels, Validators, State Management)      │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────────────┐
│                      Data Layer                              │
│  (Repositories, API Clients, Local Storage, Models)         │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────────────┐
│                   External Services                          │
│  (Backend API, Firebase, Payment Gateway, Cloud Storage)    │
└─────────────────────────────────────────────────────────────┘
```

### Directory Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_endpoints.dart
│   │   └── storage_keys.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_dimensions.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── extensions.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   └── network/
│       ├── api_client.dart
│       ├── network_info.dart
│       └── interceptors.dart
├── features/
│   └── auth_onboarding/
│       ├── data/
│       │   ├── models/
│       │   │   ├── user_model.dart
│       │   │   ├── profile_model.dart
│       │   │   ├── onboarding_data_model.dart
│       │   │   └── subscription_plan_model.dart
│       │   ├── datasources/
│       │   │   ├── auth_remote_datasource.dart
│       │   │   ├── auth_local_datasource.dart
│       │   │   └── photo_datasource.dart
│       │   └── repositories/
│       │       ├── auth_repository_impl.dart
│       │       ├── onboarding_repository_impl.dart
│       │       └── subscription_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── user.dart
│       │   │   ├── profile.dart
│       │   │   └── subscription_plan.dart
│       │   ├── repositories/
│       │   │   ├── auth_repository.dart
│       │   │   ├── onboarding_repository.dart
│       │   │   └── subscription_repository.dart
│       │   └── usecases/
│       │       ├── login_with_email.dart
│       │       ├── register_user.dart
│       │       ├── verify_email.dart
│       │       ├── reset_password.dart
│       │       ├── social_auth.dart
│       │       ├── save_onboarding_step.dart
│       │       └── subscribe_to_plan.dart
│       └── presentation/
│           ├── providers/
│           │   ├── auth_provider.dart
│           │   ├── onboarding_provider.dart
│           │   ├── form_validation_provider.dart
│           │   └── photo_upload_provider.dart
│           ├── screens/
│           │   ├── welcome_screen.dart
│           │   ├── login_screen.dart
│           │   ├── signup_screen.dart
│           │   ├── email_verification_screen.dart
│           │   ├── verified_success_screen.dart
│           │   ├── forgot_password_screen.dart
│           │   ├── create_new_password_screen.dart
│           │   ├── profile_type_selection_screen.dart
│           │   ├── wali_profile_info_screen.dart
│           │   ├── basic_information_screen.dart
│           │   ├── personal_details_screen.dart
│           │   ├── about_expectations_screen.dart
│           │   ├── upload_photos_screen.dart
│           │   ├── your_preferences_screen.dart
│           │   ├── subscription_plans_screen.dart
│           │   ├── my_profile_screen.dart
│           │   ├── home_browse_screen.dart
│           │   └── requests_screen.dart
│           └── widgets/
│               ├── common/
│               │   ├── gradient_button.dart
│               │   ├── custom_text_field.dart
│               │   ├── loading_indicator.dart
│               │   ├── error_message.dart
│               │   └── social_auth_button.dart
│               ├── onboarding/
│               │   ├── step_progress_indicator.dart
│               │   ├── profile_type_card.dart
│               │   ├── photo_upload_widget.dart
│               │   ├── age_range_slider.dart
│               │   └── tag_input_field.dart
│               └── animations/
│                   ├── slide_transition_wrapper.dart
│                   ├── scale_tap_animation.dart
│                   └── success_checkmark_animation.dart
└── shared/
    ├── widgets/
    │   ├── bottom_navigation_bar.dart
    │   └── profile_card.dart
    └── models/
        └── app_user.dart
```

## Components and Interfaces

### 1. Authentication System

#### AuthRepository Interface

```dart
abstract class AuthRepository {
  Future<Either<Failure, User>> loginWithEmail(String email, String password);
  Future<Either<Failure, User>> registerUser(UserRegistrationData data);
  Future<Either<Failure, void>> sendEmailVerification(String email);
  Future<Either<Failure, bool>> verifyEmailOTP(String email, String otp);
  Future<Either<Failure, void>> sendPasswordResetOTP(String email);
  Future<Either<Failure, void>> resetPassword(String email, String otp, String newPassword);
  Future<Either<Failure, User>> loginWithGoogle();
  Future<Either<Failure, User>> loginWithApple();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, String>> refreshToken();
}
```

#### AuthProvider (State Management)

```dart
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  AuthState _state = AuthState.initial();
  User? _currentUser;
  String? _authToken;
  
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  
  Future<void> loginWithEmail(String email, String password);
  Future<void> registerUser(UserRegistrationData data);
  Future<void> verifyEmail(String otp);
  Future<void> sendPasswordReset(String email);
  Future<void> resetPassword(String otp, String newPassword);
  Future<void> loginWithSocialProvider(SocialAuthProvider provider);
  Future<void> logout();
  void clearError();
}
```

### 2. Onboarding System

#### OnboardingRepository Interface

```dart
abstract class OnboardingRepository {
  Future<Either<Failure, void>> saveBasicInformation(BasicInformationData data);
  Future<Either<Failure, void>> savePersonalDetails(PersonalDetailsData data);
  Future<Either<Failure, void>> saveAboutExpectations(AboutExpectationsData data);
  Future<Either<Failure, List<String>>> uploadPhotos(List<File> photos);
  Future<Either<Failure, void>> savePreferences(PreferencesData data);
  Future<Either<Failure, OnboardingData>> getOnboardingProgress();
  Future<Either<Failure, void>> completeOnboarding();
}
```

#### OnboardingProvider (State Management)

```dart
class OnboardingProvider extends ChangeNotifier {
  final OnboardingRepository _repository;
  
  OnboardingData _data = OnboardingData.empty();
  int _currentStep = 0;
  bool _isLoading = false;
  String? _error;
  
  OnboardingData get data => _data;
  int get currentStep => _currentStep;
  int get totalSteps => 5;
  double get progress => (_currentStep + 1) / totalSteps;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> saveBasicInformation(BasicInformationData data);
  Future<void> savePersonalDetails(PersonalDetailsData data);
  Future<void> saveAboutExpectations(AboutExpectationsData data);
  Future<void> uploadPhotos(List<File> photos);
  Future<void> savePreferences(PreferencesData data);
  Future<void> loadProgress();
  void nextStep();
  void previousStep();
  void clearError();
}
```

### 3. Form Validation System

#### Validators Utility

```dart
class Validators {
  static String? validateEmail(String? value);
  static String? validatePassword(String? value);
  static String? validateConfirmPassword(String? password, String? confirmPassword);
  static String? validatePhoneNumber(String? value);
  static String? validateName(String? value);
  static String? validateAge(DateTime? dateOfBirth);
  static String? validateTextLength(String? value, int minLength, int maxLength);
  static String? validateRequired(String? value, String fieldName);
  
  static PasswordStrength calculatePasswordStrength(String password);
  static bool isValidEmailFormat(String email);
  static bool isValidPhoneFormat(String phone);
}
```

#### FormValidationProvider

```dart
class FormValidationProvider extends ChangeNotifier {
  final Map<String, String?> _errors = {};
  final Map<String, dynamic> _values = {};
  
  String? getError(String fieldName);
  dynamic getValue(String fieldName);
  bool get isValid => _errors.values.every((error) => error == null);
  
  void validateField(String fieldName, dynamic value, String? Function(dynamic) validator);
  void setValue(String fieldName, dynamic value);
  void clearField(String fieldName);
  void clearAll();
  Map<String, dynamic> getFormData();
}
```

### 4. Photo Management System

#### PhotoUploadProvider

```dart
class PhotoUploadProvider extends ChangeNotifier {
  final PhotoDatasource _datasource;
  
  List<PhotoUploadItem> _photos = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  
  List<PhotoUploadItem> get photos => _photos;
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;
  bool get canAddMore => _photos.length < 6;
  bool get hasMinimumPhotos => _photos.length >= 1;
  
  Future<void> pickPhoto();
  Future<void> pickMultiplePhotos();
  Future<void> removePhoto(int index);
  Future<void> uploadAllPhotos();
  void reorderPhotos(int oldIndex, int newIndex);
}
```

### 5. Navigation System

#### Route Configuration (GoRouter)

```dart
final router = GoRouter(
  initialLocation: '/welcome',
  redirect: (context, state) {
    final authProvider = context.read<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;
    final isOnboarding = state.location.startsWith('/onboarding');
    
    if (!isAuthenticated && !_publicRoutes.contains(state.location)) {
      return '/welcome';
    }
    
    if (isAuthenticated && !authProvider.currentUser!.hasCompletedOnboarding && !isOnboarding) {
      return '/onboarding/profile-type';
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) => const EmailVerificationScreen(),
    ),
    GoRoute(
      path: '/verified-success',
      builder: (context, state) => const VerifiedSuccessScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/create-new-password',
      builder: (context, state) => const CreateNewPasswordScreen(),
    ),
    GoRoute(
      path: '/onboarding/profile-type',
      builder: (context, state) => const ProfileTypeSelectionScreen(),
    ),
    GoRoute(
      path: '/onboarding/wali-info',
      builder: (context, state) => const WaliProfileInfoScreen(),
    ),
    GoRoute(
      path: '/onboarding/basic-info',
      builder: (context, state) => const BasicInformationScreen(),
    ),
    GoRoute(
      path: '/onboarding/personal-details',
      builder: (context, state) => const PersonalDetailsScreen(),
    ),
    GoRoute(
      path: '/onboarding/about-expectations',
      builder: (context, state) => const AboutExpectationsScreen(),
    ),
    GoRoute(
      path: '/onboarding/upload-photos',
      builder: (context, state) => const UploadPhotosScreen(),
    ),
    GoRoute(
      path: '/onboarding/preferences',
      builder: (context, state) => const YourPreferencesScreen(),
    ),
    GoRoute(
      path: '/subscription-plans',
      builder: (context, state) => const SubscriptionPlansScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeBrowseScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MyProfileScreen(),
    ),
    GoRoute(
      path: '/requests',
      builder: (context, state) => const RequestsScreen(),
    ),
  ],
);
```

## Data Models

### User Model

```dart
class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final ProfileType profileType;
  final bool isEmailVerified;
  final bool hasCompletedOnboarding;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final SubscriptionPlan? activePlan;
  
  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    required this.profileType,
    required this.isEmailVerified,
    required this.hasCompletedOnboarding,
    required this.createdAt,
    this.lastLoginAt,
    this.activePlan,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### OnboardingData Model

```dart
class OnboardingData {
  final ProfileType? profileType;
  final BasicInformationData? basicInfo;
  final PersonalDetailsData? personalDetails;
  final AboutExpectationsData? aboutExpectations;
  final List<String>? photoUrls;
  final PreferencesData? preferences;
  final int currentStep;
  
  OnboardingData({
    this.profileType,
    this.basicInfo,
    this.personalDetails,
    this.aboutExpectations,
    this.photoUrls,
    this.preferences,
    this.currentStep = 0,
  });
  
  factory OnboardingData.empty();
  factory OnboardingData.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  
  OnboardingData copyWith({
    ProfileType? profileType,
    BasicInformationData? basicInfo,
    PersonalDetailsData? personalDetails,
    AboutExpectationsData? aboutExpectations,
    List<String>? photoUrls,
    PreferencesData? preferences,
    int? currentStep,
  });
}
```

### BasicInformationData Model

```dart
class BasicInformationData {
  final String howDidYouFindUs;
  final Gender gender;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String city;
  final String country;
  
  BasicInformationData({
    required this.howDidYouFindUs,
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.city,
    required this.country,
  });
  
  factory BasicInformationData.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### PersonalDetailsData Model

```dart
class PersonalDetailsData {
  final String sect;
  final MaritalStatus maritalStatus;
  final String ethnicity;
  final String nationality;
  final String familyDetails;
  final double height;
  final double weight;
  final PrayerHabits prayerHabits;
  final RelocationPreference relocationPreference;
  final String? waliName;
  final String? waliContact;
  
  PersonalDetailsData({
    required this.sect,
    required this.maritalStatus,
    required this.ethnicity,
    required this.nationality,
    required this.familyDetails,
    required this.height,
    required this.weight,
    required this.prayerHabits,
    required this.relocationPreference,
    this.waliName,
    this.waliContact,
  });
  
  factory PersonalDetailsData.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### AboutExpectationsData Model

```dart
class AboutExpectationsData {
  final String ideaOfMarriage;
  final String relationshipWithIslam;
  final String roleAsSpouse;
  final String aboutYourself;
  final String spouseExpectations;
  final String marriageVision;
  final String spouseReligiousStatus;
  final String relocationOpenness;
  final String otherPreferences;
  
  AboutExpectationsData({
    required this.ideaOfMarriage,
    required this.relationshipWithIslam,
    required this.roleAsSpouse,
    required this.aboutYourself,
    required this.spouseExpectations,
    required this.marriageVision,
    required this.spouseReligiousStatus,
    required this.relocationOpenness,
    required this.otherPreferences,
  });
  
  factory AboutExpectationsData.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### PreferencesData Model

```dart
class PreferencesData {
  final int minAge;
  final int maxAge;
  final List<MaritalStatus> maritalStatusPreferences;
  final List<String> ethnicityPreferences;
  final String? countryPreference;
  
  PreferencesData({
    required this.minAge,
    required this.maxAge,
    required this.maritalStatusPreferences,
    required this.ethnicityPreferences,
    this.countryPreference,
  });
  
  factory PreferencesData.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### SubscriptionPlan Model

```dart
class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String currency;
  final BillingPeriod billingPeriod;
  final List<String> features;
  final bool isRecommended;
  
  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.billingPeriod,
    required this.features,
    this.isRecommended = false,
  });
  
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```


## Screen-by-Screen Component Breakdown

### 1. Welcome/Landing Screen

**Purpose**: First screen users see, provides authentication options

**Widget Tree**:
```
WelcomeScreen (StatelessWidget)
└── Scaffold
    └── SafeArea
        └── Column
            ├── Expanded
            │   └── Center
            │       └── IllustrationWidget (Muslim couple SVG)
            ├── Padding
            │   └── Column
            │       ├── Text (Welcome message)
            │       ├── SizedBox (spacing)
            │       ├── SocialAuthButton (Email)
            │       ├── SizedBox (spacing)
            │       ├── SocialAuthButton (Google)
            │       ├── SizedBox (spacing)
            │       ├── SocialAuthButton (Apple)
            │       └── TextButton (Already have account?)
            └── SizedBox (bottom padding)
```

**Key Components**:
- `SocialAuthButton`: Reusable button with icon, text, and gradient/outline styling
- `IllustrationWidget`: SVG renderer with proper sizing and aspect ratio

**State Management**:
- Consumes `AuthProvider` for authentication actions
- No local state required

**Animations**:
- Fade-in on screen load (500ms)
- Scale animation on button press (100ms)

**Navigation**:
- Email button → `/signup`
- Google/Apple button → Social auth flow → `/onboarding/profile-type` (new user) or `/home` (existing user)
- "Already have account" → `/login`

---

### 2. Login Screen

**Purpose**: Email/password authentication for returning users

**Widget Tree**:
```
LoginScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   └── BackButton
    └── SafeArea
        └── SingleChildScrollView
            └── Padding
                └── Form
                    └── Column
                        ├── Text (Welcome back)
                        ├── SizedBox
                        ├── CustomTextField (Email)
                        ├── SizedBox
                        ├── CustomTextField (Password with toggle)
                        ├── Row
                        │   ├── Checkbox (Remember me)
                        │   └── TextButton (Forgot password?)
                        ├── SizedBox
                        ├── GradientButton (Login)
                        └── ErrorMessage (if error)
```

**Key Components**:
- `CustomTextField`: Reusable text input with validation, icons, and error display
- `GradientButton`: Primary action button with gradient background
- `ErrorMessage`: Styled error display widget

**State Management**:
- Local state: Form key, text controllers, remember me checkbox
- Consumes `AuthProvider` for login action
- Consumes `FormValidationProvider` for real-time validation

**Animations**:
- Slide-in from right (300ms)
- Border color transition on focus (200ms)
- Button scale on press (100ms)
- Error shake animation (400ms)

**Validation**:
- Email: Real-time format validation
- Password: Required field validation
- Form-level: Both fields must be valid to enable button

**Navigation**:
- Success → `/home` (if onboarding complete) or `/onboarding/profile-type`
- Forgot password → `/forgot-password`
- Back button → `/welcome`

---

### 3. Sign Up Screen

**Purpose**: New user registration with email and password

**Widget Tree**:
```
SignupScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   └── BackButton
    └── SafeArea
        └── SingleChildScrollView
            └── Padding
                └── Form
                    └── Column
                        ├── Text (Create account)
                        ├── SizedBox
                        ├── CustomTextField (Email)
                        ├── SizedBox
                        ├── CustomTextField (Full name)
                        ├── SizedBox
                        ├── CustomTextField (Password with toggle)
                        ├── PasswordStrengthIndicator
                        ├── SizedBox
                        ├── CustomTextField (Confirm password)
                        ├── SizedBox
                        ├── CheckboxListTile (Terms and conditions)
                        ├── SizedBox
                        ├── GradientButton (Sign up)
                        └── ErrorMessage (if error)
```

**Key Components**:
- `PasswordStrengthIndicator`: Visual indicator showing password strength (weak/medium/strong)
- `CheckboxListTile`: Terms acceptance with clickable link

**State Management**:
- Local state: Form key, text controllers, terms checkbox, password visibility
- Consumes `AuthProvider` for registration
- Consumes `FormValidationProvider` for validation

**Animations**:
- Slide-in from right (300ms)
- Password strength bar animated fill (300ms)
- Checkmark animation on terms acceptance (200ms)

**Validation**:
- Email: Format + uniqueness check (debounced API call)
- Full name: Required, min 2 characters
- Password: Min 8 chars, uppercase, lowercase, number, special char
- Confirm password: Must match password
- Terms: Must be checked

**Navigation**:
- Success → `/verify-email`
- Back button → `/welcome`

---

### 4. Email Verification Screen

**Purpose**: OTP verification for email confirmation

**Widget Tree**:
```
EmailVerificationScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   └── BackButton
    └── SafeArea
        └── Padding
            └── Column
                ├── Spacer
                ├── Icon (Email icon)
                ├── SizedBox
                ├── Text (Verify your email)
                ├── Text (Email address display)
                ├── SizedBox
                ├── OTPInputField (6 digits)
                ├── SizedBox
                ├── TextButton (Resend code)
                ├── Spacer
                └── GradientButton (Verify)
```

**Key Components**:
- `OTPInputField`: Custom widget with 6 individual input boxes, auto-focus, auto-submit

**State Management**:
- Local state: OTP controllers (6), current focus index, resend timer
- Consumes `AuthProvider` for verification

**Animations**:
- Fade-in on load (500ms)
- Focus box scale animation (150ms)
- Success checkmark animation on verification (500ms)
- Countdown timer for resend button

**Validation**:
- Auto-submit when all 6 digits entered
- Numeric input only
- Clear on error

**Navigation**:
- Success → `/verified-success`
- Back button → `/signup` (with confirmation dialog)

**Special Behavior**:
- Auto-focus first input on mount
- Auto-advance to next input on digit entry
- Auto-backspace to previous input on delete
- Resend button disabled for 60 seconds after send

---

### 5. Verified Success Screen

**Purpose**: Confirmation of successful email verification

**Widget Tree**:
```
VerifiedSuccessScreen (StatelessWidget)
└── Scaffold
    └── SafeArea
        └── Padding
            └── Column
                ├── Spacer
                ├── AnimatedCheckmark (Success icon)
                ├── SizedBox
                ├── Text (Success message)
                ├── Text (Subtitle)
                ├── Spacer
                └── GradientButton (Continue)
```

**Key Components**:
- `AnimatedCheckmark`: Custom animated widget with scale + fade-in + checkmark draw animation

**State Management**:
- No state management required

**Animations**:
- Checkmark scale from 0 to 1 (300ms)
- Checkmark draw animation (500ms)
- Text fade-in (400ms, delayed 300ms)
- Button fade-in (400ms, delayed 600ms)

**Navigation**:
- Continue button → `/onboarding/profile-type`

---

### 6. Forgot Password Screen

**Purpose**: Initiate password reset flow

**Widget Tree**:
```
ForgotPasswordScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   └── BackButton
    └── SafeArea
        └── SingleChildScrollView
            └── Padding
                └── Form
                    └── Column
                        ├── Icon (Lock icon)
                        ├── SizedBox
                        ├── Text (Forgot password?)
                        ├── Text (Instructions)
                        ├── SizedBox
                        ├── CustomTextField (Email)
                        ├── SizedBox
                        ├── CheckboxListTile (Privacy policy)
                        ├── SizedBox
                        ├── GradientButton (Send reset code)
                        └── ErrorMessage (if error)
```

**State Management**:
- Local state: Form key, email controller, privacy checkbox
- Consumes `AuthProvider` for password reset request

**Animations**:
- Slide-in from right (300ms)
- Button scale on press (100ms)

**Validation**:
- Email: Format validation
- Privacy policy: Must be checked

**Navigation**:
- Success → `/verify-email` (with password reset context)
- Back button → `/login`

---

### 7. Create New Password Screen

**Purpose**: Set new password after OTP verification

**Widget Tree**:
```
CreateNewPasswordScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   └── BackButton
    └── SafeArea
        └── SingleChildScrollView
            └── Padding
                └── Form
                    └── Column
                        ├── Icon (Key icon)
                        ├── SizedBox
                        ├── Text (Create new password)
                        ├── Text (Instructions)
                        ├── SizedBox
                        ├── CustomTextField (New password)
                        ├── PasswordStrengthIndicator
                        ├── SizedBox
                        ├── CustomTextField (Confirm password)
                        ├── SizedBox
                        ├── GradientButton (Reset password)
                        └── ErrorMessage (if error)
```

**State Management**:
- Local state: Form key, password controllers, visibility toggles
- Consumes `AuthProvider` for password reset completion

**Animations**:
- Slide-in from right (300ms)
- Password strength bar animation (300ms)
- Success animation on completion (500ms)

**Validation**:
- New password: Min 8 chars, uppercase, lowercase, number, special char
- Confirm password: Must match new password

**Navigation**:
- Success → `/login` (with success message)
- Back button → `/forgot-password`

---

### 8. Profile Type Selection Screen

**Purpose**: Choose user profile type (Male, Female, Wali)

**Widget Tree**:
```
ProfileTypeSelectionScreen (StatelessWidget)
└── Scaffold
    └── SafeArea
        └── Padding
            └── Column
                ├── Text (Choose profile type)
                ├── Text (Subtitle)
                ├── SizedBox
                ├── Expanded
                │   └── Column
                │       ├── ProfileTypeCard (Male)
                │       ├── SizedBox
                │       ├── ProfileTypeCard (Female)
                │       ├── SizedBox
                │       └── ProfileTypeCard (Wali)
                └── SizedBox
```

**Key Components**:
- `ProfileTypeCard`: Card with icon, title, description, colored border on hover/selection

**State Management**:
- Consumes `OnboardingProvider` to save profile type

**Animations**:
- Cards fade-in with stagger (100ms delay each)
- Scale animation on hover (150ms)
- Border color transition on selection (200ms)

**Navigation**:
- Male/Female → `/onboarding/basic-info`
- Wali → `/onboarding/wali-info`

---

### 9. Wali Profile Info Screen

**Purpose**: Explain Wali profile purpose and responsibilities

**Widget Tree**:
```
WaliProfileInfoScreen (StatelessWidget)
└── Scaffold
    ├── AppBar
    │   └── BackButton
    └── SafeArea
        └── Padding
            └── Column
                ├── Expanded
                │   └── SingleChildScrollView
                │       └── Column
                │           ├── IllustrationWidget (Wali illustration)
                │           ├── SizedBox
                │           ├── Text (What is a Wali profile?)
                │           ├── SizedBox
                │           ├── Text (Explanation paragraph 1)
                │           ├── SizedBox
                │           ├── Text (Explanation paragraph 2)
                │           └── BulletPointList (Responsibilities)
                └── GradientButton (Continue)
```

**State Management**:
- No state management required

**Animations**:
- Fade-in on load (500ms)
- Button slide-up from bottom (400ms)

**Navigation**:
- Continue → `/onboarding/basic-info` (with Wali context)
- Back button → `/onboarding/profile-type`

---

### 10. Basic Information Screen (Step 1/5)

**Purpose**: Collect foundational user information

**Widget Tree**:
```
BasicInformationScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── BackButton
    │   └── StepProgressIndicator (1/5)
    └── SafeArea
        └── SingleChildScrollView
            └── Padding
                └── Form
                    └── Column
                        ├── Text (Basic Information)
                        ├── SizedBox
                        ├── CustomDropdown (How did you find us?)
                        ├── SizedBox
                        ├── CustomDropdown (Gender)
                        ├── SizedBox
                        ├── CustomTextField (First name)
                        ├── SizedBox
                        ├── CustomTextField (Last name)
                        ├── SizedBox
                        ├── CustomTextField (Email - pre-filled, disabled)
                        ├── SizedBox
                        ├── CustomTextField (Phone)
                        ├── SizedBox
                        ├── DatePickerField (Date of birth)
                        ├── SizedBox
                        ├── CustomDropdown (City)
                        ├── SizedBox
                        ├── CustomDropdown (Country)
                        ├── SizedBox
                        └── GradientButton (Next)
```

**Key Components**:
- `StepProgressIndicator`: Shows current step (1/5) with progress bar
- `CustomDropdown`: Styled dropdown with search capability
- `DatePickerField`: Date picker with calendar modal

**State Management**:
- Local state: Form key, controllers for all fields
- Consumes `OnboardingProvider` to save data and navigate

**Animations**:
- Slide-in from right (300ms)
- Progress bar fill animation (400ms)
- Field focus animations (200ms)

**Validation**:
- All fields required
- Phone: Format validation
- Date of birth: Must be 18+ years old
- Email: Pre-filled from registration, read-only

**Navigation**:
- Next → `/onboarding/personal-details`
- Back → `/onboarding/profile-type` (with data preservation)

---

### 11. Personal Details Screen (Step 2/5)

**Purpose**: Collect detailed personal and religious information

**Widget Tree**:
```
PersonalDetailsScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── BackButton
    │   └── StepProgressIndicator (2/5)
    └── SafeArea
        └── SingleChildScrollView
            └── Padding
                └── Form
                    └── Column
                        ├── Text (Personal Details)
                        ├── SizedBox
                        ├── CustomDropdown (Sect)
                        ├── SizedBox
                        ├── CustomDropdown (Marital status)
                        ├── SizedBox
                        ├── CustomDropdown (Ethnicity)
                        ├── SizedBox
                        ├── CustomDropdown (Nationality)
                        ├── SizedBox
                        ├── CustomTextField (Family details - multiline)
                        ├── SizedBox
                        ├── Row
                        │   ├── Expanded
                        │   │   └── CustomTextField (Height)
                        │   ├── SizedBox
                        │   └── Expanded
                        │       └── CustomTextField (Weight)
                        ├── SizedBox
                        ├── Text (Prayer habits)
                        ├── RadioGroup (Prayer habits options)
                        ├── SizedBox
                        ├── Text (Relocation preferences)
                        ├── CheckboxGroup (Relocation options)
                        ├── SizedBox
                        ├── Text (Wali information)
                        ├── CustomTextField (Wali name)
                        ├── SizedBox
                        ├── CustomTextField (Wali contact)
                        ├── SizedBox
                        └── GradientButton (Next)
```

**Key Components**:
- `RadioGroup`: Custom radio button group with styling
- `CheckboxGroup`: Multiple checkbox selection widget

**State Management**:
- Local state: Form key, controllers, radio/checkbox selections
- Consumes `OnboardingProvider` to save data

**Animations**:
- Slide-in from right (300ms)
- Progress bar update (400ms)

**Validation**:
- Most fields required
- Height/weight: Numeric validation with reasonable ranges
- Family details: Min 50 characters
- Wali info: Optional unless profile type is Female

**Navigation**:
- Next → `/onboarding/about-expectations`
- Back → `/onboarding/basic-info` (with data preservation)

---

### 12. About & Expectations Screen (Step 3/5)

**Purpose**: Collect long-form text about user and expectations

**Widget Tree**:
```
AboutExpectationsScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── BackButton
    │   └── StepProgressIndicator (3/5)
    └── SafeArea
        └── SingleChildScrollView
            └── Padding
                └── Form
                    └── Column
                        ├── Text (About & Expectations)
                        ├── SizedBox
                        ├── CustomTextField (Idea of marriage - multiline)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        ├── CustomTextField (Relationship with Islam)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        ├── CustomTextField (Role as spouse)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        ├── CustomTextField (About yourself)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        ├── CustomTextField (Spouse expectations)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        ├── CustomTextField (Marriage vision)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        ├── CustomTextField (Spouse's religious status)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        ├── CustomTextField (Relocation openness)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        ├── CustomTextField (Other preferences)
                        ├── CharacterCounter (50-1000)
                        ├── SizedBox
                        └── GradientButton (Next)
```

**Key Components**:
- `CharacterCounter`: Shows current/min/max character count with color coding

**State Management**:
- Local state: Form key, text controllers for all fields
- Consumes `OnboardingProvider` to save data

**Animations**:
- Slide-in from right (300ms)
- Progress bar update (400ms)
- Character counter color transition (200ms)

**Validation**:
- All fields: Min 50 characters, max 1000 characters
- Real-time character count display
- Button disabled until all fields meet requirements

**Navigation**:
- Next → `/onboarding/upload-photos`
- Back → `/onboarding/personal-details` (with data preservation)

---

### 13. Upload Photos Screen (Step 4/5)

**Purpose**: Upload profile photos with privacy controls

**Widget Tree**:
```
UploadPhotosScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── BackButton
    │   └── StepProgressIndicator (4/5)
    └── SafeArea
        └── Column
            ├── Expanded
            │   └── SingleChildScrollView
            │       └── Padding
            │           └── Column
            │               ├── Text (Upload Photos)
            │               ├── Text (Privacy notice)
            │               ├── SizedBox
            │               ├── GridView.builder (2 columns)
            │               │   └── PhotoUploadSlot (x6)
            │               └── OutlinedButton (Add more photos)
            ├── if (isUploading)
            │   └── LinearProgressIndicator
            └── Padding
                └── GradientButton (Next)
```

**Key Components**:
- `PhotoUploadSlot`: Square widget showing thumbnail or upload placeholder
  - Empty state: Dashed border with camera icon
  - Filled state: Image thumbnail with delete button overlay
  - Loading state: Progress indicator

**State Management**:
- Consumes `PhotoUploadProvider` for photo management
- Local state: Upload progress

**Animations**:
- Slide-in from right (300ms)
- Progress bar update (400ms)
- Photo thumbnail fade-in (300ms)
- Upload progress animation (smooth)
- Delete button scale on hover (150ms)

**Validation**:
- Minimum 1 photo required
- Maximum 6 photos allowed
- File size: Max 10MB per photo
- File format: JPEG, PNG, HEIC only

**Navigation**:
- Next → `/onboarding/preferences` (after upload completes)
- Back → `/onboarding/about-expectations` (with data preservation)

**Special Behavior**:
- Photos uploaded immediately on selection
- Can continue to next step while upload in progress
- Retry mechanism for failed uploads

---

### 14. Your Preferences Screen (Step 5/5)

**Purpose**: Configure match preferences

**Widget Tree**:
```
YourPreferencesScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── BackButton
    │   └── StepProgressIndicator (5/5)
    └── SafeArea
        └── SingleChildScrollView
            └── Padding
                └── Form
                    └── Column
                        ├── Text (Your Preferences)
                        ├── SizedBox
                        ├── Text (Age range)
                        ├── AgeRangeSlider
                        ├── Text (Display: 25 - 35 years)
                        ├── SizedBox
                        ├── Text (Marital status)
                        ├── CheckboxGroup (Single, Divorced, Widowed)
                        ├── SizedBox
                        ├── Text (Ethnicity)
                        ├── TagInputField (Searchable, multi-select)
                        ├── SizedBox
                        ├── Text (Country of residence)
                        ├── CustomDropdown (Country)
                        ├── SizedBox
                        └── GradientButton (Complete)
```

**Key Components**:
- `AgeRangeSlider`: Custom range slider with two thumbs
- `TagInputField`: Chip-based multi-select with search

**State Management**:
- Local state: Form key, age range, checkbox selections, tags
- Consumes `OnboardingProvider` to save data

**Animations**:
- Slide-in from right (300ms)
- Progress bar completion animation (400ms)
- Slider thumb animation (smooth)
- Tag add/remove animation (200ms)

**Validation**:
- Min age: Must be at least 18
- Max age: Must be greater than min age
- At least one marital status must be selected

**Navigation**:
- Complete → `/subscription-plans`
- Back → `/onboarding/upload-photos` (with data preservation)

---

### 15. Subscription Plans Screen

**Purpose**: Choose subscription tier

**Widget Tree**:
```
SubscriptionPlansScreen (StatelessWidget)
└── Scaffold
    ├── AppBar
    │   └── CloseButton
    └── SafeArea
        └── Column
            ├── Padding
            │   └── Column
            │       ├── Text (Choose your plan)
            │       └── Text (Subtitle)
            ├── Expanded
            │   └── ListView
            │       ├── SubscriptionPlanCard (Free)
            │       ├── SizedBox
            │       ├── SubscriptionPlanCard (Monthly £15) [Recommended]
            │       ├── SizedBox
            │       └── SubscriptionPlanCard (Annual £125)
            └── Padding
                └── TextButton (Skip for now)
```

**Key Components**:
- `SubscriptionPlanCard`: Card with plan name, price, features list, select button
  - Recommended badge for middle tier
  - Gradient border for selected plan

**State Management**:
- Consumes `SubscriptionProvider` for plan selection and payment
- Local state: Selected plan

**Animations**:
- Cards fade-in with stagger (100ms delay each)
- Scale animation on selection (200ms)
- Recommended badge pulse animation (continuous)

**Navigation**:
- Free plan → `/home` (complete onboarding)
- Paid plan → Payment flow → `/home` (on success)
- Skip → `/home` (defaults to free plan)

---

### 16. My Profile Screen

**Purpose**: View and edit profile with completion tracker

**Widget Tree**:
```
MyProfileScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── Title (My Profile)
    │   └── IconButton (Settings)
    └── SafeArea
        └── SingleChildScrollView
            └── Column
                ├── ProfileHeader
                │   ├── CircleAvatar (Profile photo)
                │   ├── Text (Name)
                │   └── Text (Age, Location)
                ├── SizedBox
                ├── ProfileCompletionCard
                │   ├── CircularProgressIndicator (85%)
                │   ├── Text (Profile completion)
                │   └── Text (Complete to increase visibility)
                ├── SizedBox
                ├── ProfileSectionCard (Basic Information)
                ├── ProfileSectionCard (Personal Details)
                ├── ProfileSectionCard (About & Expectations)
                ├── ProfileSectionCard (Photos)
                └── ProfileSectionCard (Preferences)
```

**Key Components**:
- `ProfileCompletionCard`: Shows completion percentage with circular progress
- `ProfileSectionCard`: Expandable card showing section data with edit button

**State Management**:
- Consumes `ProfileProvider` for profile data
- Local state: Expanded sections

**Animations**:
- Section expand/collapse (300ms)
- Progress indicator animation (smooth)

**Navigation**:
- Edit buttons → Respective onboarding screens (edit mode)
- Settings → Settings screen

---

### 17. Home/Browse Screen

**Purpose**: Browse potential matches with filters

**Widget Tree**:
```
HomeBrowseScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── Title (Discover)
    │   └── IconButton (Filter)
    ├── TabBar
    │   ├── Tab (All)
    │   ├── Tab (New)
    │   └── Tab (Nearby)
    └── TabBarView
        └── ListView.builder
            └── ProfileCard
                ├── BlurredPhotoStack
                ├── ProfileInfo
                │   ├── Text (Name, Age)
                │   ├── Text (Location)
                │   └── Text (Bio preview)
                └── ActionButtons
                    ├── IconButton (Pass)
                    ├── GradientButton (View Profile)
                    └── IconButton (Like)
```

**Key Components**:
- `ProfileCard`: Card with blurred photo, info, and action buttons
- `BlurredPhotoStack`: Stack of photos with blur effect (privacy)

**State Management**:
- Consumes `MatchProvider` for profile data
- Local state: Current tab, filters

**Animations**:
- Card swipe animation (300ms)
- Tab transition (200ms)
- Button scale on press (100ms)

**Navigation**:
- View Profile → Profile detail screen
- Bottom nav → Other main screens

---

### 18. Requests Screen

**Purpose**: Manage connection requests and matches

**Widget Tree**:
```
RequestsScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   └── Title (Requests)
    ├── TabBar
    │   ├── Tab (Received)
    │   ├── Tab (Sent)
    │   └── Tab (Matches)
    └── TabBarView
        ├── ReceivedTab
        │   └── ListView.builder
        │       └── RequestCard
        │           ├── ProfilePhoto
        │           ├── ProfileInfo
        │           └── Row
        │               ├── OutlinedButton (Decline)
        │               └── GradientButton (Accept)
        ├── SentTab
        │   └── ListView.builder
        │       └── RequestCard (with pending status)
        └── MatchesTab
            └── ListView.builder
                └── MatchCard (with chat button)
```

**Key Components**:
- `RequestCard`: Card showing profile with action buttons
- `MatchCard`: Card for confirmed matches with chat access

**State Management**:
- Consumes `RequestProvider` for request data
- Local state: Current tab

**Animations**:
- Tab transition (200ms)
- Card slide-out on action (300ms)
- Badge pulse for new requests (continuous)

**Navigation**:
- Profile tap → Profile detail screen
- Chat button → Chat screen
- Bottom nav → Other main screens


## Reusable Component Library

### 1. GradientButton

**Purpose**: Primary action button with gradient background

**Implementation**:
```dart
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  
  const GradientButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return ScaleTapAnimation(
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius26),
          boxShadow: [AppDimensions.defaultShadow],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius26),
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      text,
                      style: AppTypography.button,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
```

**Usage**:
```dart
GradientButton(
  text: 'Continue',
  onPressed: () => _handleSubmit(),
  isLoading: _isLoading,
)
```

---

### 2. CustomTextField

**Purpose**: Reusable text input with validation and styling

**Implementation**:
```dart
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  
  const CustomTextField({
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
    this.onChanged,
  });
  
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  String? _errorText;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.label,
        ),
        SizedBox(height: 8),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
            border: Border.all(
              color: _errorText != null
                  ? AppColors.error
                  : _isFocused
                      ? AppColors.primary
                      : AppColors.gray300,
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            onTap: widget.onTap,
            onChanged: (value) {
              if (widget.validator != null) {
                setState(() {
                  _errorText = widget.validator!(value);
                });
              }
              widget.onChanged?.call(value);
            },
            onFocusChange: (focused) {
              setState(() {
                _isFocused = focused;
              });
            },
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              counterText: '',
            ),
            validator: widget.validator,
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _errorText!,
              style: AppTypography.error,
            ),
          ),
      ],
    );
  }
}
```

---

### 3. StepProgressIndicator

**Purpose**: Visual progress indicator for multi-step forms

**Implementation**:
```dart
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  
  const StepProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: AppTypography.caption,
            ),
          ],
        ),
        SizedBox(height: 8),
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: AppColors.gray200,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
```

---

### 4. OTPInputField

**Purpose**: 6-digit OTP input with auto-focus and auto-submit

**Implementation**:
```dart
class OTPInputField extends StatefulWidget {
  final Function(String) onCompleted;
  final int length;
  
  const OTPInputField({
    required this.onCompleted,
    this.length = 6,
  });
  
  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  
  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
    );
    
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  
  void _onChanged(int index, String value) {
    if (value.length == 1) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All fields filled, submit
        _focusNodes[index].unfocus();
        final otp = _controllers.map((c) => c.text).join();
        widget.onCompleted(otp);
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      _focusNodes[index - 1].requestFocus();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: 48,
          height: 56,
          child: AnimatedScale(
            scale: _focusNodes[index].hasFocus ? 1.1 : 1.0,
            duration: Duration(milliseconds: 150),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              onChanged: (value) => _onChanged(index, value),
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              style: AppTypography.heading3,
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 5. SocialAuthButton

**Purpose**: Styled button for social authentication providers

**Implementation**:
```dart
class SocialAuthButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;
  final bool isOutlined;
  
  const SocialAuthButton({
    required this.text,
    required this.iconPath,
    required this.onPressed,
    this.isOutlined = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return ScaleTapAnimation(
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.white : AppColors.gray100,
          border: isOutlined
              ? Border.all(color: AppColors.gray300)
              : null,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius26),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 12),
                Text(
                  text,
                  style: AppTypography.button.copyWith(
                    color: AppColors.typography,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 6. ProfileTypeCard

**Purpose**: Selectable card for profile type selection

**Implementation**:
```dart
class ProfileTypeCard extends StatefulWidget {
  final String title;
  final String description;
  final String iconPath;
  final Color borderColor;
  final VoidCallback onTap;
  
  const ProfileTypeCard({
    required this.title,
    required this.description,
    required this.iconPath,
    required this.borderColor,
    required this.onTap,
  });
  
  @override
  State<ProfileTypeCard> createState() => _ProfileTypeCardState();
}

class _ProfileTypeCardState extends State<ProfileTypeCard> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: Duration(milliseconds: 150),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius16),
              border: Border.all(
                color: _isHovered ? widget.borderColor : AppColors.gray300,
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: _isHovered
                  ? [AppDimensions.defaultShadow]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.borderColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.iconPath,
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.heading3,
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: AppTypography.body2.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.gray400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 7. PhotoUploadSlot

**Purpose**: Individual photo upload slot with preview

**Implementation**:
```dart
class PhotoUploadSlot extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool isUploading;
  final double? uploadProgress;
  
  const PhotoUploadSlot({
    this.image,
    required this.onTap,
    this.onDelete,
    this.isUploading = false,
    this.uploadProgress,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius16),
          border: Border.all(
            color: AppColors.gray300,
            style: image == null ? BorderStyle.dashed : BorderStyle.solid,
          ),
        ),
        child: Stack(
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius16),
                child: Image.file(
                  image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 32,
                      color: AppColors.gray400,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add Photo',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            if (isUploading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(
                    value: uploadProgress,
                    color: Colors.white,
                  ),
                ),
              ),
            if (image != null && !isUploading && onDelete != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

### 8. AgeRangeSlider

**Purpose**: Dual-thumb slider for age range selection

**Implementation**:
```dart
class AgeRangeSlider extends StatefulWidget {
  final int minAge;
  final int maxAge;
  final Function(int, int) onChanged;
  
  const AgeRangeSlider({
    required this.minAge,
    required this.maxAge,
    required this.onChanged,
  });
  
  @override
  State<AgeRangeSlider> createState() => _AgeRangeSliderState();
}

class _AgeRangeSliderState extends State<AgeRangeSlider> {
  late RangeValues _currentRange;
  
  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(
      widget.minAge.toDouble(),
      widget.maxAge.toDouble(),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RangeSlider(
          values: _currentRange,
          min: 18,
          max: 80,
          divisions: 62,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.gray300,
          onChanged: (RangeValues values) {
            setState(() {
              _currentRange = values;
            });
            widget.onChanged(
              values.start.round(),
              values.end.round(),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_currentRange.start.round()} years',
              style: AppTypography.body2,
            ),
            Text(
              '${_currentRange.end.round()} years',
              style: AppTypography.body2,
            ),
          ],
        ),
      ],
    );
  }
}
```

---

### 9. AnimatedCheckmark

**Purpose**: Success checkmark animation

**Implementation**:
```dart
class AnimatedCheckmark extends StatefulWidget {
  final double size;
  final Color color;
  
  const AnimatedCheckmark({
    this.size = 100,
    this.color = Colors.green,
  });
  
  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );
    
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: CheckmarkPainter(
                progress: _checkAnimation.value,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  CheckmarkPainter({required this.progress, required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    final checkStart = Offset(size.width * 0.25, size.height * 0.5);
    final checkMiddle = Offset(size.width * 0.45, size.height * 0.7);
    final checkEnd = Offset(size.width * 0.75, size.height * 0.3);
    
    if (progress < 0.5) {
      final currentProgress = progress * 2;
      path.moveTo(checkStart.dx, checkStart.dy);
      path.lineTo(
        checkStart.dx + (checkMiddle.dx - checkStart.dx) * currentProgress,
        checkStart.dy + (checkMiddle.dy - checkStart.dy) * currentProgress,
      );
    } else {
      final currentProgress = (progress - 0.5) * 2;
      path.moveTo(checkStart.dx, checkStart.dy);
      path.lineTo(checkMiddle.dx, checkMiddle.dy);
      path.lineTo(
        checkMiddle.dx + (checkEnd.dx - checkMiddle.dx) * currentProgress,
        checkMiddle.dy + (checkEnd.dy - checkMiddle.dy) * currentProgress,
      );
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

---

### 10. ScaleTapAnimation

**Purpose**: Wrapper for scale-down animation on tap

**Implementation**:
```dart
class ScaleTapAnimation extends StatefulWidget {
  final Widget child;
  final double scale;
  
  const ScaleTapAnimation({
    required this.child,
    this.scale = 0.95,
  });
  
  @override
  State<ScaleTapAnimation> createState() => _ScaleTapAnimationState();
}

class _ScaleTapAnimationState extends State<ScaleTapAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
```


## Theme Configuration

### AppColors

```dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFD48B91);
  static const Color secondary = Color(0xFF7685C2);
  
  // Typography
  static const Color typography = Color(0xFF1A1A1A);
  
  // Backgrounds
  static const Color background1 = Color(0xFFF7F8FC);
  static const Color background2 = Color(0xFFF9FAFB);
  static const Color backgroundWhite = Colors.white;
  
  // Gray Shades
  static const Color gray900 = Color(0xFF323232);
  static const Color gray600 = Color(0xFF6B7280);
  static const Color gray400 = Color(0xFFD1D5DB);
  static const Color gray300 = Color(0xFFE5E7EB);
  static const Color gray200 = Color(0xFFF3F4F6);
  static const Color gray100 = Color(0xFFF9FAFB);
  
  // Accent Colors
  static const Color accentLightPink = Color(0xFFECCBCE);
  static const Color accentLightBlue = Color(0xFFACB5DA);
  static const Color accentDarkPink = Color(0xFFD07C84);
  
  // Semantic Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
```

### AppTypography

```dart
class AppTypography {
  // Font Families
  static const String poppins = 'Poppins';
  static const String inter = 'Inter';
  
  // Headings (Poppins)
  static const TextStyle heading1 = TextStyle(
    fontFamily: poppins,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.typography,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: poppins,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.typography,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: poppins,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.typography,
  );
  
  // Body Text (Inter)
  static const TextStyle body1 = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: AppColors.typography,
  );
  
  static const TextStyle body2 = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: AppColors.typography,
  );
  
  // Button Text (Poppins)
  static const TextStyle button = TextStyle(
    fontFamily: poppins,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.05,
    color: Colors.white,
  );
  
  // Caption (Inter)
  static const TextStyle caption = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: AppColors.gray600,
  );
  
  // Label (Inter)
  static const TextStyle label = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.50,
    color: AppColors.typography,
  );
  
  // Error Text (Inter)
  static const TextStyle error = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: AppColors.error,
  );
}
```

### AppDimensions

```dart
class AppDimensions {
  // Border Radius
  static const double borderRadius4 = 4.0;
  static const double borderRadius8 = 8.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius26 = 26.0;
  static const double borderRadius32 = 32.0;
  static const double borderRadius43 = 43.0;
  static const double borderRadius48 = 48.0;
  static const double borderRadiusCircular = 9999.0;
  
  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  
  // Shadows
  static const BoxShadow defaultShadow = BoxShadow(
    color: Color(0x28000000),
    blurRadius: 6,
    offset: Offset(0, 3),
  );
  
  // Touch Targets
  static const double minTouchTarget = 44.0;
}
```

### AppTheme

```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        background: AppColors.background1,
        surface: AppColors.backgroundWhite,
      ),
      scaffoldBackgroundColor: AppColors.background1,
      fontFamily: AppTypography.inter,
      textTheme: TextTheme(
        displayLarge: AppTypography.heading1,
        displayMedium: AppTypography.heading2,
        displaySmall: AppTypography.heading3,
        bodyLarge: AppTypography.body1,
        bodyMedium: AppTypography.body2,
        labelLarge: AppTypography.button,
        bodySmall: AppTypography.caption,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.typography),
        titleTextStyle: AppTypography.heading3,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius26),
          ),
          textStyle: AppTypography.button,
        ),
      ),
    );
  }
}
```

## Animation Specifications

### 1. Page Transitions

**Slide Transition**:
- Duration: 300ms
- Curve: Curves.easeInOut
- Direction: Right to left for forward, left to right for back
- Implementation:
```dart
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  
  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 300),
        );
}
```

**Fade Transition**:
- Duration: 500ms
- Curve: Curves.easeIn
- Used for: Success screens, modal overlays
- Implementation:
```dart
class FadePageRoute extends PageRouteBuilder {
  final Widget page;
  
  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        );
}
```

### 2. Button Animations

**Press Animation**:
- Scale: 0.95
- Duration: 100ms
- Curve: Curves.easeInOut
- Applied to: All buttons via ScaleTapAnimation wrapper

**Loading State**:
- Circular progress indicator
- Color: White (on gradient buttons)
- Size: 24x24
- Smooth transition from text to loader (200ms fade)

### 3. Form Field Animations

**Focus Animation**:
- Border color transition: 200ms
- Border width: 1px → 2px
- Curve: Curves.easeInOut

**Error Shake**:
- Duration: 400ms
- Amplitude: 10px
- Frequency: 3 shakes
- Implementation:
```dart
class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;
  
  const ShakeAnimation({
    required this.child,
    required this.trigger,
  });
  
  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }
  
  @override
  void didUpdateWidget(ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward(from: 0);
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final offset = sin(_animation.value * pi * 3) * 10;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: widget.child,
        );
      },
    );
  }
}
```

### 4. Progress Indicator Animations

**Linear Progress Bar**:
- Duration: 400ms
- Curve: Curves.easeInOut
- Smooth fill animation on step change

**Circular Progress**:
- Rotation: Continuous
- Color: Primary or white (context-dependent)
- Size: 24x24 (small), 48x48 (large)

### 5. Success Animations

**Checkmark Animation**:
- Scale: 0 → 1 (300ms, Curves.elasticOut)
- Draw: 500ms, Curves.easeInOut
- Total duration: 800ms
- Accompanied by text fade-in (400ms delay)

### 6. List Animations

**Staggered Fade-In**:
- Delay between items: 100ms
- Fade duration: 300ms
- Slide distance: 20px from bottom
- Implementation:
```dart
class StaggeredListView extends StatelessWidget {
  final List<Widget> children;
  final Duration delay;
  
  const StaggeredListView({
    required this.children,
    this.delay = const Duration(milliseconds: 100),
  });
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: AlwaysStoppedAnimation(index),
          builder: (context, child) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: children[index],
            );
          },
        );
      },
    );
  }
}
```

### 7. Micro-Interactions

**Hover Effects** (Web/Desktop):
- Scale: 1.02
- Duration: 150ms
- Curve: Curves.easeInOut
- Applied to: Cards, buttons

**Ripple Effect**:
- Material InkWell default
- Color: Primary color at 20% opacity
- Duration: 300ms

## API Integration Points

### Authentication Endpoints

```dart
class AuthEndpoints {
  static const String baseUrl = 'https://api.matrimony.app/v1';
  
  // Email/Password Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // Email Verification
  static const String sendVerificationOTP = '/auth/verify/send';
  static const String verifyOTP = '/auth/verify/confirm';
  
  // Password Reset
  static const String sendPasswordResetOTP = '/auth/password/reset/send';
  static const String verifyPasswordResetOTP = '/auth/password/reset/verify';
  static const String resetPassword = '/auth/password/reset/confirm';
  
  // Social Auth
  static const String googleAuth = '/auth/social/google';
  static const String appleAuth = '/auth/social/apple';
  
  // User Info
  static const String getCurrentUser = '/auth/me';
}
```

### Onboarding Endpoints

```dart
class OnboardingEndpoints {
  static const String baseUrl = 'https://api.matrimony.app/v1';
  
  // Profile Setup
  static const String saveBasicInfo = '/onboarding/basic-info';
  static const String savePersonalDetails = '/onboarding/personal-details';
  static const String saveAboutExpectations = '/onboarding/about-expectations';
  static const String savePreferences = '/onboarding/preferences';
  static const String completeOnboarding = '/onboarding/complete';
  
  // Photo Management
  static const String uploadPhoto = '/onboarding/photos/upload';
  static const String deletePhoto = '/onboarding/photos/{photoId}';
  static const String reorderPhotos = '/onboarding/photos/reorder';
  
  // Progress
  static const String getProgress = '/onboarding/progress';
}
```

### Subscription Endpoints

```dart
class SubscriptionEndpoints {
  static const String baseUrl = 'https://api.matrimony.app/v1';
  
  // Plans
  static const String getPlans = '/subscriptions/plans';
  static const String subscribe = '/subscriptions/subscribe';
  static const String cancelSubscription = '/subscriptions/cancel';
  static const String getActiveSubscription = '/subscriptions/active';
  
  // Payment
  static const String createPaymentIntent = '/payments/intent';
  static const String confirmPayment = '/payments/confirm';
}
```

### API Client Configuration

```dart
class ApiClient {
  final Dio _dio;
  final AuthRepository _authRepository;
  
  ApiClient({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.matrimony.app/v1',
            connectTimeout: Duration(seconds: 30),
            receiveTimeout: Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(AuthInterceptor(_authRepository));
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(RetryInterceptor());
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String path, {dynamic data});
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path);
  Future<Response> uploadFile(String path, File file, {Map<String, dynamic>? data});
}
```

### Request/Response Models

**Register Request**:
```dart
class RegisterRequest {
  final String email;
  final String fullName;
  final String password;
  
  RegisterRequest({
    required this.email,
    required this.fullName,
    required this.password,
  });
  
  Map<String, dynamic> toJson() => {
    'email': email,
    'full_name': fullName,
    'password': password,
  };
}
```

**Login Request**:
```dart
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;
  
  LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
  
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'remember_me': rememberMe,
  };
}
```

**Auth Response**:
```dart
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  
  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    accessToken: json['access_token'],
    refreshToken: json['refresh_token'],
    user: UserModel.fromJson(json['user']),
  );
}
```

## Error Handling Patterns

### Error Types

```dart
abstract class Failure {
  final String message;
  final String? code;
  
  const Failure(this.message, [this.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred'])
      : super(message, 'NETWORK_ERROR');
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
      : super(message, 'SERVER_ERROR');
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;
  
  const ValidationFailure(this.errors)
      : super('Validation failed', 'VALIDATION_ERROR');
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication failed'])
      : super(message, 'AUTH_ERROR');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'Unauthorized access'])
      : super(message, 'UNAUTHORIZED');
}
```

### Error Handler

```dart
class ErrorHandler {
  static String getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Please check your internet connection and try again.';
    } else if (failure is ServerFailure) {
      return 'Something went wrong on our end. Please try again later.';
    } else if (failure is ValidationFailure) {
      return failure.errors.values.first.first;
    } else if (failure is AuthenticationFailure) {
      return 'Invalid email or password. Please try again.';
    } else if (failure is UnauthorizedFailure) {
      return 'Your session has expired. Please log in again.';
    }
    return failure.message;
  }
  
  static void showError(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getErrorMessage(failure)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
```

### Retry Interceptor

```dart
class RetryInterceptor extends Interceptor {
  final int maxRetries = 3;
  final Duration retryDelay = Duration(seconds: 1);
  
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
      
      if (retryCount < maxRetries) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        
        await Future.delayed(
          retryDelay * pow(2, retryCount),
        );
        
        try {
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return super.onError(err, handler);
        }
      }
    }
    
    return super.onError(err, handler);
  }
  
  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}
```

## State Management Patterns

### Provider Setup

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Repositories
        Provider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
            localDataSource: AuthLocalDataSourceImpl(),
          ),
        ),
        Provider<OnboardingRepository>(
          create: (_) => OnboardingRepositoryImpl(
            remoteDataSource: OnboardingRemoteDataSourceImpl(),
            localDataSource: OnboardingLocalDataSourceImpl(),
          ),
        ),
        
        // Providers
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider<OnboardingProvider>(
          create: (context) => OnboardingProvider(
            repository: context.read<OnboardingRepository>(),
          ),
        ),
        ChangeNotifierProvider<FormValidationProvider>(
          create: (_) => FormValidationProvider(),
        ),
        ChangeNotifierProvider<PhotoUploadProvider>(
          create: (_) => PhotoUploadProvider(
            datasource: PhotoDatasourceImpl(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

### State Classes

```dart
// Auth State
class AuthState {
  final bool isLoading;
  final User? user;
  final Failure? error;
  
  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });
  
  factory AuthState.initial() => const AuthState();
  
  factory AuthState.loading() => const AuthState(isLoading: true);
  
  factory AuthState.authenticated(User user) => AuthState(user: user);
  
  factory AuthState.error(Failure error) => AuthState(error: error);
  
  AuthState copyWith({
    bool? isLoading,
    User? user,
    Failure? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}
```

### Data Persistence

```dart
class LocalStorageService {
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _onboardingDataKey = 'onboarding_data';
  static const String _userDataKey = 'user_data';
  
  final SharedPreferences _prefs;
  final Box _secureBox;
  
  LocalStorageService({
    required SharedPreferences prefs,
    required Box secureBox,
  })  : _prefs = prefs,
        _secureBox = secureBox;
  
  // Auth Tokens
  Future<void> saveAuthToken(String token) async {
    await _secureBox.put(_authTokenKey, token);
  }
  
  String? getAuthToken() {
    return _secureBox.get(_authTokenKey);
  }
  
  Future<void> saveRefreshToken(String token) async {
    await _secureBox.put(_refreshTokenKey, token);
  }
  
  String? getRefreshToken() {
    return _secureBox.get(_refreshTokenKey);
  }
  
  Future<void> clearAuthTokens() async {
    await _secureBox.delete(_authTokenKey);
    await _secureBox.delete(_refreshTokenKey);
  }
  
  // Onboarding Data
  Future<void> saveOnboardingData(OnboardingData data) async {
    await _prefs.setString(_onboardingDataKey, jsonEncode(data.toJson()));
  }
  
  OnboardingData? getOnboardingData() {
    final jsonString = _prefs.getString(_onboardingDataKey);
    if (jsonString == null) return null;
    return OnboardingData.fromJson(jsonDecode(jsonString));
  }
  
  Future<void> clearOnboardingData() async {
    await _prefs.remove(_onboardingDataKey);
  }
  
  // User Data
  Future<void> saveUserData(UserModel user) async {
    await _prefs.setString(_userDataKey, jsonEncode(user.toJson()));
  }
  
  UserModel? getUserData() {
    final jsonString = _prefs.getString(_userDataKey);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }
  
  Future<void> clearAllData() async {
    await _prefs.clear();
    await _secureBox.clear();
  }
}
```


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

This feature includes significant business logic for form validation, data persistence, and input sanitization that is well-suited for property-based testing. While much of the feature involves UI rendering and external service integration (which are better tested with integration tests), the core validation and data transformation logic can be verified through universal properties.

### Property Reflection

After analyzing all acceptance criteria, the following properties were identified as testable through property-based testing:

**Validation Properties** (Requirements 2.2, 2.5, 3.2, 3.4, 3.5, 3.6, 11.2, 11.3, 13.3, 13.4, 14.3, 14.4, 15.2, 15.3):
- Email format validation
- Password length validation
- Password complexity validation
- Password matching validation
- Phone number format validation
- Age validation (18+)
- Text length validation (min/max)
- File format validation
- File size validation
- Age range validation

**Data Persistence Properties** (Requirements 23.1, 23.2, 23.9):
- Serialization round-trip preservation
- State restoration preservation
- Data integrity validation

**Redundancy Analysis**:
- Properties 2.2 and 3.2 are identical (email format validation) → Combine into Property 1
- Properties 2.5 and 3.4 are identical (password length validation) → Combine into Property 2
- Properties 13.3 and 13.4 test min/max length on same data → Combine into Property 7
- Properties 23.1 and 23.2 both test data preservation → Combine into Property 10

After eliminating redundancy, we have 11 unique correctness properties.

---

### Property 1: Email Format Validation

*For any* string input, the email validator SHALL return true if and only if the string matches the standard email format (local-part@domain with valid characters and structure).

**Validates: Requirements 2.2, 3.2**

**Test Strategy**: Generate random strings including valid emails (various formats), invalid emails (missing @, invalid characters, malformed domains), and edge cases (empty, very long, special characters). Verify validation returns correct boolean.

---

### Property 2: Password Length Validation

*For any* string input, the password length validator SHALL return true if and only if the string contains at least 8 characters.

**Validates: Requirements 2.5, 3.4**

**Test Strategy**: Generate random strings with lengths from 0 to 100 characters. Verify validation returns true for length >= 8 and false for length < 8.

---

### Property 3: Password Complexity Validation

*For any* string input, the password complexity validator SHALL return true if and only if the string contains at least one uppercase letter, one lowercase letter, one numeric digit, and one special character.

**Validates: Requirements 3.5**

**Test Strategy**: Generate random strings with various character compositions (all lowercase, all uppercase, no numbers, no special chars, valid combinations). Verify validation correctly identifies passwords meeting all four requirements.

---

### Property 4: Password Matching Validation

*For any* pair of string inputs (password, confirmPassword), the password matching validator SHALL return true if and only if both strings are identical.

**Validates: Requirements 3.6**

**Test Strategy**: Generate random password pairs including matching pairs, non-matching pairs, empty strings, and strings differing by case or whitespace. Verify validation returns true only for exact matches.

---

### Property 5: Phone Number Format Validation

*For any* string input, the phone number validator SHALL return true if and only if the string matches a valid international phone number format (with or without country code, allowing common separators).

**Validates: Requirements 11.2**

**Test Strategy**: Generate random strings including valid phone numbers (various formats with +, -, spaces, parentheses), invalid phone numbers (letters, too short, too long), and edge cases. Verify validation returns correct boolean.

---

### Property 6: Age Validation (18+ Requirement)

*For any* date of birth input, the age validator SHALL return true if and only if the date represents an age of 18 years or older from the current date.

**Validates: Requirements 11.3**

**Test Strategy**: Generate random dates including dates 18+ years ago, dates less than 18 years ago, future dates, and boundary dates (exactly 18 years ago). Verify validation returns true only for ages >= 18.

---

### Property 7: Text Length Validation

*For any* string input and specified minimum and maximum lengths, the text length validator SHALL return true if and only if the string length is greater than or equal to the minimum and less than or equal to the maximum.

**Validates: Requirements 13.3, 13.4**

**Test Strategy**: Generate random strings with lengths from 0 to 2000 characters. For min=50, max=1000, verify validation returns true for 50 <= length <= 1000 and false otherwise.

---

### Property 8: File Format Validation

*For any* file input, the file format validator SHALL return true if and only if the file extension is one of the allowed image formats (JPEG, JPG, PNG, HEIC) and the MIME type matches the extension.

**Validates: Requirements 14.3**

**Test Strategy**: Generate file objects with various extensions (.jpg, .png, .heic, .pdf, .txt, .gif) and MIME types. Verify validation returns true only for allowed image formats with matching MIME types.

---

### Property 9: File Size Validation

*For any* file input, the file size validator SHALL return true if and only if the file size in bytes does not exceed 10,485,760 bytes (10MB).

**Validates: Requirements 14.4**

**Test Strategy**: Generate file objects with various sizes from 0 bytes to 20MB. Verify validation returns true for size <= 10MB and false for size > 10MB.

---

### Property 10: Age Range Validation

*For any* pair of integer inputs (minAge, maxAge), the age range validator SHALL return true if and only if minAge is at least 18 and maxAge is strictly greater than minAge.

**Validates: Requirements 15.2, 15.3**

**Test Strategy**: Generate random age pairs including valid ranges (18-80), invalid ranges (minAge < 18, maxAge <= minAge), boundary cases (minAge = 18, maxAge = minAge + 1), and extreme values. Verify validation returns correct boolean.

---

### Property 11: Data Serialization Round-Trip Preservation

*For any* valid OnboardingData object, serializing the object to JSON and then deserializing it back SHALL produce an object that is equal to the original object.

**Validates: Requirements 23.1, 23.2**

**Test Strategy**: Generate random OnboardingData objects with various field combinations (all fields populated, some fields null, empty collections, special characters in strings). Serialize to JSON, deserialize back, verify equality using deep comparison.

---

### Property 12: Data Integrity Validation

*For any* JSON string input, the data integrity validator SHALL return true if and only if the JSON is well-formed, contains all required fields for the OnboardingData model, and all field values are of the correct type.

**Validates: Requirements 23.9**

**Test Strategy**: Generate valid and corrupted JSON strings (missing fields, wrong types, malformed JSON, extra fields, null values where not allowed). Verify validation correctly identifies valid vs. corrupted data.

---

### Testing Strategy Notes

**Property-Based Testing Configuration**:
- Library: Use `test` package with custom property-based testing utilities or `dart_check` package
- Iterations: Minimum 100 iterations per property test
- Shrinking: Enable automatic shrinking to find minimal failing cases
- Seed: Use random seed with logging for reproducibility

**Test Organization**:
```dart
// test/unit/validators_test.dart
group('Validators - Property-Based Tests', () {
  test('Property 1: Email format validation', () {
    // Feature: authentication-onboarding-flow, Property 1: Email format validation
    forAll(
      stringGenerator(),
      (input) {
        final result = Validators.validateEmail(input);
        final isValidFormat = _isValidEmailFormat(input);
        expect(result == null, equals(isValidFormat));
      },
      iterations: 100,
    );
  });
  
  test('Property 2: Password length validation', () {
    // Feature: authentication-onboarding-flow, Property 2: Password length validation
    forAll(
      stringGenerator(),
      (input) {
        final result = Validators.validatePassword(input);
        final meetsLength = input.length >= 8;
        if (!meetsLength) {
          expect(result, isNotNull);
          expect(result, contains('8 characters'));
        }
      },
      iterations: 100,
    );
  });
  
  // ... additional property tests
});
```

**Complementary Testing**:
- **Unit Tests**: Specific examples for each validation rule, edge cases, error messages
- **Integration Tests**: UI rendering, navigation flows, external service integration
- **Widget Tests**: Screen layouts, user interactions, animation behavior
- **End-to-End Tests**: Complete user journeys from registration to onboarding completion


## Error Handling

### Error Handling Strategy

The application implements a comprehensive error handling strategy with multiple layers:

1. **Validation Layer**: Prevent invalid data from entering the system
2. **Network Layer**: Handle connectivity and API errors gracefully
3. **Business Logic Layer**: Catch and transform domain-specific errors
4. **Presentation Layer**: Display user-friendly error messages

### Error Display Patterns

#### 1. Inline Field Errors

**When**: Real-time validation errors during form input
**Display**: Red text below the field with specific error message
**Behavior**: 
- Appears immediately on blur or after typing stops (300ms debounce)
- Clears when user corrects the input
- Prevents form submission while errors exist

**Example**:
```dart
CustomTextField(
  label: 'Email',
  validator: Validators.validateEmail,
  errorText: _emailError,
  onChanged: (value) {
    setState(() {
      _emailError = Validators.validateEmail(value);
    });
  },
)
```

#### 2. Form-Level Errors

**When**: Submission fails due to multiple field errors or business logic errors
**Display**: Error banner at top of form with summary
**Behavior**:
- Scrolls to first error field
- Highlights all fields with errors
- Provides actionable guidance

**Example**:
```dart
if (_formErrors.isNotEmpty) {
  ErrorBanner(
    message: 'Please correct the following errors:',
    errors: _formErrors,
    onDismiss: () => setState(() => _formErrors.clear()),
  )
}
```

#### 3. Network Errors

**When**: API calls fail due to connectivity or server issues
**Display**: SnackBar at bottom of screen
**Behavior**:
- Auto-dismisses after 5 seconds
- Includes retry button for transient errors
- Queues operations for offline mode

**Example**:
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Connection lost. Retrying...'),
    action: SnackBarAction(
      label: 'Retry Now',
      onPressed: () => _retryOperation(),
    ),
    duration: Duration(seconds: 5),
  ),
);
```

#### 4. Critical Errors

**When**: Unrecoverable errors (auth token expired, account suspended)
**Display**: Full-screen dialog with explanation
**Behavior**:
- Blocks further interaction
- Provides clear next steps
- Logs user out if necessary

**Example**:
```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    title: Text('Session Expired'),
    content: Text('Your session has expired. Please log in again.'),
    actions: [
      TextButton(
        onPressed: () => _navigateToLogin(),
        child: Text('Log In'),
      ),
    ],
  ),
);
```

### Error Recovery Mechanisms

#### 1. Automatic Retry

**Applicable to**: Network timeouts, 5xx server errors
**Strategy**: Exponential backoff with max 3 retries
**Implementation**:
```dart
Future<T> _retryOperation<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
  Duration initialDelay = const Duration(seconds: 1),
}) async {
  int retryCount = 0;
  
  while (true) {
    try {
      return await operation();
    } catch (e) {
      if (retryCount >= maxRetries || !_isRetryable(e)) {
        rethrow;
      }
      
      retryCount++;
      final delay = initialDelay * pow(2, retryCount - 1);
      await Future.delayed(delay);
    }
  }
}
```

#### 2. Offline Queue

**Applicable to**: Form submissions, photo uploads
**Strategy**: Queue operations when offline, sync when online
**Implementation**:
```dart
class OfflineQueue {
  final List<QueuedOperation> _queue = [];
  
  Future<void> enqueue(QueuedOperation operation) async {
    _queue.add(operation);
    await _persistQueue();
    
    if (await _isOnline()) {
      await _processQueue();
    }
  }
  
  Future<void> _processQueue() async {
    while (_queue.isNotEmpty && await _isOnline()) {
      final operation = _queue.first;
      
      try {
        await operation.execute();
        _queue.removeAt(0);
        await _persistQueue();
      } catch (e) {
        if (_isPermanentError(e)) {
          _queue.removeAt(0);
          await _persistQueue();
        } else {
          break; // Stop processing on transient error
        }
      }
    }
  }
}
```

#### 3. State Rollback

**Applicable to**: Failed state updates
**Strategy**: Maintain previous state, rollback on error
**Implementation**:
```dart
class OnboardingProvider extends ChangeNotifier {
  OnboardingData _data = OnboardingData.empty();
  OnboardingData? _previousData;
  
  Future<void> saveBasicInformation(BasicInformationData data) async {
    _previousData = _data.copyWith();
    _data = _data.copyWith(basicInfo: data);
    notifyListeners();
    
    try {
      await _repository.saveBasicInformation(data);
    } catch (e) {
      // Rollback on error
      _data = _previousData!;
      _previousData = null;
      notifyListeners();
      rethrow;
    }
  }
}
```

### Error Logging

**Strategy**: Log all errors for debugging while protecting user privacy

**Implementation**:
```dart
class ErrorLogger {
  static void logError(
    dynamic error,
    StackTrace? stackTrace, {
    Map<String, dynamic>? context,
  }) {
    final errorReport = {
      'timestamp': DateTime.now().toIso8601String(),
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'context': _sanitizeContext(context),
    };
    
    // Log to console in debug mode
    if (kDebugMode) {
      print('ERROR: ${jsonEncode(errorReport)}');
    }
    
    // Send to error tracking service in production
    if (kReleaseMode) {
      _sendToErrorTracking(errorReport);
    }
  }
  
  static Map<String, dynamic>? _sanitizeContext(Map<String, dynamic>? context) {
    if (context == null) return null;
    
    // Remove sensitive data
    final sanitized = Map<String, dynamic>.from(context);
    sanitized.remove('password');
    sanitized.remove('token');
    sanitized.remove('email');
    
    return sanitized;
  }
}
```

### Validation Error Messages

**Principle**: Clear, actionable, user-friendly

**Examples**:
```dart
class ValidationMessages {
  // Email
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String emailTaken = 'This email is already registered';
  
  // Password
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordNoUppercase = 'Password must contain at least one uppercase letter';
  static const String passwordNoLowercase = 'Password must contain at least one lowercase letter';
  static const String passwordNoNumber = 'Password must contain at least one number';
  static const String passwordNoSpecial = 'Password must contain at least one special character';
  static const String passwordMismatch = 'Passwords do not match';
  
  // Phone
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Please enter a valid phone number';
  
  // Age
  static const String ageRequired = 'Date of birth is required';
  static const String ageTooYoung = 'You must be at least 18 years old';
  
  // Text Length
  static String textTooShort(int minLength) => 
      'Please enter at least $minLength characters';
  static String textTooLong(int maxLength) => 
      'Please enter no more than $maxLength characters';
  
  // File Upload
  static const String fileRequired = 'Please select at least one photo';
  static const String fileInvalidFormat = 'Only JPEG, PNG, and HEIC images are allowed';
  static const String fileTooLarge = 'File size must not exceed 10MB';
  
  // Age Range
  static const String ageRangeInvalid = 'Maximum age must be greater than minimum age';
  static const String minAgeTooLow = 'Minimum age must be at least 18';
}
```

## Testing Strategy

### Testing Pyramid

The testing strategy follows the testing pyramid principle:

```
                    /\
                   /  \
                  / E2E \
                 /--------\
                /          \
               / Integration \
              /--------------\
             /                \
            /   Widget Tests   \
           /--------------------\
          /                      \
         /      Unit Tests        \
        /--------------------------\
       /    Property-Based Tests   \
      /------------------------------\
```

### 1. Property-Based Tests (Foundation)

**Purpose**: Verify universal properties of validation and data transformation logic

**Coverage**:
- All validation functions (email, password, phone, age, text length, file format/size)
- Data serialization/deserialization
- State management data preservation

**Tools**: 
- `test` package with custom property generators
- `dart_check` package for property-based testing

**Configuration**:
- Minimum 100 iterations per property
- Random seed logging for reproducibility
- Automatic shrinking enabled

**Example**:
```dart
test('Property 1: Email format validation', () {
  // Feature: authentication-onboarding-flow, Property 1: Email format validation
  forAll(
    stringGenerator(),
    (input) {
      final result = Validators.validateEmail(input);
      final isValidFormat = _isValidEmailFormat(input);
      expect(result == null, equals(isValidFormat));
    },
    iterations: 100,
  );
});
```

### 2. Unit Tests

**Purpose**: Test specific examples, edge cases, and error conditions

**Coverage**:
- Validation functions with specific examples
- Provider state transitions
- Repository methods with mocked dependencies
- Utility functions

**Tools**: `test` package, `mockito` for mocking

**Examples**:
```dart
group('Validators', () {
  group('validateEmail', () {
    test('returns null for valid email', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
    });
    
    test('returns error for email without @', () {
      expect(Validators.validateEmail('userexample.com'), isNotNull);
    });
    
    test('returns error for empty email', () {
      expect(Validators.validateEmail(''), isNotNull);
    });
  });
  
  group('validatePassword', () {
    test('returns null for valid password', () {
      expect(Validators.validatePassword('Password123!'), isNull);
    });
    
    test('returns error for password too short', () {
      final result = Validators.validatePassword('Pass1!');
      expect(result, contains('8 characters'));
    });
  });
});
```

### 3. Widget Tests

**Purpose**: Test UI components, user interactions, and screen layouts

**Coverage**:
- All custom widgets (GradientButton, CustomTextField, etc.)
- All screens with user interactions
- Navigation flows
- Animation behavior

**Tools**: `flutter_test` package

**Examples**:
```dart
group('LoginScreen', () {
  testWidgets('displays email and password fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen()),
    );
    
    expect(find.byType(CustomTextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
  
  testWidgets('shows error when login fails', (tester) async {
    final mockAuthProvider = MockAuthProvider();
    when(mockAuthProvider.loginWithEmail(any, any))
        .thenThrow(AuthenticationFailure());
    
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: MaterialApp(home: LoginScreen()),
      ),
    );
    
    await tester.enterText(
      find.byType(CustomTextField).first,
      'user@example.com',
    );
    await tester.enterText(
      find.byType(CustomTextField).last,
      'password123',
    );
    await tester.tap(find.byType(GradientButton));
    await tester.pumpAndSettle();
    
    expect(find.byType(ErrorMessage), findsOneWidget);
  });
});
```

### 4. Integration Tests

**Purpose**: Test interactions between components and external services

**Coverage**:
- API client with real/mocked backend
- Authentication flows with Firebase
- Photo upload with storage service
- State persistence with local storage
- Navigation with routing

**Tools**: `integration_test` package, `mockito` for service mocking

**Examples**:
```dart
group('Authentication Flow', () {
  testWidgets('complete registration flow', (tester) async {
    await tester.pumpWidget(MyApp());
    
    // Navigate to signup
    await tester.tap(find.text('Sign up with Email'));
    await tester.pumpAndSettle();
    
    // Fill registration form
    await tester.enterText(
      find.byKey(Key('email_field')),
      'newuser@example.com',
    );
    await tester.enterText(
      find.byKey(Key('name_field')),
      'New User',
    );
    await tester.enterText(
      find.byKey(Key('password_field')),
      'Password123!',
    );
    await tester.enterText(
      find.byKey(Key('confirm_password_field')),
      'Password123!',
    );
    await tester.tap(find.byKey(Key('terms_checkbox')));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    
    // Verify navigation to email verification
    expect(find.byType(EmailVerificationScreen), findsOneWidget);
  });
});
```

### 5. End-to-End Tests

**Purpose**: Test complete user journeys from start to finish

**Coverage**:
- Registration → Email verification → Profile setup → Subscription
- Login → Home screen
- Password reset flow
- Onboarding completion

**Tools**: `integration_test` package with real backend (staging environment)

**Examples**:
```dart
testWidgets('complete onboarding journey', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // 1. Register
  await _completeRegistration(tester);
  
  // 2. Verify email
  await _verifyEmail(tester);
  
  // 3. Select profile type
  await tester.tap(find.text('Male'));
  await tester.pumpAndSettle();
  
  // 4. Complete all onboarding steps
  await _fillBasicInformation(tester);
  await _fillPersonalDetails(tester);
  await _fillAboutExpectations(tester);
  await _uploadPhotos(tester);
  await _setPreferences(tester);
  
  // 5. Select subscription
  await tester.tap(find.text('Skip for now'));
  await tester.pumpAndSettle();
  
  // 6. Verify navigation to home
  expect(find.byType(HomeBrowseScreen), findsOneWidget);
});
```

### Test Coverage Goals

- **Overall Code Coverage**: 80%+
- **Validation Logic**: 100%
- **State Management**: 90%+
- **UI Components**: 70%+
- **Integration Points**: 80%+

### Continuous Integration

**CI Pipeline**:
1. Run all unit tests (including property-based tests)
2. Run widget tests
3. Run integration tests with mocked services
4. Generate coverage report
5. Fail build if coverage < 80%

**Pre-commit Hooks**:
- Run unit tests
- Run linter
- Format code

### Performance Testing

**Metrics to Monitor**:
- Screen render time (target: < 2 seconds)
- Animation frame rate (target: 60 FPS)
- API response time (target: < 1 second)
- Photo upload time (target: < 5 seconds per photo)
- Memory usage (target: < 200MB)

**Tools**: Flutter DevTools, performance profiling

### Accessibility Testing

**Manual Testing Checklist**:
- [ ] Screen reader navigation (TalkBack/VoiceOver)
- [ ] Keyboard navigation (web/desktop)
- [ ] Color contrast ratios (WCAG AA)
- [ ] Touch target sizes (44x44 minimum)
- [ ] Text scaling (up to 200%)
- [ ] Reduced motion preferences

**Automated Testing**:
```dart
testWidgets('meets accessibility guidelines', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginScreen()));
  
  final SemanticsHandle handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  handle.dispose();
});
```

## Implementation Roadmap

### Phase 1: Foundation (Week 1-2)

- [ ] Set up project structure and dependencies
- [ ] Implement theme system (colors, typography, dimensions)
- [ ] Create reusable component library (buttons, text fields, etc.)
- [ ] Set up navigation with GoRouter
- [ ] Implement API client with interceptors
- [ ] Set up state management with Provider
- [ ] Create data models and repositories

### Phase 2: Authentication (Week 3-4)

- [ ] Implement Welcome/Landing screen
- [ ] Implement Login screen with validation
- [ ] Implement Sign Up screen with validation
- [ ] Implement Email Verification screen with OTP
- [ ] Implement Verified Success screen with animation
- [ ] Implement Forgot Password flow
- [ ] Implement Create New Password screen
- [ ] Integrate Firebase Authentication for social auth
- [ ] Write unit tests for validation logic
- [ ] Write property-based tests for validators

### Phase 3: Onboarding (Week 5-7)

- [ ] Implement Profile Type Selection screen
- [ ] Implement Wali Profile Info screen
- [ ] Implement Basic Information screen (Step 1)
- [ ] Implement Personal Details screen (Step 2)
- [ ] Implement About & Expectations screen (Step 3)
- [ ] Implement Upload Photos screen (Step 4)
- [ ] Implement Your Preferences screen (Step 5)
- [ ] Implement step progress indicator
- [ ] Implement state persistence
- [ ] Write widget tests for all screens
- [ ] Write property-based tests for data persistence

### Phase 4: Subscription & Main App (Week 8-9)

- [ ] Implement Subscription Plans screen
- [ ] Integrate payment gateway
- [ ] Implement My Profile screen
- [ ] Implement Home/Browse screen
- [ ] Implement Requests screen
- [ ] Implement bottom navigation
- [ ] Write integration tests for complete flows

### Phase 5: Polish & Testing (Week 10-11)

- [ ] Implement all animations and micro-interactions
- [ ] Optimize performance (lazy loading, caching)
- [ ] Implement offline support
- [ ] Add error handling and recovery
- [ ] Conduct accessibility audit
- [ ] Write end-to-end tests
- [ ] Conduct user acceptance testing
- [ ] Fix bugs and polish UI

### Phase 6: Deployment (Week 12)

- [ ] Set up CI/CD pipeline
- [ ] Configure staging environment
- [ ] Conduct security audit
- [ ] Prepare app store listings
- [ ] Deploy to staging
- [ ] Final QA testing
- [ ] Deploy to production

## Conclusion

This design document provides a comprehensive blueprint for implementing the authentication and onboarding flow for the Muslim matrimonial matchmaking application. The architecture emphasizes:

1. **Modularity**: Clear separation of concerns with layered architecture
2. **Reusability**: Comprehensive component library for consistent UI
3. **Testability**: Property-based testing for validation logic, comprehensive test coverage
4. **User Experience**: Smooth animations, clear error handling, accessibility support
5. **Maintainability**: Well-structured code, clear patterns, extensive documentation

The implementation follows Flutter best practices and leverages property-based testing to ensure correctness of critical validation and data transformation logic, while using traditional testing approaches for UI and integration concerns.

