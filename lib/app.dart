import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth_onboarding/presentation/screens/welcome_screen.dart';
import 'features/auth_onboarding/presentation/screens/login_screen.dart';
import 'features/auth_onboarding/presentation/screens/profile_type_selection_screen.dart';
import 'features/auth_onboarding/presentation/screens/wali_profile_info_screen.dart';
import 'features/auth_onboarding/presentation/screens/signup_screen.dart';
import 'features/auth_onboarding/presentation/screens/email_verification_screen.dart';
import 'features/auth_onboarding/presentation/screens/verified_success_screen.dart';
import 'features/auth_onboarding/presentation/screens/forgot_password_screen.dart';
import 'features/auth_onboarding/presentation/screens/create_new_password_screen.dart';
import 'features/auth_onboarding/presentation/screens/basic_information_screen.dart';
import 'features/auth_onboarding/presentation/screens/personal_details_screen.dart';
import 'features/auth_onboarding/presentation/screens/about_expectations_screen.dart';
import 'features/auth_onboarding/presentation/screens/upload_photos_screen.dart';
import 'features/auth_onboarding/presentation/screens/your_preferences_screen.dart';
import 'features/auth_onboarding/presentation/screens/subscription_plans_screen.dart';
import 'features/auth_onboarding/presentation/widgets/onboarding/step_progress_indicator.dart';

// Main Navigation Imports
import 'features/main_navigation/presentation/screens/main_layout_screen.dart';
import 'features/main_navigation/presentation/screens/home_screen.dart';
import 'features/main_navigation/presentation/screens/browse_screen.dart';
import 'features/main_navigation/presentation/screens/requests_screen.dart';
import 'features/main_navigation/presentation/screens/profile_screen.dart';

// Additional screens
import 'features/main_navigation/presentation/screens/profile_views_screen.dart';
import 'features/main_navigation/presentation/screens/profile_view_details_screen.dart';
import 'features/main_navigation/presentation/screens/notifications_screen.dart';
import 'features/main_navigation/presentation/screens/private_matchmaking_screen.dart';
import 'features/main_navigation/presentation/screens/private_matches_screen.dart';
import 'features/main_navigation/presentation/screens/saved_screen.dart';
import 'features/main_navigation/presentation/screens/matched_profile_view_screen.dart';
import 'features/main_navigation/presentation/screens/basic_information_form_screen.dart';
import 'features/main_navigation/presentation/screens/personal_details_form_screen.dart';
import 'features/main_navigation/presentation/screens/preferences_form_screen.dart';
import 'features/main_navigation/presentation/screens/upload_photo_form_screen.dart';
import 'features/main_navigation/presentation/screens/about_expectations_form_screen.dart';
import 'features/main_navigation/presentation/screens/settings_screen.dart';
import 'features/main_navigation/presentation/screens/edit_profile_screen.dart';
import 'features/main_navigation/presentation/screens/subscription_screen.dart';
import 'features/main_navigation/presentation/screens/security_screen.dart';
import 'features/main_navigation/presentation/screens/support_help_screen.dart';
import 'features/main_navigation/presentation/screens/chat_with_admin_screen.dart';
import 'features/main_navigation/presentation/screens/change_password_screen.dart';
import 'features/main_navigation/presentation/screens/delete_account_reason_screen.dart';
import 'features/main_navigation/presentation/screens/delete_account_feedback_screen.dart';
import 'features/main_navigation/presentation/screens/pending_screen.dart';

class MatrimonyApp extends StatelessWidget {
  MatrimonyApp({super.key});

  final _router = GoRouter(
    initialLocation: '/welcome',
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
        path: '/onboarding/profile-type',
        builder: (context, state) => const ProfileTypeSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding/wali-info',
        builder: (context, state) => const WaliProfileInfoScreen(),
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
      ShellRoute(
        builder: (context, state, child) {
          int step = 1;
          if (state.uri.path.contains('personal-details')) step = 2;
          else if (state.uri.path.contains('preferences')) step = 3;
          else if (state.uri.path.contains('about-expectations')) step = 4;
          else if (state.uri.path.contains('upload-photos')) step = 5;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: BackButton(onPressed: () {
                if (context.canPop()) context.pop();
              }),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: StepProgressIndicator(currentStep: step),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          );
        },
        routes: [
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
        ],
      ),
      GoRoute(
        path: '/subscription-plans',
        builder: (context, state) => const SubscriptionPlansScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayoutScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/browse',
            builder: (context, state) => const BrowseScreen(),
          ),
          GoRoute(
            path: '/requests',
            builder: (context, state) => const RequestsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/profile-views',
        builder: (context, state) => const ProfileViewsScreen(),
      ),
      GoRoute(
        path: '/profile-view-details',
        builder: (context, state) => const ProfileViewDetailsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/private-matchmaking',
        builder: (context, state) => const PrivateMatchmakingScreen(),
      ),
      GoRoute(
        path: '/private-matches',
        builder: (context, state) => const PrivateMatchesScreen(),
      ),
      GoRoute(
        path: '/saved',
        builder: (context, state) => const SavedScreen(),
      ),
      GoRoute(
        path: '/matched-profile-view',
        builder: (context, state) => const MatchedProfileViewScreen(),
      ),
      GoRoute(
        path: '/basic-information-form',
        builder: (context, state) => const BasicInformationFormScreen(),
      ),
      GoRoute(
        path: '/personal-details-form',
        builder: (context, state) => const PersonalDetailsFormScreen(),
      ),
      GoRoute(
        path: '/preferences-form',
        builder: (context, state) => const PreferencesFormScreen(),
      ),
      GoRoute(
        path: '/upload-photo-form',
        builder: (context, state) => const UploadPhotoFormScreen(),
      ),
      GoRoute(
        path: '/about-expectations-form',
        builder: (context, state) => const AboutExpectationsFormScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings/subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/settings/security',
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: '/settings/support',
        builder: (context, state) => const SupportHelpScreen(),
      ),
      GoRoute(
        path: '/settings/chat-with-admin',
        builder: (context, state) => const ChatWithAdminScreen(),
      ),
      GoRoute(
        path: '/settings/security/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/settings/security/delete-account-reason',
        builder: (context, state) => const DeleteAccountReasonScreen(),
      ),
      GoRoute(
        path: '/settings/security/delete-account-feedback',
        builder: (context, state) => const DeleteAccountFeedbackScreen(),
      ),
      GoRoute(
        path: '/pending',
        builder: (context, state) => const PendingScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Matrimony Matchmaker',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
