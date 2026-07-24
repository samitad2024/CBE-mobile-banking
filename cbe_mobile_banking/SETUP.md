# SETUP — CBE Mobile Banking

Environment checklist for the Flutter skeleton. Full product architecture comes later.

## Tools verified on this machine (2026-07-24)

| Tool | Status | Notes |
|------|--------|-------|
| Flutter **3.44.6** (stable) | OK | `C:\Users\hp\flutter` |
| Dart **3.12.2** | OK | Bundled with Flutter |
| Git **2.52.0** | OK | |
| Android SDK **36.0.0** | OK | `ANDROID_HOME` set |
| Android licenses | OK | Accepted after switching JDK |
| Android Studio JBR **21** | OK | `flutter config --jdk-dir=...jbr` |
| Chrome | OK | Optional web; not primary target |
| Visual Studio (Windows desktop) | Missing | Not required for Android/iOS mobile |
| Android emulator AVD | Missing | Create via Android Studio Device Manager |
| Connected mobile device | None at setup time | Use AVD or `flutter build apk --debug` |

### `flutter doctor -v` summary (expected healthy mobile setup)

```
[√] Flutter (Channel stable, 3.44.6, ...)
[√] Windows Version
[√] Android toolchain - develop for Android devices (Android SDK version 36.0.0)
    • Java binary at: ...\Android Studio\jbr\bin\java
    • All Android licenses accepted.
[√] Chrome - develop for the web
[X] Visual Studio - develop Windows apps   ← ignore for mobile-first
[√] Connected device (… or use build apk if none)
[√] Network resources
```

## Common Windows blockers

1. **PATH** — `flutter` / `dart` not found → add `...\flutter\bin` to User PATH; restart terminal.  
2. **Android licenses** — `flutter doctor --android-licenses` and accept all.  
3. **JDK too new (e.g. 25)** — `sdkmanager` / licenses may fail. Use Android Studio JBR 17–21:

   ```powershell
   flutter config --jdk-dir="C:\Program Files\Android\Android Studio\jbr"
   ```

4. **cmdline-tools location** — if doctor warns about `cmdline-tools\latest-2`, install/move **latest** under `Sdk\cmdline-tools\latest`.  
5. **No emulator** — Android Studio → Device Manager → Create Device → download a system image → start AVD.  
6. **Chrome** — only needed for web; optional for this banking app.  
7. **Visual Studio C++** — only for Windows desktop builds; skip for Android/iOS focus.

## How to run

```powershell
cd c:\Users\hp\Downloads\CBE-mobile-banking\cbe_mobile_banking
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d <device_id>
```

If no emulator/device is available:

```powershell
flutter build apk --debug
```

APK output (typical): `build\app\outputs\flutter-apk\app-debug.apk`

### Verification completed (this machine)

| Check | Result |
|-------|--------|
| `flutter pub get` | OK |
| `flutter analyze` | **No issues found** |
| `flutter test` | **All tests passed** |
| `flutter build apk --debug` | **OK** → `build\app\outputs\flutter-apk\app-debug.apk` |

### iOS note (Windows)

iOS folders are generated for later Mac/Xcode builds. You cannot compile iOS on Windows. Use a Mac CI or Mac host when targeting the App Store.

## Security config already applied

- `.env.example` only (no real secrets)
- Android cleartext disabled (`usesCleartextTraffic=false` + network security config)
- `minSdk` floor **24**
- iOS Face ID usage string placeholder
- Biometric permissions declared on Android

## Dependency choices (short)

- **Equatable models** for mock phase (not Freezed yet) — less codegen until APIs exist.  
- **No ScreenUtil** yet — add only if PDF pixel fidelity requires it.  
- **logger** instead of printing — and never log PIN/token/PII.

## Next step

Implement **Home** dashboard UI from the PDF, then Transfer.  
See [`ARCHITECTURE_STRUCTURE.md`](ARCHITECTURE_STRUCTURE.md).

## Architecture structure completed

- PDF-mapped features + **full BLoC coverage** for every feature module
- Auth sample + Home / Transfer / Request / Transactions / Scan / Wallet / Settings blocs
- `AppBlocObserver`, GetIt factories, mock repositories
- `flutter analyze` clean · tests passed

### BLoC map

| Feature | Bloc |
|---------|------|
| Auth | `AuthBloc` |
| Home | `HomeBloc` |
| Transfer | `TransferBloc` |
| Request | `RequestMoneyBloc` |
| Transactions | `TransactionsBloc` |
| Scan | `ScanBloc` |
| Wallet | `WalletBloc` |
| Settings | `SettingsBloc` |

