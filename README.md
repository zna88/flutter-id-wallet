
# Flutter ID Wallet

Flutter ID Wallet is a secure, themeable, and multilingual Flutter application for managing application credentials and wallet information. It supports local encryption, password protection, and persistent storage.

## Features

- Store and manage application credentials securely
- Local encryption for sensitive data
- Password protection for app access
- Light and dark theme support
- Multilingual support (English, Myanmar)
- Persistent storage using localstorage
- Modern, responsive UI

## Folder Structure

- `lib/`
  - `main.dart` - App entry point
  - `models/` - Data models (Application, WalletInfo, Language, EncryptionInfo)
  - `providers/` - State management (Theme, Data, Language)
  - `screens/` - UI screens (login, settings, home, etc.)
  - `widgets/` - Reusable UI components
  - `config/` - Theme and palette configuration
  - `l10n/` - Localization files
  - `repos/` - Local storage logic

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart 2.12.0 or later

### Install Dependencies
```
flutter pub get
```

### Run the App
```
flutter run
```

### Build for Release
```
flutter build apk   # Android
flutter build ios   # iOS
```

## Localization
Edit the `.arb` files in `lib/l10n/` to add or update translations. Run:
```
flutter gen-l10n
```
to regenerate localization files.

## Theming
Customize colors and themes in `lib/config/pallete.dart` and `lib/config/custom_theme.dart`.

## Storage
Data is stored locally using the `localstorage` package. See `lib/repos/local_storage_settings.dart` for details.

## License
This project is private and not published to pub.dev.
