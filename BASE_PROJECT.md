# 🚀 BaseFlutter - Enterprise Flutter Starter Kit

> Production-ready Flutter base projesi. Firebase, RevenueCat, Dual Analytics ve çok dilli destek ile tam donanımlı.

**Versiyon:** 1.0.0  
**Minimum SDK:** Flutter 3.10.7+  
**Platform:** iOS 13.0+ / Android  
**Durum:** ✅ Production Ready

---

## 📋 İçindekiler

- [Genel Bakış](#-genel-bakış)
- [Özellikler](#-özellikler)
- [Mimari](#-mimari)
- [Klasör Yapısı](#-klasör-yapısı)
- [Kurulum](#-kurulum)
- [Konfigürasyon](#-konfigürasyon)
- [Kullanım Örnekleri](#-kullanım-örnekleri)
- [Geliştirme Kuralları](#-geliştirme-kuralları)

---

## 🎯 Genel Bakış

BaseFlutter, kurumsal düzeyde Flutter uygulamaları geliştirmek için hazırlanmış bir **starter kit**'tir. Sıfırdan proje başlatmak yerine, bu base üzerinden fork alarak hızlıca üretime geçebilirsiniz.

### Neden BaseFlutter?

- ✅ **%80 Ortak Altyapı**: Firebase, auth, analytics, localization hepsi hazır
- ✅ **Temiz Mimari**: UI/Logic/Data katman ayrımı ile test edilebilir kod
- ✅ **Production Tested**: Gerçek projelerde kullanılan ve test edilmiş servisler
- ✅ **Çok Dilli**: TR/EN hazır, yeni dil eklemek 5 dakika
- ✅ **Analytics Redundancy**: Firebase + Custom API ile veri kaybı yok

---

## 🎁 Özellikler

### 🔐 Authentication & User Management
- **Firebase Anonymous Auth** (otomatik giriş)
- **Firestore User Documents** (createdAt, updatedAt)
- User ID persistence across sessions

### 💰 Monetization
- **RevenueCat Integration**
  - iOS & Android subscriptions
  - User ID senkronizasyonu (Firebase uid = RevenueCat appUserID)
  - Entitlement tracking hazır

### 📊 Dual Analytics System
- **Firebase Analytics** (Google ekosistemi, dashboards)
- **Custom REST API** (Cloud Functions, raw data ownership)
- **Context-Aware Events**:
  - `timezone`, `local_hour` (kullanıcı davranış analizi)
  - `is_pro` (premium/free segmentasyon)
  - `platform`, `app_version`, `country` (cihaz metadata)

### 🌍 Localization (TR/EN)
- Flutter `gen-l10n` (ARB dosyaları)
- Provider-based locale switching
- Sistem dili + manuel seçim
- Placeholder destekli metinler (`userIdLabel(id)`)

### 🔥 Firebase Stack
- **Firebase Core** - App initialization
- **Firestore** - Generic CRUD service (batch operations destekli)
- **Remote Config** - Feature flags, A/B testing
- **Firebase Auth** - Anonymous + extensible

### 🎨 UI/UX Foundation
- **Material 3** design
- Light/Dark theme otomatik
- Localized splash screen
- Global constants (padding, radius, durations)

### 📦 State Management
- **Riverpod** (Flutter Riverpod 2.6.1)
- Provider-based architecture
- Dependency injection hazır

### 🛠️ Developer Experience
- **Cursor AI Rules** (`.cursor/rules/baseflutter-standards.mdc`)
- **Linter** yapılandırması
- **Test infrastructure** (widget test örneği)

---

## 🏗️ Mimari

### Katman Ayrımı

```
┌─────────────────────────────────────┐
│  UI Layer (lib/ui/)                 │
│  - Screens, Widgets                 │
│  - SADECE state dinler, render eder │
└──────────────┬──────────────────────┘
               │ watch/read
┌──────────────▼──────────────────────┐
│  Logic Layer (lib/logic/)           │
│  - Providers, Notifiers             │
│  - Business logic, state management │
└──────────────┬──────────────────────┘
               │ calls
┌──────────────▼──────────────────────┐
│  Data Layer (lib/data/)             │
│  - Services, Models, Repositories   │
│  - Firebase, API, Storage           │
└─────────────────────────────────────┘
```

### Akış Örneği: Anonymous Login

```
1. App Start (main.dart)
   ↓
2. Firebase Init (FirebaseService.init)
   ↓
3. Analytics Init (AnalyticsService.initialize)
   ↓
4. Auth Check (AuthService)
   │ ├─ isLoggedIn? NO → signInAnonymously()
   │ └─ isLoggedIn? YES → continue
   ↓
5. Firestore User Doc (UserService.ensureUserDocument)
   ↓
6. RevenueCat Config (RevenueCatService.configure(uid))
   ↓
7. Analytics User Update (AnalyticsService.updateUserData)
   ↓
8. Navigate to Home ✅
```

---

## 📁 Klasör Yapısı

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # MaterialApp + routing
│
├── config/                            # Konfigürasyon
│   ├── env.dart                       # API keys, URLs
│   ├── collections.dart               # Firestore collection names
│   └── remote_keys.dart               # Remote config keys
│
├── core/                              # Ortak UI kaynakları
│   ├── colors.dart                    # Renk paleti
│   ├── constants.dart                 # Padding, radius, durations
│   └── theme.dart                     # Light/Dark theme
│
├── data/                              # Data Layer
│   ├── models/
│   │   └── user_model.dart            # User entity (Firestore)
│   └── services/
│       ├── analytics_service.dart     # Dual analytics
│       ├── api_service.dart           # Generic HTTP client
│       ├── auth_service.dart          # Firebase Auth wrapper
│       ├── firebase_service.dart      # Firebase init
│       ├── firestore_service.dart     # Generic CRUD
│       ├── remote_config_service.dart # Feature flags
│       ├── revenuecat_service.dart    # RevenueCat SDK
│       ├── storage_service.dart       # SharedPreferences
│       └── user_service.dart          # User Firestore operations
│
├── logic/                             # Business Logic
│   ├── init_logic.dart                # App initialization state
│   └── providers/
│       ├── auth_provider.dart         # Auth state
│       ├── locale_provider.dart       # Language switching
│       ├── remote_config_provider.dart
│       └── providers.dart             # Export all
│
├── routes/
│   └── app_routes.dart                # Route definitions
│
├── ui/                                # UI Layer
│   ├── screens/
│   │   ├── splash_screen.dart         # Initialization screen
│   │   └── home_screen.dart           # Main screen
│   └── widgets/
│       ├── app_button.dart            # Reusable button
│       └── app_text_field.dart        # Reusable text field
│
└── l10n/                              # Localization (Generated)
    ├── app_en.arb                     # English strings
    ├── app_tr.arb                     # Turkish strings
    └── app_localizations.dart         # Generated code
```

---

## ⚙️ Kurulum

### 1. Projeyi Klonla / Fork Al

```bash
git clone https://github.com/yourusername/baseflutter.git myproject
cd myproject
```

### 2. Proje Adını Değiştir

**pubspec.yaml:**
```yaml
name: myproject
description: "My Amazing App"
```

**android/app/build.gradle.kts:**
```kotlin
namespace = "com.mycompany.myproject"
applicationId = "com.mycompany.myproject"
```

**ios/Runner.xcodeproj:** Bundle ID'yi Xcode'dan değiştir.

### 3. Firebase Kurulumu

```bash
# FlutterFire CLI ile
flutterfire configure --project=your-firebase-project-id

# Firebase'i iOS için manuel (eğer gerekirse)
# 1. Firebase Console'dan iOS app ekle
# 2. GoogleService-Info.plist indir
# 3. ios/Runner/ klasörüne kopyala
```

### 4. Bağımlılıkları Yükle

```bash
flutter pub get
cd ios && pod install && cd ..
```

### 5. Env Ayarları

**`lib/config/env.dart`** içinde şunları doldur:

```dart
class Env {
  static const String appName = 'MyProject';
  static const String baseUrl = 'https://api.myproject.com';
  
  // RevenueCat (dashboard → API Keys)
  static const String revenueCatApiKeyApple = 'appl_xxxxx';
  static const String revenueCatApiKeyGoogle = 'goog_xxxxx';
  
  // Analytics
  static const String analyticsAppId = 'myproject';
  static const String analyticsCustomApiUrl = 'https://us-central1-xxx.cloudfunctions.net/addEvent';
}
```

### 6. Çalıştır

```bash
flutter run
```

---

## 🔧 Konfigürasyon

### Firebase Remote Config

**`lib/config/remote_keys.dart`** içinde key'leri tanımla, Firebase Console'da değerleri set et:

```dart
class RemoteKeys {
  static const String appInReview = 'app_in_review';
  static const String forceUpdate = 'force_update';
  static const String minVersion = 'min_version';
  // ...
}
```

### RevenueCat

1. RevenueCat Dashboard → Apps → Create iOS/Android App
2. Products, Offerings, Entitlements oluştur
3. API Keys → Public keys'i `env.dart`'a kopyala

### Custom Analytics API

Cloud Function örneği (Firebase):

```javascript
exports.addEvent = functions.https.onRequest(async (req, res) => {
  const event = req.body;
  await admin.firestore().collection('events').add(event);
  res.json({ success: true });
});
```

URL'i `Env.analyticsCustomApiUrl`'e yaz.

---

## 💡 Kullanım Örnekleri

### Yeni Ekran Eklemek

**1. Screen oluştur** (`lib/ui/screens/profile_screen.dart`):

```dart
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService().logPageView('profile');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // UI...
  }
}
```

**2. Route ekle** (`lib/routes/app_routes.dart`):

```dart
class AppRoutes {
  static const String profile = '/profile';
  // ...

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      // ...
    }
  }
}
```

**3. Localization ekle** (`lib/l10n/app_en.arb`):

```json
{
  "profileTitle": "Profile",
  "editProfile": "Edit Profile"
}
```

```bash
flutter gen-l10n  # ARB'den Dart code üret
```

### Event Loglama

```dart
// Sayfa görüntüleme
AnalyticsService().logPageView('paywall');

// Buton tıklama
AnalyticsService().logButtonClick(
  'subscribe',
  pageName: 'paywall',
  extras: {'plan': 'monthly', 'price': 9.99}
);

// Custom event
AnalyticsService().log('feature_used', {
  'feature_name': 'ai_assistant',
  'usage_count': 5
});
```

### Premium Kontrolü

```dart
// RevenueCat entitlement kontrolü
final customerInfo = await Purchases.getCustomerInfo();
final isPro = customerInfo.entitlements.active.containsKey('pro');

// Analytics'e bildir
AnalyticsService().updateUserData(isPremium: isPro);

// UI'da kullan
if (isPro) {
  // Premium özellik
}
```

### Firestore CRUD

```dart
// User service kullan
final user = await UserService().getUser(uid);

// Generic service kullan
final firestoreService = FirestoreService();

// Create
await firestoreService.set('posts', postId, {
  'title': 'Hello',
  'content': 'World',
  'userId': uid,
});

// Read
final post = await firestoreService.get('posts', postId);

// Update
await firestoreService.update('posts', postId, {
  'views': FieldValue.increment(1),
});

// Stream
firestoreService.streamDoc('posts', postId).listen((data) {
  print(data);
});
```

---

## 📜 Geliştirme Kuralları

> ⚠️ **Önemli**: `.cursor/rules/baseflutter-standards.mdc` dosyası Cursor AI'ya otomatik hatırlatıcı olarak verilir. Manuel olarak da referans alın.

### 1. UI/Logic Ayrımı

❌ **YANLIŞ:**
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ UI içinde API çağrısı
    final response = await http.get('...');
    return Text(response.body);
  }
}
```

✅ **DOĞRU:**
```dart
// Logic layer
class DataProvider extends StateNotifier<DataState> {
  Future<void> loadData() async {
    final response = await ApiService().getData();
    state = state.copyWith(data: response);
  }
}

// UI layer
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);
    return Text(data.value);
  }
}
```

### 2. Localization Zorunluluğu

❌ **YANLIŞ:**
```dart
Text('Welcome to app');  // Hard-coded string
```

✅ **DOĞRU:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcomeMessage);
```

### 3. Global Constants

❌ **YANLIŞ:**
```dart
padding: EdgeInsets.all(16),  // Magic number
borderRadius: BorderRadius.circular(8),
```

✅ **DOĞRU:**
```dart
padding: EdgeInsets.all(Constants.paddingM),
borderRadius: BorderRadius.circular(Constants.radiusM),
```

### 4. Analytics Her Yerde

```dart
// Her ekranda
@override
void initState() {
  super.initState();
  AnalyticsService().logPageView('screen_name');
}

// Önemli aksiyonlarda
onPressed: () {
  AnalyticsService().logButtonClick('action_name');
  // İşlem...
}
```

---

## 🚢 Yeni Proje Başlatma Checklist

- [ ] Projeyi fork al / klonla
- [ ] Proje adını değiştir (pubspec, bundle ID)
- [ ] Firebase projesi oluştur, `flutterfire configure` çalıştır
- [ ] `env.dart` içinde API key'leri doldur
- [ ] RevenueCat dashboard → Apps oluştur, key'leri ekle
- [ ] Custom analytics API deploy et (opsiyonel)
- [ ] App icon & splash screen değiştir
- [ ] `l10n/*.arb` dosyalarında uygulama adını güncelle
- [ ] Firebase Remote Config'de ilk değerleri set et
- [ ] `flutter run` ile test et
- [ ] CI/CD pipeline kur (GitHub Actions, Codemagic, vb.)

---

## 📈 Sonraki Adımlar

### Eklenebilecek Özellikler

- [ ] **Push Notifications** (Firebase Cloud Messaging)
- [ ] **Deep Linking** (Firebase Dynamic Links / Branch.io)
- [ ] **Crashlytics** (Firebase Crashlytics)
- [ ] **A/B Testing** (Firebase Remote Config + Custom Variants)
- [ ] **Social Login** (Google, Apple, Email/Password)
- [ ] **App Review Prompt** (in_app_review package)
- [ ] **Onboarding Flow** (intro_slider + SharedPreferences)
- [ ] **Image Caching** (cached_network_image)
- [ ] **Offline Support** (Hive / Drift)

### Mimari İyileştirmeler

- [ ] **Repository Pattern** (data layer'da abstraction)
- [ ] **UseCase Pattern** (business logic izolasyonu)
- [ ] **Dependency Injection** (get_it / riverpod_generator)
- [ ] **Error Handling** (Result<T, E> pattern)
- [ ] **Unit Tests** (logic layer coverage %80+)
- [ ] **Integration Tests** (critical flows)

---

## 🤝 Katkı & Destek

Bu base proje, gerçek production uygulamalarında kullanılmak üzere hazırlanmıştır. Öneriler ve iyileştirmeler için issue açabilir veya PR gönderebilirsiniz.

---

## 📄 Lisans

Bu base proje, kendi projelerinizde serbestçe kullanılabilir. Attribution gerekmez.

---

**Hazırlayan:** BaseFlutter Team  
**Son Güncelleme:** 2026-01-30  
**Versiyon:** 1.0.0

