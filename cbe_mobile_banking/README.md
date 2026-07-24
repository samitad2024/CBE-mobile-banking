# CBE Mobile Banking

Commercial Bank of Ethiopia (CBE) mobile banking redesign — Flutter workspace.

> **This step:** runnable project skeleton + tooling only.  
> **Not yet:** Clean Architecture folders, feature screens, or `blueprint.md`.

UI reference: `../CBE APP REDESIGNED.pdf` (branding/theme source of truth for later UI work).

## Prerequisites (Windows)

| Tool | Purpose | Validate |
|------|---------|----------|
| Flutter SDK (stable) | App framework | `flutter --version` |
| Dart SDK | Bundled with Flutter | `dart --version` |
| Git | Version control | `git --version` |
| Android Studio + Android SDK | Android builds / emulator | SDK Manager + AVD |
| JDK 17–21 (Android Studio JBR recommended) | Gradle / licenses | `java -version` |
| Cursor / VS Code + Flutter & Dart extensions | Editor (optional) | Extensions marketplace |

### Install Flutter (if needed)

1. Download stable SDK: https://docs.flutter.dev/get-started/install/windows  
2. Extract (e.g. `C:\Users\<you>\flutter`) and add `...\flutter\bin` to **PATH**.  
3. Run `flutter doctor` and fix reported issues.

### Android Studio / SDK

1. Install [Android Studio](https://developer.android.com/studio).  
2. SDK Manager → install **Android SDK**, **Platform-Tools**, **cmdline-tools**, at least one **system image**.  
3. Device Manager → create an AVD (emulator).  
4. Accept licenses: `flutter doctor --android-licenses`  
5. If licenses fail on JDK 25+, point Flutter at Android Studio’s JBR:

```powershell
flutter config --jdk-dir="C:\Program Files\Android\Android Studio\jbr"
```

### Cursor / VS Code (optional)

Install extensions: **Flutter** and **Dart** (Dart Code).

## Quick start

```powershell
cd cbe_mobile_banking
flutter pub get
flutter analyze
flutter test
flutter run
# or, without a device/emulator:
flutter build apk --debug
```

## Package identity

- Project folder / Dart package: `cbe_mobile_banking`
- Application ID / bundle id: `com.cbe.mobilebanking`
- Platforms enabled: **Android** + **iOS** (mobile-first)

## Baseline dependencies (declared, not wired yet)

| Package | Why |
|---------|-----|
| `flutter_bloc` + `equatable` | State management |
| `get_it` | DI / service locator (`injectable` later if needed) |
| `dio` | HTTP client for future APIs (mock data first) |
| `go_router` | Declarative navigation |
| `flutter_secure_storage` | Secure token/PIN storage baseline |
| `local_auth` | Biometrics placeholder |
| `logger` | Debug logging (no secrets / PII) |
| `very_good_analysis` | Strict lint rules |

### Models strategy (mock phase)

**Simple Equatable Dart models** — no `freezed` / `json_serializable` yet.

**Why:** Mock-first work does not need codegen; adding Freezed before API contracts creates unused build_runner noise. Add `freezed` + `json_serializable` + `build_runner` when backend DTOs are defined.

### Screen scaling

**`flutter_screenutil` not added.** Prefer Flutter layout + design tokens first; revisit ScreenUtil only if PDF fidelity requires device-adaptive scaling.

## Security / fintech setup notes

- No API keys committed. Use `.env.example` as a template; real `.env` is gitignored.
- Prefer `flutter_secure_storage` for secrets at runtime — not plain env files for PINs/tokens.
- Android: `minSdk = 24`, `usesCleartextTraffic="false"`, `network_security_config` blocks cleartext.
- iOS: `NSFaceIDUsageDescription` placeholder in `Info.plist` for `local_auth`.

## Project layout (current)

```
cbe_mobile_banking/
  lib/main.dart          # Health-check scaffold only
  android/ …             # Package com.cbe.mobilebanking
  ios/ …                 # Bundle com.cbe.mobilebanking
  .env.example
  analysis_options.yaml
  pubspec.yaml
  SETUP.md               # Doctor summary + run checklist
```

## Next step

Clean Architecture **feature-first** folder structure (still no UI screens). See `SETUP.md`.
