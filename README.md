# HiFi Mobile App

A Flutter application with Firebase authentication and modern architecture patterns.

## Architecture Overview

### State Management & Navigation
- **GetX** for state management, dependency injection, and navigation
- Route management with dedicated routes file
- Bindings for dependency injection per module

### Project Structure
```
lib/
├── app/
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   ├── bindings/
│   └── middlewares/
├── modules/
│   ├── auth/
│   │   ├── controllers/
│   │   ├── views/
│   │   ├── widgets/
│   │   └── bindings/
│   └── [other_modules]/
├── services/
│   ├── auth_service.dart
│   ├── api_service.dart
│   └── firebase_service.dart
├── shared/
│   ├── widgets/
│   ├── constants/
│   ├── utils/
│   └── themes/
└── main.dart
```

### Technical Stack
- **HTTP Client**: Dio for API calls
- **UI Framework**: Material Design 3
- **Validation**: GetX built-in validation
- **Authentication**: Firebase Auth (Email/Password + Google Sign-In)
- **Theme**: Dark mode support with responsive design
- **Architecture**: Module-based structure with separation of concerns

### Features
- Email/Password authentication
- Google Sign-In integration
- Remember me functionality
- Forgot password
- Component-wise loading states
- Error handling via SnackBars
- Mobile-first responsive design

## Firebase Setup

### Prerequisites
1. Add Android app to Firebase project:
   - Package name: `mobile.hifi.click`
   - Download `google-services.json`
2. Add iOS app to Firebase project:
   - Bundle ID: `mobile.hifi.click`
   - Download `GoogleService-Info.plist`
3. Generate SHA-1 fingerprint for Android

### Configuration Files
- Place `google-services.json` in `android/app/`
- Place `GoogleService-Info.plist` in `ios/Runner/`

## Development Guidelines

### Git Workflow
- `main` - Production ready code
- `develop` - Development branch
- `feature/feature-name` - Feature branches
- `hotfix/fix-name` - Critical fixes

### Commit Message Format
```
type: brief description

Detailed explanation if needed
```
**Types**: feat, fix, docs, style, refactor, test, chore

### Code Standards
- Module-based architecture
- Component-wise loading states
- Reusable widgets in shared folder
- Service classes for API logic
- Professional naming conventions

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Configure Firebase (see Firebase Setup)
4. Run `flutter run`

## Dependencies

See `pubspec.yaml` for complete list of dependencies including:
- GetX for state management
- Firebase Auth
- Google Sign-In
- Dio for HTTP requests
- Material Design 3
