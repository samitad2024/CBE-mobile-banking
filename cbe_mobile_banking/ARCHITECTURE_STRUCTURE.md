# Architecture Structure — CBE Mobile Banking

Clean Architecture + feature-first modules inferred from `CBE APP REDESIGNED.pdf`.  
Mock-first; no pixel-perfect screens in this step (Auth is the sample vertical slice).

## Dependency rule

```
Presentation → Domain ← Data
```

- **Domain:** pure Dart (entities, repository interfaces, use cases). No Flutter UI, Dio, or storage SDKs.
- **Data:** models, mock/remote/local sources, repository impls, mappers. Implements domain contracts.
- **Presentation:** pages, widgets, blocs. Calls use cases only (via DI).

## Folder tree

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── di/injection.dart
│   └── router/app_router.dart
├── core/
│   ├── constants/app_constants.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── interceptors/logging_interceptor.dart
│   ├── security/
│   │   ├── biometric_gateway.dart (+ impl + mock)
│   │   ├── secure_storage_gateway.dart (+ impl + in-memory)
│   │   ├── session_manager.dart
│   │   └── secure_config.dart
│   ├── theme/
│   │   ├── app_colors.dart          # plum / peach from PDF
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── app_logger.dart          # no PIN/token/full account logs
│   │   ├── account_masker.dart
│   │   ├── money_formatter.dart
│   │   └── app_validators.dart
│   └── widgets/
│       ├── app_primary_button.dart
│       └── feature_placeholder_page.dart
└── features/                        # PDF-mapped only
    ├── auth/                        # FULL sample slice (login PIN + biometrics)
    │   ├── data/  (models, datasources, mappers, repositories)
    │   ├── domain/(entities, repositories, usecases)
    │   └── presentation/(bloc, pages, widgets)
    ├── home/                        # Dashboard (p2) — stub + layer folders
    ├── transfer/                    # Bank/Payment/Wallet (p3–7) — stub
    ├── request_money/               # Receive QR/Account (p8–9) — stub
    ├── scan/                        # Bottom-nav Scan — stub
    ├── transactions/                # History + receipt (p10–11) — stub
    ├── wallet/                      # Bottom-nav Wallet — stub
    └── settings/                    # Bottom-nav Settings — stub

test/
└── features/auth/
    ├── domain/login_with_pin_usecase_test.dart
    └── presentation/auth_bloc_test.dart
```

## Layers (1–2 lines each)

| Area | Role |
|------|------|
| `app/` | App widget, GetIt DI, go_router route table |
| `core/error` | `Failure` (domain) + `Exception` (data) types |
| `core/network` | Dio wrapper + safe logging interceptor |
| `core/security` | Secure storage, biometrics, mock session abstractions |
| `core/theme` | PDF plum/peach tokens + dark `ThemeData` |
| `core/utils` | Logger, ETB money format, account masking, validators |
| `core/widgets` | Shared UI kit starters |
| `features/*` | Modular vertical slices; Auth is the reference implementation |

## PDF → features mapping

| PDF | Feature module |
|-----|----------------|
| Login PIN + fingerprint | `auth` |
| Dashboard, Transfer Again, services | `home` |
| Transfer Bank/Payment/Wallet + confirm + success | `transfer` |
| Request / receive QR + account | `request_money` |
| Scan QR (nav + sheet) | `scan` |
| Transactions list + receipt | `transactions` |
| Bottom nav Wallet / Settings | `wallet`, `settings` (stubs only) |

**Not created** (not shown as screens in the PDF): onboarding, cards, bill-pay mega-module, support, notifications hub, beneficiaries as a separate module (recent recipients stay under home/transfer).

## Sample slice: Auth (+ system-wide BLoC)

Every PDF feature now has a dedicated `*Bloc` registered in GetIt as a **factory**, provided at page level via `BlocProvider`.

- Domain: `SessionEntity`, `AuthRepository`, `LoginWithPinUseCase`, `LoginWithBiometricsUseCase`
- Data: `AuthMockDataSource` (PIN `1234`), `AuthRepositoryImpl`, `SessionMapper`
- Presentation: `AuthBloc` + `LoginPage`
- Global: `AppBlocObserver` (no secret logging)

## Routes

`/` login · `/home` · `/transfer` · `/request` · `/scan` · `/transactions` · `/wallet` · `/settings`

## Next

Implement Home dashboard UI from the PDF, then Transfer flow — still mock repositories.
