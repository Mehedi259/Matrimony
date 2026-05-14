# Muslim Matrimony App

A premium Flutter-based matrimony application designed to help users find their perfect life partner. The app features a modern, clean, and highly interactive UI, focusing on seamless user onboarding, detailed profile creation, and dynamic match discovery.

## 🌟 Features Implemented

### 1. Authentication & Onboarding Flow
- **Splash & Landing Screens**: Premium welcome experience.
- **Authentication**: Login and Sign-Up screens.
- **Profile Setup Wizard**: Multi-step wizard to gather initial user details including Name, DOB, Location, Gender, Ethnicity, Education, and a short bio.

### 2. Main Navigation Dashboard
Integrated via `GoRouter` with a customized Bottom Navigation Bar:
- **Home**: Dynamic swipeable match cards with options to Accept, Decline, or Send Interest.
- **Search**: Advanced filtering and search functionality to find specific matches.
- **Messages**: Chat list and active conversation views.
- **Saved**: List of profiles the user has bookmarked.
- **Profile**: Comprehensive dashboard to manage user settings and detailed information.

### 3. Profile Completion & Forms
A dedicated section to build out a robust user profile:
- **Basic Information**: Update core details.
- **Personal Details**: Sect, lifestyle choices, physical attributes, and Wali (guardian) details.
- **Your Preferences**: Interactive dual range sliders for age and multi-select chips for demographics (Country, Ethnicity).
- **Upload Photos**: Grid-based photo management with placeholder UI.
- **About & Expectations**: Free-text areas to express ideas about marriage, Deen, and lifestyle.

### 4. Settings & Account Management
- **Edit Profile**: Update avatar, name, and gender.
- **Subscription Plans**: Detailed pricing tiers (Pay-as-you-go, Free, Monthly, Annual).
- **Chat with Admin**: Dedicated support messaging screen.
- **Support & Help**: FAQs, Privacy Policies, and Contact.
- **Security**: 
  - Change Password
  - Deactivate Account (Temporary hide with dialog)
  - Delete Account Workflow (Reason selection -> Confirmation dialog)
- **Logout**: Safe exit with confirmation modal.

## 🛠 Tech Stack & Architecture
- **Framework**: Flutter
- **Navigation**: `go_router` for deep linking and path-based declarative routing.
- **Design System**: Custom theme tokens (`AppColors`, `AppTypography`) ensuring a consistent UI with smooth gradients (`#8C9EFF` to `#E5A8B6`), standardized padding, and custom component sets.
- **State**: Currently utilizing ephemeral UI state via `StatefulWidget` and `TextEditingController`. (Ready for Riverpod/Bloc integration).

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (`>=3.0.0`)
- Dart SDK
- iOS Simulator or Android Emulator

### Run the App
1. Clone the repository.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the project:
   ```bash
   flutter run
   ```

## 📂 Folder Structure Overview
```text
lib/
 ├── core/
 │    ├── theme/            # AppColors, AppTypography, AppTheme
 │    └── widgets/          # Shared components (Buttons, Inputs)
 ├── features/
 │    ├── auth_onboarding/  # Login, Sign Up, Welcome, Initial Profile Setup
 │    └── main_navigation/  # Dashboard, Match Cards, Settings, Forms
 ├── app.dart               # App configuration & GoRouter Setup
 └── main.dart              # Application Entry Point
```
