# BaseFlutter - Yeni Uygulama Oluşturma Rehberi

Bu rehber, BaseFlutter projesini kullanarak yeni bir uygulama oluşturmanızı adım adım anlatır.

## Hızlı Başlangıç

### 1. Projeyi Kopyalayın

```bash
# Base projeyi kopyala
cp -r baseflutter mynewapp
cd mynewapp

# Git geçmişini temizle (opsiyonel)
rm -rf .git
git init
```

### 2. Setup Script'ini Çalıştırın

```bash
./scripts/setup_new_app.sh <package_name> <app_name> <display_name>
```

**Örnek:**
```bash
./scripts/setup_new_app.sh com.mycompany.todoapp todo_app "Todo App"
```

**Parametreler:**

| Parametre | Açıklama | Örnek |
|-----------|----------|-------|
| `package_name` | Android package name / iOS bundle identifier | `com.mycompany.todoapp` |
| `app_name` | Dart package adı (küçük harf, underscore) | `todo_app` |
| `display_name` | Kullanıcının göreceği uygulama adı | `"Todo App"` |

### 3. Firebase'i Yapılandırın

```bash
# FlutterFire CLI kurulu değilse
dart pub global activate flutterfire_cli

# Firebase'e giriş yapın
firebase login

# Yapılandırın (yeni proje oluşturacak veya var olan seçecek)
flutterfire configure
```

Bu komut şunları yapacak:
- Firebase Console'da proje seçmenizi/oluşturmanızı sağlayacak
- `google-services.json` (Android) dosyasını güncelleyecek
- `GoogleService-Info.plist` (iOS) dosyasını güncelleyecek
- `lib/firebase_options.dart` dosyasını oluşturacak

### 4. Firebase Servislerini Aktifleştirin

Firebase Console'da şu servisleri aktifleştirin:

1. **Authentication**
   - Sign-in method → Anonymous → Enable

2. **Cloud Firestore**
   - Create database → Start in test mode

3. **Remote Config**
   - Create configuration

4. **Analytics**
   - Otomatik aktif

### 5. iOS Pod'larını Güncelleyin

```bash
cd ios
pod install
cd ..
```

### 6. Uygulamayı Çalıştırın

```bash
flutter run
```

---

## Script Ne Yapar?

Setup script'i (`scripts/setup_new_app.sh`) şu değişiklikleri otomatik yapar:

### Android
- `android/app/build.gradle.kts` → namespace ve applicationId
- `android/app/src/main/AndroidManifest.xml` → package ve label
- `android/app/src/main/kotlin/.../MainActivity.kt` → package ve klasör yapısı

### iOS
- `ios/Runner.xcodeproj/project.pbxproj` → PRODUCT_BUNDLE_IDENTIFIER
- `ios/Runner/Info.plist` → CFBundleDisplayName ve CFBundleName

### Dart
- `pubspec.yaml` → name
- Tüm `lib/*.dart` dosyalarındaki import'lar
- `lib/l10n/app_*.arb` → appTitle

### Firebase (Bağlantı Koparılır)
- `android/app/google-services.json` → Placeholder değerler
- `ios/Runner/GoogleService-Info.plist` → Placeholder değerler
- `lib/firebase_options.dart` → Placeholder değerler
- `firebase.json` → Temizlenir

---

## Manuel Yapılması Gerekenler

Script sonrası manuel kontrol/değişiklik gerektiren yerler:

### 1. RevenueCat (Opsiyonel)
Eğer RevenueCat kullanacaksanız:

```dart
// lib/data/services/revenuecat_api_key_io.dart
const String revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY';
```

### 2. Remote Config Değerleri
Firebase Console'da Remote Config değerlerini ayarlayın:

```
air (bool)     → false (App In Review)
fu (bool)      → false (Force Update)
mm (bool)      → false (Maintenance Mode)
ae (bool)      → true  (Ad Enabled)
mv (string)    → "1.0.0" (Min Version)
pu (string)    → "https://..." (Privacy URL)
tu (string)    → "https://..." (Terms URL)
```

### 3. Uygulama İkonları
- Android: `android/app/src/main/res/mipmap-*/`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### 4. Splash Screen
- Android: `android/app/src/main/res/drawable/launch_background.xml`
- iOS: `ios/Runner/Base.lproj/LaunchScreen.storyboard`

---

## Proje Yapısı

```
lib/
├── app.dart                 # Ana MaterialApp widget
├── main.dart                # Entry point
├── firebase_options.dart    # Firebase yapılandırması
├── config/
│   ├── collections.dart     # Firestore collection isimleri
│   ├── env.dart             # Environment değişkenleri
│   └── remote_keys.dart     # Remote Config key'leri
├── core/
│   ├── colors.dart          # Renk tanımları
│   ├── constants.dart       # Sabitler (padding, radius, vb.)
│   └── theme.dart           # Tema tanımları
├── data/
│   ├── models/              # Veri modelleri
│   └── services/            # API, Firebase, Storage servisleri
├── l10n/                    # Localization dosyaları
├── logic/
│   ├── init_logic.dart      # Başlatma mantığı
│   └── providers/           # Riverpod provider'lar
├── routes/
│   └── app_routes.dart      # Route tanımları
└── ui/
    ├── screens/             # Ekranlar
    └── widgets/             # Ortak widget'lar
```

---

## Time Slot Sistemi

BaseFlutter, zaman tabanlı içerik yönetimi için Time Slot sistemi içerir.

### Remote Config Key'leri

Her slot için 4 key vardır (toplam 9 slot × 4 = 36 key):

| Key | Açılım | Örnek |
|-----|--------|-------|
| `st1` | startTime1 | `1100` (11:00) |
| `et1` | endTime1 | `1200` (12:00) |
| `st1t` | startTime1Type | `"promo"` |
| `st1p` | startTime1Package | `"banner1"` |

### Kullanım

```dart
// Provider'dan aktif slot'ları al
final state = ref.watch(timeSlotProvider);

// Belirli bir type aktif mi?
if (state.isTypeActive('promo')) {
  // Promo göster
}

// Aktif slot'un package'ını al
final slot = state.getActiveSlotByType('promo');
if (slot != null) {
  print(slot.package); // "banner1"
}
```

### Gece Geçişi

`st1=2300, et1=0600` → 23:00-06:00 arası aktif (gece geçişi desteklenir)

---

## Sık Sorulan Sorular

### Q: Script hata verdi, ne yapmalıyım?
A: Script'i proje kök dizininde çalıştırdığınızdan emin olun (`pubspec.yaml` ile aynı klasör).

### Q: Firebase bağlantısı çalışmıyor
A: `flutterfire configure` komutunu çalıştırıp Firebase Console'da servisleri aktifleştirdiğinizden emin olun.

### Q: iOS build hatası alıyorum
A: `cd ios && pod install && cd ..` komutunu çalıştırın.

### Q: Package name nasıl olmalı?
A: Reverse domain notation: `com.sirketadi.uygulamaadi` formatında olmalı.

---

## Destek

Sorunlar için GitHub Issues kullanın veya dökümantasyonu kontrol edin.
