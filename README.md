# 🚀 BaseFlutter

> **Production-ready Flutter starter kit** - Firebase, RevenueCat, Dual Analytics, TR/EN Localization ile tam donanımlı base proje.

[![Flutter](https://img.shields.io/badge/Flutter-3.10.7+-blue.svg)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-✓-orange.svg)](https://firebase.google.com)
[![RevenueCat](https://img.shields.io/badge/RevenueCat-✓-purple.svg)](https://revenuecat.com)

---

## 📖 Dokümantasyon

**Detaylı döküman için:** [BASE_PROJECT.md](BASE_PROJECT.md)

Bu dosya şunları içerir:
- ✅ Tüm özelliklerin detaylı açıklaması
- ✅ Mimari ve katman yapısı
- ✅ Kurulum adımları (adım adım)
- ✅ Konfigürasyon rehberi (Firebase, RevenueCat, Analytics)
- ✅ Kullanım örnekleri (kod snippet'leri ile)
- ✅ Yeni proje başlatma checklist'i

---

## ⚡ Hızlı Başlangıç

```bash
# 1. Projeyi klonla
git clone https://github.com/yourusername/baseflutter.git myproject
cd myproject

# 2. Firebase kur
flutterfire configure --project=your-firebase-project

# 3. Bağımlılıkları yükle
flutter pub get
cd ios && pod install && cd ..

# 4. env.dart içinde API key'leri doldur
# lib/config/env.dart

# 5. Çalıştır
flutter run
```

---

## 🎁 Neler Var?

### 🔥 Backend & Auth
- Firebase (Auth, Firestore, Remote Config, Analytics)
- Anonymous Auth (otomatik giriş)
- User management (Firestore documents)

### 💰 Monetization
- RevenueCat entegre (iOS & Android subscriptions)
- User ID senkronizasyonu

### 📊 Analytics
- **Dual System**: Firebase + Custom REST API
- Context-aware events (timezone, local_hour, is_pro, platform)
- Veri kaybı yok (redundancy)

### 🌍 Localization
- TR/EN hazır (Flutter gen-l10n)
- Provider-based dil değiştirme
- Sistem dili otomatik

### 🎨 UI Foundation
- Material 3 design
- Light/Dark theme
- Global constants (padding, radius)
- Reusable widgets

### 🏗️ Mimari
- **Clean Architecture**: UI → Logic → Data katmanları
- Riverpod (state management)
- Test edilebilir yapı

---

## 📁 Klasör Yapısı

```
lib/
├── config/          # API keys, env settings
├── core/            # Theme, colors, constants
├── data/            # Services, models (Firebase, API, Storage)
├── logic/           # Providers, business logic
├── routes/          # Navigation
├── ui/              # Screens & widgets
└── l10n/            # Localization (ARB files)
```

---

## 🔧 Konfigürasyon Gereksinimleri

Yeni proje başlatırken **`lib/config/env.dart`** içinde şunları doldur:

```dart
class Env {
  static const String revenueCatApiKeyApple = 'appl_xxxxx';
  static const String revenueCatApiKeyGoogle = 'goog_xxxxx';
  static const String analyticsAppId = 'yourapp';
  static const String analyticsCustomApiUrl = 'https://...';
}
```

Firebase → `flutterfire configure` ile otomatik.

---

## 📚 Öğren & Kullan

1. **[BASE_PROJECT.md](BASE_PROJECT.md)** - Ana döküman (tüm detaylar)
2. **[.cursor/rules/](/.cursor/rules/baseflutter-standards.mdc)** - Geliştirme kuralları (Cursor AI)
3. **Code Examples** - BASE_PROJECT.md içinde

---

## 🎯 Hedef Kitle

- ✅ Hızlı MVP çıkarmak isteyenler
- ✅ Enterprise-level altyapı arayanlar
- ✅ Temiz mimari ile başlamak isteyenler
- ✅ Firebase + RevenueCat entegrasyonu gerekli olanlar

---

## 🚀 Yeni Proje Başlatma

1. Bu projeyi fork al / klonla
2. Proje adını değiştir (`pubspec.yaml`, bundle ID)
3. Firebase projesi oluştur
4. `env.dart` içinde key'leri doldur
5. `flutter run` 🎉

**Detaylı adımlar:** [BASE_PROJECT.md - Kurulum](BASE_PROJECT.md#-kurulum)

---

## 📈 İstatistikler

- **Satır Sayısı:** ~3000+ (çoğu hazır servis)
- **Ekranlar:** 2 (Splash, Home) - genişletilebilir
- **Servisler:** 10+ (Firebase, Analytics, Auth, Storage, etc.)
- **Test Coverage:** Widget test örneği mevcut
- **Localization:** 2 dil (TR/EN), kolay genişletilebilir

---

## 🤝 Katkı

Bu base proje, gerçek production uygulamalarında kullanılmak üzere hazırlanmıştır.

Öneriler:
- Issue aç (feature request, bug report)
- PR gönder (iyileştirmeler)
- Fork'la ve kendi projende kullan

---

## 📄 Lisans

Serbestçe kullanılabilir. Attribution gerekmez.

---

**Not:** Bu bir **base/starter** projedir. Kendi uygulama mantığınızı bu temel üzerine inşa edin.

**Detaylı rehber:** → [BASE_PROJECT.md](BASE_PROJECT.md) ←

