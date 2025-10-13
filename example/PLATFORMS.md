# Platform Support

This Flutter Yuku example app now supports all major platforms!

## ✅ Supported Platforms

- **Android** 📱
- **iOS** 🍎
- **Web** 🌐
- **macOS** 💻
- **Windows** 🪟
- **Linux** 🐧

## Running on Different Platforms

### Android
```bash
flutter run -d android
# or specify device
flutter run -d emulator-5554
```

### iOS
```bash
flutter run -d ios
# or specify simulator
flutter run -d "iPhone 15"
```

### Web
```bash
flutter run -d chrome
# or build for production
flutter build web
```

### macOS
```bash
flutter run -d macos
```

### Windows
```bash
flutter run -d windows
```

### Linux
```bash
flutter run -d linux
```

## Building for Release

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ipa --release
```

### Web
```bash
flutter build web --release
```

### macOS App
```bash
flutter build macos --release
```

### Windows Executable
```bash
flutter build windows --release
```

### Linux Executable
```bash
flutter build linux --release
```

## Platform-Specific Features

All platforms support:
- ✅ Client initialization and configuration
- ✅ Wallet operations
- ✅ NFT display and management
- ✅ Marketplace operations
- ✅ Multi-network support (Ethereum, Solana, Polygon, ICP)
- ✅ Utility functions (address validation, price formatting)

## App Name

The app is named **"Flutter Yuku"** across all platforms.

## Development

To check available devices:
```bash
flutter devices
```

To see all connected emulators/simulators:
```bash
flutter emulators
```

To launch a specific emulator:
```bash
flutter emulators --launch <emulator_id>
```

## Platform Files Structure

```
example/
├── android/          # Android native code
├── ios/             # iOS native code
├── web/             # Web assets
├── macos/           # macOS native code
├── windows/         # Windows native code
├── linux/           # Linux native code
└── lib/             # Shared Dart code
    └── main.dart    # Main application
```

## Notes

- The example uses demo data and doesn't connect to real blockchain networks
- All transactions and operations are simulated for demonstration purposes
- The UI is responsive and adapts to different screen sizes and platforms

