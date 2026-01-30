# Changelog

Bu dosya, BaseFlutter projesinin tüm önemli değişikliklerini dokümante eder.

Format, [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) standardına uygundur.

---

## [1.0.0] - 2026-01-30

### 🎉 Initial Release - Production Ready

#### ✨ Added

**Core Infrastructure**
- Clean Architecture (UI/Logic/Data katman ayrımı)
- Riverpod state management entegrasyonu
- Environment configuration system (`lib/config/env.dart`)
- Global constants (padding, radius, durations)
- Material 3 theme (Light/Dark mode)

**Firebase Stack**
- Firebase Core initialization
- Firebase Anonymous Auth (otomatik giriş)
- Cloud Firestore (generic CRUD service)
- Firebase Remote Config (feature flags)
- Firebase Analytics

**Authentication & User Management**
- Anonymous auth flow
- User documents in Firestore (createdAt, updatedAt, isAnonymous)
- `UserService` for user CRUD operations
- Auth state provider (Riverpod)

**Monetization**
- RevenueCat SDK integration (iOS & Android)
- User ID synchronization (Firebase uid = RevenueCat appUserID)
- Conditional import for platform-specific API keys

**Analytics System (Dual)**
- Firebase Analytics integration
- Custom REST API logging (Cloud Functions ready)
- Context-aware events:
  - `timezone`, `local_hour` (behavior analysis)
  - `is_pro` (premium segmentation)
  - `platform`, `app_version`, `country` (device metadata)
- Platform metadata in custom API payload
- `logPageView()` and `logButtonClick()` helpers

**Localization (TR/EN)**
- Flutter `gen-l10n` (ARB files)
- Turkish & English translations
- Provider-based locale switching
- System language + manual selection
- Placeholder support (`userIdLabel(id)`)

**Services**
- `FirebaseService` - Firebase initialization
- `AuthService` - Firebase Auth wrapper
- `FirestoreService` - Generic CRUD with batch operations
- `RemoteConfigService` - Feature flags
- `StorageService` - SharedPreferences wrapper
- `ApiService` - Generic HTTP client
- `UserService` - User-specific Firestore operations
- `RevenueCatService` - RevenueCat SDK wrapper
- `AnalyticsService` - Dual analytics (Firebase + Custom)

**UI Components**
- Splash screen (initialization flow with localized status)
- Home screen (user info, remote config display)
- Reusable widgets (`AppButton`, `AppTextField`)
- Navigation system (`AppRoutes`)

**Developer Experience**
- Cursor AI rules (`.cursor/rules/baseflutter-standards.mdc`)
- Flutter linter configuration
- Widget test infrastructure
- Comprehensive documentation (`BASE_PROJECT.md`)

#### 🔧 Configuration

**Environment Variables**
- `revenueCatApiKeyApple` - RevenueCat iOS public key
- `revenueCatApiKeyGoogle` - RevenueCat Android public key
- `analyticsAppId` - Custom analytics app identifier
- `analyticsCustomApiUrl` - Custom analytics endpoint

**Firebase Remote Config Keys**
- `app_in_review` - App Store review mode flag
- `force_update` - Force update requirement
- `maintenance_mode` - Maintenance mode flag
- `ad_enabled` - Ads enabled flag
- `show_ads` - Show ads to user flag
- `min_version` - Minimum required app version
- `privacy_url` - Privacy policy URL
- `terms_url` - Terms of service URL

**Firestore Collections**
- `users` - User documents (id, name, email, isAnonymous, createdAt, updatedAt)

#### 📦 Dependencies

**Core**
- `flutter_riverpod: ^2.6.1` - State management
- `firebase_core: ^3.8.1` - Firebase SDK
- `firebase_analytics: ^11.3.3` - Firebase Analytics
- `firebase_auth: ^5.4.0` - Firebase Authentication
- `cloud_firestore: ^5.6.0` - Cloud Firestore
- `firebase_remote_config: ^5.3.0` - Remote Config
- `purchases_flutter: ^9.10.8` - RevenueCat SDK

**Utilities**
- `http: ^1.2.0` - HTTP client
- `intl: ^0.20.2` - Internationalization
- `package_info_plus: ^8.1.2` - App version info
- `shared_preferences: ^2.3.0` - Local storage

**Localization**
- `flutter_localizations` (SDK) - Flutter localization
- `intl` (via flutter_localizations) - Date/number formatting

#### 🎯 Architecture Decisions

1. **UI/Logic Separation**: UI sadece widget render eder, iş mantığı provider'larda
2. **Localization First**: Tüm UI metinleri ARB dosyalarından gelir
3. **Global Constants**: Magic number yerine Constants sınıfı kullanımı
4. **Analytics Redundancy**: Firebase + Custom API ile veri kaybı önlenir
5. **Context-Aware Events**: Her event kullanıcı context'ini taşır
6. **Anonymous First**: Uygulama açılışta otomatik giriş (friction azaltma)
7. **Provider-Based Locale**: UI'da dil değişimi provider üzerinden
8. **RevenueCat Sync**: RevenueCat user ID = Firebase user ID (consistency)

#### 📚 Documentation

- `README.md` - Hızlı başlangıç ve genel bakış
- `BASE_PROJECT.md` - Detaylı döküman (60+ sayfa)
- `.cursor/rules/baseflutter-standards.mdc` - Geliştirme kuralları
- `CHANGELOG.md` - Versiyon geçmişi (bu dosya)

#### 🚀 Next Steps (Roadmap)

Planlanan özellikler (sonraki versiyonlarda):
- Push Notifications (FCM)
- Deep Linking (Firebase Dynamic Links)
- Crashlytics entegrasyonu
- Social login (Google, Apple)
- Onboarding flow
- A/B testing infrastructure
- Repository pattern
- UseCase pattern
- Unit & integration tests (%80+ coverage)

---

## Semantic Versioning

Bu proje [Semantic Versioning](https://semver.org/) kullanır:

- **MAJOR** (1.x.x): Geriye uyumsuz değişiklikler
- **MINOR** (x.1.x): Geriye uyumlu yeni özellikler
- **PATCH** (x.x.1): Geriye uyumlu bug fix'ler

---

**Not:** Bu bir base/starter projedir. Kendi uygulamanızda kullanırken versiyonu kendi projenize göre ayarlayın.

