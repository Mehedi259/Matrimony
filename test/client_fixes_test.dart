import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrimony/core/constants/api_constants.dart';
import 'package:matrimony/core/constants/choice_mappings.dart';
import 'package:matrimony/core/utils/html_text_formatter.dart';
import 'package:matrimony/data/models/auth/password_reset_response.dart';
import 'package:matrimony/data/models/chat/chat_models.dart';
import 'package:matrimony/data/models/matches/match_profile_model.dart';
import 'package:matrimony/data/models/notification_model.dart';
import 'package:matrimony/data/models/profile/basic_info_model.dart';
import 'package:matrimony/data/models/profile/wali_profile_model.dart';
import 'package:matrimony/data/models/support/support_models.dart';
import 'package:matrimony/data/models/user_model.dart';
import 'package:matrimony/data/repositories/support_repository.dart';
import 'package:matrimony/features/auth_onboarding/presentation/widgets/common/country_phone_field.dart';
import 'package:matrimony/features/auth_onboarding/presentation/widgets/common/custom_text_field.dart';
import 'package:matrimony/features/auth_onboarding/presentation/widgets/common/multi_select_field.dart';
import 'package:matrimony/features/main_navigation/presentation/widgets/match_card.dart';
import 'package:matrimony/features/main_navigation/presentation/widgets/photo_viewer_dialog.dart';
import 'package:matrimony/features/main_navigation/presentation/widgets/profile_badges.dart';
import 'package:matrimony/features/main_navigation/presentation/widgets/upgrade_subscription_dialog.dart';
import 'package:matrimony/providers/matches_provider.dart';

void main() {
  group('Sect and choice mappings', () {
    test('maps salafi, sunni, and other sect keys to exact display strings', () {
      expect(
        ChoiceMappings.keyToDisplay('salafi', ChoiceMappings.sectKeyToDisplay),
        'Sunni/Salafi',
      );
      expect(
        ChoiceMappings.keyToDisplay('sunni', ChoiceMappings.sectKeyToDisplay),
        'Sunni',
      );
      expect(
        ChoiceMappings.keyToDisplay('other', ChoiceMappings.sectKeyToDisplay),
        'Other Sect',
      );
    });

    test('formats comma-separated ethnicity and language keys cleanly', () {
      expect(
        ChoiceMappings.keysStringToDisplay(
          'afghan, american, algerian',
          ChoiceMappings.ethnicityKeyToDisplay,
        ),
        'Afghan, American, Algerian',
      );
      expect(
        ChoiceMappings.keysStringToDisplay(
          'arabic, english, urdu',
          ChoiceMappings.languageKeyToDisplay,
        ),
        'Arabic, English, Urdu',
      );
    });
  });

  group('MatchProfileModel online status, about fields, and preferences', () {
    test('infers isOnline from recent last_active or Active now display', () {
      final recent = MatchProfileModel.fromJson({
        'id': 'u1',
        'codename': 'S-7',
        'role': 'candidate',
        'subscription_plan': 'free',
        'completion_percentage': 90,
        'last_active': DateTime.now()
            .toUtc()
            .subtract(const Duration(minutes: 2))
            .toIso8601String(),
      });
      expect(recent.isOnline, isTrue);

      final activeNow = MatchProfileModel.fromJson({
        'id': 'u2',
        'codename': 'B-9',
        'role': 'candidate',
        'subscription_plan': 'free',
        'completion_percentage': 80,
        'last_active_display': 'Active now',
      });
      expect(activeNow.isOnline, isTrue);

      final stale = MatchProfileModel.fromJson({
        'id': 'u3',
        'codename': 'S-12',
        'role': 'candidate',
        'subscription_plan': 'free',
        'completion_percentage': 80,
        'last_active': DateTime.now()
            .toUtc()
            .subtract(const Duration(minutes: 15))
            .toIso8601String(),
        'last_active_display': '15m ago',
      });
      expect(stale.isOnline, isFalse);
    });

    test('parses all About You & Expectations and Preferences fields', () {
      final model = MatchProfileModel.fromJson({
        'id': 'u4',
        'codename': 'S-19',
        'role': 'candidate',
        'subscription_plan': 'gold',
        'completion_percentage': 100,
        'ethnicity': ['afghan', 'american'],
        'languages': ['arabic', 'english'],
        'about': 'Wali bio',
        'about_yourself': 'Candidate bio',
        'envision_marriage': 'Peaceful household',
        'relationship_with_islam': 'Practicing daily',
        'role_as_spouse': 'Supportive partner',
        'envision_spouse': 'Kind and pious',
        'spouse_religious_status_pref': 'Prays 5x',
        'open_to_relocate_details': 'Open within UK',
        'other_preferences': 'Respects family',
        'pref_age_min': 24,
        'pref_age_max': 30,
        'pref_marital_status': ['never_married', 'divorced'],
        'pref_ethnicity': ['afghan', 'arab'],
        'pref_country_of_residence': ['United Kingdom', 'Canada'],
        'preferred_dress': ['hijab', 'niqab'],
      });

      expect(model.ethnicity, 'Afghan, American');
      expect(model.languages, 'Arabic, English');
      expect(model.about, 'Wali bio');
      expect(model.aboutYourself, 'Candidate bio');
      expect(model.envisionMarriage, 'Peaceful household');
      expect(model.relationshipWithIslam, 'Practicing daily');
      expect(model.roleAsSpouse, 'Supportive partner');
      expect(model.envisionSpouse, 'Kind and pious');
      expect(model.spouseReligiousStatusPref, 'Prays 5x');
      expect(model.openToRelocateDetails, 'Open within UK');
      expect(model.otherPreferences, 'Respects family');
      expect(model.prefAgeMin, 24);
      expect(model.prefAgeMax, 30);
      expect(model.prefMaritalStatus, ['never_married', 'divorced']);
      expect(model.prefEthnicity, ['afghan', 'arab']);
      expect(model.prefCountryOfResidence, ['United Kingdom', 'Canada']);
      expect(model.preferredDress, ['hijab', 'niqab']);
    });
  });

  group('Notifications and Admin Chat models', () {
    test('ApiConstants points to shared notification endpoints', () {
      expect(ApiConstants.notifications, '/api/notification/shared/');
      expect(
        ApiConstants.notificationsMarkAllRead,
        '/api/notification/shared/mark-all-read/',
      );
      expect(
        ApiConstants.notificationsUnreadCount,
        '/api/notification/shared/unread-count/',
      );
    });

    test('NotificationModel parses UUID id and notification_type', () {
      final n = NotificationModel.fromJson({
        'id': '7f8b1c40-9e4d-4d2c-a2c3-112233445566',
        'notification_type': 'connection_request_received',
        'title': 'New Connection Request',
        'body': 'B-9 wants to connect with you.',
        'is_read': false,
        'priority': 'high',
        'data': {'request_id': 'req-1'},
        'created_at': '2026-11-10T12:00:00Z',
      });

      expect(n.id, '7f8b1c40-9e4d-4d2c-a2c3-112233445566');
      expect(n.type, 'connection_request_received');
      expect(n.isRead, isFalse);
      expect(n.priority, 'high');
      expect(n.data?['request_id'], 'req-1');
    });

    test('ChatRoomModel parses backend my-room payload without room_id', () {
      final room = ChatRoomModel.fromJson({
        'id': 'room-uuid-1',
        'unread_count': 3,
        'last_message': {
          'id': 'msg-1',
          'created_at': '2026-11-10T12:30:00Z',
        },
        'created_at': '2026-11-01T10:00:00Z',
        'updated_at': '2026-11-10T12:30:00Z',
      });

      expect(room.id, 'room-uuid-1');
      expect(room.roomId, 'room-uuid-1');
      expect(room.unreadCount, 3);
      expect(room.lastMessageAt, DateTime.parse('2026-11-10T12:30:00Z'));
    });
  });

  group('Match connection status and card photo privacy', () {
    test('MatchModel.isActiveConnection reflects active vs inactive statuses', () {
      MatchModel buildMatch(String status) => MatchModel(
            id: 'm1',
            matchId: 'M-1',
            status: status,
            otherUser: const {'id': 'u1', 'codename': 'S-7'},
            photosCurrentlyVisible: false,
            photoRequestStatus: 'none',
            photoRequestedByOtherUser: false,
            waliRequestStatus: 'none',
            secondPhotoRequestStatus: 'none',
            photoViewCount: 0,
            updatedAt: DateTime.now(),
          );

      expect(buildMatch('accepted').isActiveConnection, isTrue);
      expect(buildMatch('wali_requested').isActiveConnection, isTrue);
      expect(buildMatch('in_discussion').isActiveConnection, isTrue);
      expect(buildMatch('married').isActiveConnection, isTrue);
      expect(buildMatch('dropped').isActiveConnection, isFalse);
      expect(buildMatch('cancelled').isActiveConnection, isFalse);
      expect(buildMatch('declined').isActiveConnection, isFalse);
      expect(buildMatch('pending').isActiveConnection, isFalse);
    });

    testWidgets(
      'MatchCard shows Connected instead of Send Interest and keeps blurred asset when isBlurred is true',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MatchCard(
                username: 'S-7',
                age: '41 Years old',
                ethnicity: 'Afghan',
                country: 'United Kingdom',
                imageUrl: 'https://example.com/private-photo.jpg',
                photos: const [
                  {'image': 'https://example.com/private-photo.jpg'},
                ],
                lockMessage: 'Photos will be revealed after mutual interest',
                isLocked: true,
                isBlurred: true,
                isConnected: true,
                onViewProfile: () {},
                onSendInterest: () {},
              ),
            ),
          ),
        );

        expect(find.text('Connected'), findsOneWidget);
        expect(find.text('Send Interest'), findsNothing);

        final container = tester.widget<Container>(find.byType(Container).first);
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.image?.image, isA<AssetImage>());
        expect(
          (decoration.image?.image as AssetImage).assetName,
          'assets/blurredProfile1.png',
        );
      },
    );

    testWidgets('MatchCard shows Send Interest only when neither connected nor pending', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MatchCard(
              username: 'B-9',
              age: '32 Years old',
              ethnicity: 'British',
              country: 'United Kingdom',
              lockMessage: 'Photos will be revealed after mutual interest',
              isLocked: true,
              isBlurred: true,
              isConnected: false,
              isRequestSent: false,
              onViewProfile: () {},
              onSendInterest: () {},
            ),
          ),
        ),
      );

      expect(find.text('Send Interest'), findsOneWidget);
      expect(find.text('Connected'), findsNothing);
    });

    testWidgets(
      'MatchCard shows View Profile alongside Decline and Accept on received requests',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MatchCard(
                username: 'B-12',
                age: '29 Years old',
                ethnicity: 'Pakistani',
                country: 'United Kingdom',
                lockMessage: 'Photos will be revealed after mutual interest',
                isLocked: true,
                isBlurred: true,
                onViewProfile: () {},
                onDecline: () {},
                onAccept: () {},
              ),
            ),
          ),
        );

        expect(find.text('View Profile'), findsOneWidget);
        expect(find.text('Decline'), findsOneWidget);
        expect(find.text('Accept'), findsOneWidget);
      },
    );

    test('MatchModel parses nested wali_details and discussion lock state', () {
      final lockedMatch = MatchModel.fromJson({
        'id': 'm-wali',
        'match_id': 'MT-10',
        'status': 'in_discussion',
        'other_user': {
          'id': 'u-9',
          'codename': 'S-9',
          'wali_details': {
            'wali_name': 'Abu Omar',
            'wali_relation': 'father',
            'wali_number': '+447700900123',
          },
        },
        'photos_currently_visible': false,
        'photo_request_status': 'none',
        'photo_requested_by_other_user': false,
        'wali_request_status': 'accepted',
        'second_photo_request_status': 'none',
        'photo_view_count': 1,
        'updated_at': '2026-11-10T12:00:00Z',
      });

      expect(lockedMatch.isWaliApproved, isTrue);
      expect(lockedMatch.isDiscussionLocked, isTrue);
      expect(lockedMatch.waliName, 'Abu Omar');
      expect(lockedMatch.waliRelation, 'father');
      expect(lockedMatch.waliNumber, '+447700900123');
    });

    testWidgets(
      'Upgrade dialog displays updated Paid Plan Benefits without messaging/photo items',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => showUpgradeSubscriptionDialog(context),
                    child: const Text('Open Upgrade'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Upgrade'));
        await tester.pumpAndSettle();

        expect(find.text('Send connection requests'), findsOneWidget);
        expect(find.text('Only annual plan is unlimited.'), findsOneWidget);
        expect(find.text('Priority Support & Matchmaking'), findsOneWidget);
        expect(find.textContaining('Direct Chat'), findsNothing);
        expect(find.textContaining('Extended Photo'), findsNothing);
      },
    );

    test('UserModel parses is_verified for verified and unverified accounts', () {
      Map<String, dynamic> buildPayload(bool verified) => {
            'id': 'u-1',
            'codename': 'S-7',
            'first_name': 'Sara',
            'last_name': 'A',
            'email': 'sara@example.com',
            'role': 'female',
            'gender': 'female',
            'subscription_plan': 'free',
            'provider': 'email',
            'is_active': true,
            'is_verified': verified,
            'is_private_matchmaking_client': false,
            'created_at': '2026-11-01T00:00:00Z',
            'updated_at': '2026-11-10T00:00:00Z',
          };

      final verifiedUser = UserModel.fromJson(buildPayload(true));
      final unverifiedUser = UserModel.fromJson(buildPayload(false));

      expect(verifiedUser.isVerified, isTrue);
      expect(verifiedUser.toJson()['is_verified'], isTrue);
      expect(unverifiedUser.isVerified, isFalse);
      expect(unverifiedUser.copyWith(isVerified: true).isVerified, isTrue);
    });

    testWidgets(
      'MatchedPhotoActionSection Approve button renders crisp white text on green background',
      (tester) async {
        final match = MatchModel.fromJson({
          'id': 'm-photo-req',
          'match_id': 'MT-5',
          'status': 'accepted',
          'other_user': {'id': 'u-2', 'codename': 'B-9'},
          'photos_currently_visible': false,
          'photo_request_status': 'requested',
          'photo_requested_by_other_user': true,
          'wali_request_status': 'none',
          'second_photo_request_status': 'none',
          'photo_view_count': 1,
          'updated_at': '2026-11-10T12:00:00Z',
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MatchedPhotoActionSection(
                match: match,
                photos: const [],
                otherCodename: 'B-9',
                isFemaleOrWali: true,
              ),
            ),
          ),
        );

        final approveText = tester.widget<Text>(find.text('Approve'));
        expect(approveText.style?.color, Colors.white);
      },
    );

    test(
      'MatchesProvider.parseDirectoryProfileDetail handles list nationality and wali payload safely',
      () {
        final waliPayload = <String, dynamic>{
          'profile': {
            'id': 'cb44a880-9706-4a72-8998-51732f359491',
            'codename': 'W-2',
            'first_name': 'asdsa',
            'last_name': 'sadf',
            'role': 'wali',
            'gender': null,
            'subscription_plan': 'free',
            'last_active': '2026-11-10T16:53:50.432673Z',
            'last_active_display': 'Active 17 hr(s) ago',
            'completion_percentage': 41,
            'age': 26,
            'city': 'dhaka',
            'country': 'Bangladeshi',
            'sect': null,
            'marital_status': null,
            'height': null,
            'has_boosted_profile': false,
            'photo_blurred': true,
          },
          'basic_info': {
            'id': '3cd1e432-8c15-4494-8dba-5e3aa039c833',
            'date_of_birth': '2000-06-15',
            'city': 'dhaka',
            'country': 'Bangladeshi',
            'about': null,
            'sect': null,
            'marital_status': null,
            'ethnicity': [],
            'nationality': [],
            'has_children': null,
            'children_count': null,
            'height': null,
            'languages_spoken': [],
            'pref_age_min': 22,
            'pref_age_max': 29,
            'pref_marital_status': ['never_married'],
            'pref_ethnicity': ['afghan'],
            'pref_country_of_residence': ['american'],
          },
        };

        final waliProfile =
            MatchesProvider.parseDirectoryProfileDetail(waliPayload);
        expect(waliProfile.codename, 'W-2');
        expect(waliProfile.role, 'wali');
        expect(waliProfile.nationality, isNull);
        expect(waliProfile.ethnicity, isNull);
        expect(waliProfile.prefMaritalStatus, ['never_married']);
        expect(waliProfile.prefEthnicity, ['afghan']);
        expect(waliProfile.prefCountryOfResidence, ['american']);

        final multiNationalityPayload = <String, dynamic>{
          'profile': waliPayload['profile'],
          'basic_info': {
            ...(waliPayload['basic_info'] as Map<String, dynamic>),
            'nationality': ['bangladeshi', 'british'],
            'ethnicity': ['bangladeshi'],
            'languages_spoken': ['bengali', 'english'],
          },
        };

        final multiProfile = MatchesProvider.parseDirectoryProfileDetail(
          multiNationalityPayload,
        );
        expect(multiProfile.nationality, 'Bangladeshi, British');
        expect(
          ChoiceMappings.keysStringToDisplay(
            multiProfile.nationality!,
            ChoiceMappings.nationalityKeyToDisplay,
          ),
          'Bangladeshi, British',
        );
        expect(multiProfile.ethnicity, 'Bangladeshi');
        expect(multiProfile.languages, 'Bengali, English');

        final rawListFields = MatchProfileModel.fromJson({
          'id': 'u-raw',
          'codename': 'W-9',
          'role': 'wali',
          'subscription_plan': 'free',
          'completion_percentage': '50',
          'city': ['dhaka'],
          'nationality': ['afghan'],
          'pray_5x': true,
        });
        expect(rawListFields.completionPercentage, 50);
        expect(rawListFields.city, 'dhaka');
        expect(rawListFields.nationality, 'Afghan');
        expect(rawListFields.pray5x, 'true');
      },
    );

    test(
      'PasswordReset responses parse backend payloads without email field',
      () {
        final initiate = PasswordResetInitiateResponse.fromJson(
          {
            'message': 'If this email is registered, an OTP has been sent.',
            'expires_in_seconds': 600,
          },
          fallbackEmail: 'noor@example.com',
        );
        expect(
          initiate.message,
          'If this email is registered, an OTP has been sent.',
        );
        expect(initiate.email, 'noor@example.com');
        expect(initiate.expiresInSeconds, 600);

        final initiateNoFallback = PasswordResetInitiateResponse.fromJson({
          'message': 'Sent',
          'expires_in_seconds': null,
        });
        expect(initiateNoFallback.email, '');
        expect(initiateNoFallback.expiresInSeconds, 600);

        final verify = PasswordResetVerifyResponse.fromJson({
          'message': 'OTP verified.',
          'reset_token': 'tok-123',
        });
        expect(verify.resetToken, 'tok-123');

        final confirm = PasswordResetConfirmResponse.fromJson({
          'message': 'Password reset successful.',
        });
        expect(confirm.message, 'Password reset successful.');
      },
    );

    test(
      'HtmlTextFormatter formats Terms HTML without showing raw tags or entities',
      () {
        const sampleHtml =
            '<p><strong>A MUSLIM MATCHMAKER&nbsp;</strong></p>'
            '<p><strong><br>Terms and Conditions</strong><br>'
            'Effective date: 01 August 2026<br>Version: 3.0</p>'
            '<p><br>1. About these Terms<br>1.1 Who we are<br>'
            'These Terms apply to our Services &amp; Support.</p>';

        final plain = HtmlTextFormatter.toPlainText(sampleHtml);
        expect(plain, isNot(contains('<p>')));
        expect(plain, isNot(contains('</p>')));
        expect(plain, isNot(contains('<strong>')));
        expect(plain, isNot(contains('<br>')));
        expect(plain, isNot(contains('&nbsp;')));
        expect(plain, contains('A MUSLIM MATCHMAKER'));
        expect(plain, contains('Terms and Conditions'));
        expect(plain, contains('Services & Support.'));

        final spans = HtmlTextFormatter.toSpans(sampleHtml).whereType<TextSpan>();
        expect(
          spans.any(
            (s) =>
                (s.text ?? '').contains('Terms and Conditions') &&
                s.style?.fontWeight == FontWeight.w700,
          ),
          isTrue,
        );
      },
    );
  });

  group('PDF revision client fixes verification', () {
    test('BasicInfoModel omits removed health_concerns field in JSON serialization', () {
      final info = BasicInfoModel.fromJson({
        'id': 'bi-1',
        'how_found': ['instagram'],
        'ethnicity': ['afghan'],
        'nationality': ['british'],
        'languages_spoken': ['english'],
        'dress': 'hijab_abaya',
        'pref_marital_status': ['never_married'],
        'pref_ethnicity': ['afghan'],
        'pref_country_of_residence': ['United Kingdom'],
        'completion_percentage': 85,
        'photos': const [],
        'created_at': '2026-11-10T10:00:00Z',
        'updated_at': '2026-11-10T10:00:00Z',
      });

      expect(info.dress, 'hijab_abaya');
      expect(info.toJson().containsKey('health_concerns'), isFalse);
    });

    test('WaliProfileModel parses dedicated wali profile fields', () {
      final wali = WaliProfileModel.fromJson({
        'id': 'wp-1',
        'first_name': 'Omar',
        'last_name': 'Khan',
        'wali_name': 'Omar Khan',
        'how_found': ['friend', 'masjid'],
        'gender': 'male',
        'relation_to_sister': 'brother',
        'phone': '+447700900123',
        'completion_percentage': 75,
      });

      expect(wali.firstName, 'Omar');
      expect(wali.lastName, 'Khan');
      expect(wali.waliName, 'Omar Khan');
      expect(wali.howFound, ['friend', 'masjid']);
      expect(wali.gender, 'male');
      expect(wali.relationToSister, 'brother');
      expect(wali.phone, '+447700900123');
      expect(wali.completionPercentage, 75);
    });

    test('UserModel, MatchProfileModel, and MatchModel parse verification and lock status', () {
      final user = UserModel.fromJson({
        'id': 'u-lock',
        'codename': 'B-1',
        'first_name': 'Ali',
        'last_name': 'H',
        'email': 'ali@example.com',
        'role': 'male',
        'gender': 'male',
        'subscription_plan': 'free',
        'provider': 'email',
        'is_active': true,
        'is_verified': true,
        'is_profile_locked': true,
        'is_private_matchmaking_client': false,
        'created_at': '2026-11-01T00:00:00Z',
        'updated_at': '2026-11-10T00:00:00Z',
      });
      expect(user.isVerified, isTrue);
      expect(user.isProfileLocked, isTrue);

      final profile = MatchProfileModel.fromJson({
        'id': 'u-2',
        'codename': 'S-5',
        'role': 'female',
        'subscription_plan': 'free',
        'completion_percentage': 90,
        'is_verified': true,
        'is_profile_locked': true,
      });
      expect(profile.isVerified, isTrue);
      expect(profile.isProfileLocked, isTrue);

      final match = MatchModel.fromJson({
        'id': 'm-lock',
        'match_id': 'MT-99',
        'status': 'accepted',
        'other_user': {
          'id': 'u-2',
          'codename': 'S-5',
          'is_verified': true,
          'last_active_display': 'Active 2 hr(s) ago',
        },
        'photos_currently_visible': false,
        'photo_request_status': 'none',
        'photo_requested_by_other_user': false,
        'wali_request_status': 'none',
        'second_photo_request_status': 'none',
        'photo_view_count': 0,
        'updated_at': '2026-11-10T12:00:00Z',
      });
      expect(match.isOtherUserVerified, isTrue);
      expect(match.isOtherUserOnline, isFalse);
      expect(match.otherUserOfflineLastActiveLabel, 'Active 2 hr(s) ago');
    });

    test('formatOfflineLastActive formats offline durations in hours or days only', () {
      final now = DateTime.now().toUtc();
      expect(
        MatchProfileModel.formatOfflineLastActive(now, 'Active now', isOnline: true),
        isNull,
      );
      expect(
        MatchProfileModel.formatOfflineLastActive(
          now.subtract(const Duration(hours: 5)),
          null,
          isOnline: false,
        ),
        'Active 5 hrs ago',
      );
      expect(
        MatchProfileModel.formatOfflineLastActive(
          now.subtract(const Duration(days: 3)),
          null,
          isOnline: false,
        ),
        'Active 3 days ago',
      );
      expect(
        MatchProfileModel.formatOfflineLastActive(
          now.subtract(const Duration(minutes: 20)),
          null,
          isOnline: false,
        ),
        'Active 1 hr ago',
      );
    });

    testWidgets('VerifiedCodename and OnlineStatusBadge render verification and activity states', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                VerifiedCodename(codename: 'B-7', isVerified: true),
                VerifiedCodename(codename: 'S-8', isVerified: false),
                OnlineStatusBadge(isOnline: true),
                OnlineStatusBadge(isOnline: false, offlineLabel: 'Active 3 hr(s) ago'),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.verified), findsOneWidget);
      expect(find.text('B-7'), findsOneWidget);
      expect(find.text('S-8'), findsOneWidget);
      expect(find.text('Online'), findsOneWidget);
      expect(find.text('Active 3 hr(s) ago'), findsOneWidget);
    });

    testWidgets('MatchCard displays verified icon and single-line Connection is pending button', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MatchCard(
              username: 'S-22',
              age: '28 Years old',
              ethnicity: 'Arab',
              country: 'United Kingdom',
              lockMessage: 'Locked',
              isLocked: true,
              isBlurred: true,
              isRequestSent: true,
              isVerified: true,
              onViewProfile: () {},
              onSendInterest: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.verified), findsOneWidget);
      final pendingText = tester.widget<Text>(find.text('Connection is pending'));
      expect(pendingText.maxLines, 1);
    });

    testWidgets('Required indicator * renders on CustomTextField and MultiSelectField', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const CustomTextField(label: 'City', isRequired: true),
                const CustomTextField(label: 'Optional Note', isRequired: false),
                MultiSelectField(
                  label: 'Ethnicity',
                  options: const ['Afghan', 'Arab'],
                  selectedValues: const [],
                  onChanged: (_) {},
                  isRequired: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('City *', findRichText: true), findsOneWidget);
      expect(find.text('Optional Note *', findRichText: true), findsNothing);
      expect(find.text('Ethnicity *', findRichText: true), findsOneWidget);
    });

    testWidgets('CountryPhoneField parses dial codes and syncs formatted E.164 phone numbers', (
      tester,
    ) async {
      final controller = TextEditingController(text: '+447700900123');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryPhoneField(
              controller: controller,
              label: 'Wali Contact Number',
              isRequired: true,
            ),
          ),
        ),
      );

      expect(find.text('Wali Contact Number *', findRichText: true), findsOneWidget);
      expect(find.text('+44'), findsOneWidget);
      expect(find.text('7700900123'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '7911123456');
      await tester.pump();
      expect(controller.text, '+447911123456');

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();
      expect(controller.text, '');
    });

    test('Support models and payload extractor handle paginated results and subject field', () {
      final rawList = SupportRepository.extractListPayload({
        'count': 1,
        'results': [
          {
            'id': 12,
            'subject': 'App Bug',
            'email': 'u@example.com',
            'message': 'Something broke',
            'created_at': '2026-11-11T10:00:00Z',
          },
        ],
      });
      expect(rawList, hasLength(1));

      final feedback = FeedbackModel.fromJson(
        rawList.first as Map<String, dynamic>,
      );
      expect(feedback.id, '12');
      expect(feedback.feedbackType, 'App Bug');
      expect(feedback.status, 'submitted');

      final faq = FaqModel.fromJson({
        'id': 3,
        'question': 'How do connections work?',
        'answer': 'Send an interest to begin.',
        'created_at': '2026-11-11T10:00:00Z',
      });
      expect(faq.id, '3');
      expect(faq.order, 0);
    });
  });
}

