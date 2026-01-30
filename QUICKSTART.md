# ⚡ QuickStart - Yeni Proje Başlatma

> Bu dosya, BaseFlutter üzerinden **5 dakikada** yeni proje başlatma rehberidir.

**Hedef:** BaseFlutter'ı fork/clone alıp kendi projenizi hızlıca çalıştırmak.

---

## 🎯 Ön Gereksinimler

- ✅ Flutter SDK (3.10.7+)
- ✅ Firebase account (ücretsiz)
- ✅ RevenueCat account (opsiyonel, subscription'lar için)
- ✅ Code editor (VS Code, Android Studio, veya Cursor)

---

## 📝 Adım Adım (5 Dakika)

### 1️⃣ Projeyi Klonla (30 saniye)

```bash
git clone https://github.com/yourusername/baseflutter.git myawesomeapp
cd myawesomeapp

# Git geçmişini temizle (opsiyonel)
rm -rf .git
git init
git add .
git commit -m "Initial commit from BaseFlutter"
```

---

### 2️⃣ Proje Adını Değiştir (1 dakika)

**A) pubspec.yaml**
```yaml
name: myawesomeapp  # ← Değiştir
description: "My Awesome Application"
```

**B) Android**
```bash
# android/app/build.gradle.kts
namespace = "com.mycompany.myawesomeapp"
applicationId = "com.mycompany.myawesomeapp"
```

**C) iOS (Xcode'da)**
1. `ios/Runner.xcworkspace` aç
2. Runner → General → Bundle Identifier değiştir
3. Display Name değiştir

---

### 3️⃣ Firebase Kur (1 dakika)

**Otomatik (Önerilen):**
```bash
# Firebase CLI yüklü değilse:
npm install -g firebase-tools
firebase login

# FlutterFire CLI:
dart pub global activate flutterfire_cli

# Projeyi Firebase'e bağla:
flutterfire configure --project=your-firebase-project-id
```

**Manuel (eğer CLI çalışmazsa):**
1. Firebase Console → Add Project
2. iOS app ekle → `GoogleService-Info.plist` indir → `ios/Runner/` kopyala
3. Android app ekle → `google-services.json` indir → `android/app/` kopyala

**Firebase'de Aktif Et:**
- Authentication → Anonymous auth'u enable et
- Firestore → Database oluştur (test mode)
- Remote Config → Parametreleri ekle (app_in_review, force_update, vs.)

---

### 4️⃣ Bağımlılıkları Yükle (1 dakika)

```bash
flutter pub get

# iOS pods (Mac'te):
cd ios
pod install
cd ..
```

---

### 5️⃣ Env Ayarları (1 dakika)

**`lib/config/env.dart`** dosyasını aç:

```dart
class Env {
  static const String appName = 'MyAwesomeApp';  // ← Değiştir
  static const String baseUrl = 'https://api.myapp.com';  // ← API'n varsa
  static const bool isProduction = false;

  // RevenueCat (şimdilik boş bırakabilirsin)
  static const String revenueCatApiKeyApple = '';
  static const String revenueCatApiKeyGoogle = '';

  // Analytics (custom API yoksa boş bırak)
  static const String analyticsAppId = 'myawesomeapp';
  static const String analyticsCustomApiUrl = '';
}
```

---

### 6️⃣ Localization Güncelle (30 saniye)

**`lib/l10n/app_en.arb`** ve **`lib/l10n/app_tr.arb`** içinde app adını değiştir:

```json
{
  "appTitle": "MyAwesomeApp"
}
```

Sonra:
```bash
flutter gen-l10n
```

---

### 7️⃣ Çalıştır! 🚀 (30 saniye)

```bash
flutter run
```

veya IDE'nden **Run** butonuna bas.

**İlk açılış:**
1. Splash screen göreceksin (Firebase bağlanıyor)
2. Anonymous auth oluşturulacak
3. Home screen açılacak ✅

---

## ✅ Başarılı Kurulum Kontrolü

Eğer şunları görüyorsan, her şey çalışıyor demektir:

- [x] Splash screen açıldı
- [x] Firebase bağlandı (hata yok)
- [x] Home screen'de "Welcome to MyAwesomeApp" yazıyor
- [x] User ID görünüyor (anonim kullanıcı oluştu)
- [x] Remote Config değerleri gösteriliyor

---

## 🔧 Opsiyonel Konfigürasyonlar

### RevenueCat (Subscription'lar için)

1. [RevenueCat](https://www.revenuecat.com) hesap aç
2. Dashboard → Apps → Create iOS/Android App
3. Products, Offerings, Entitlements oluştur
4. API Keys → Public Apple/Google key'leri kopyala
5. `env.dart` içinde key'leri yapıştır

### Custom Analytics API

Cloud Function deploy et (örnek):

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.addEvent = functions.https.onRequest(async (req, res) => {
  const event = req.body;
  await admin.firestore().collection('analytics_events').add({
    ...event,
    serverTimestamp: admin.firestore.FieldValue.serverTimestamp()
  });
  res.json({ success: true });
});
```

Deploy:
```bash
firebase deploy --only functions
```

URL'i `Env.analyticsCustomApiUrl`'e kopyala.

---

## 🚨 Sık Karşılaşılan Hatalar

### 1. Firebase Bağlanamıyor

**Hata:** `Firebase app not initialized`

**Çözüm:**
```bash
flutterfire configure
flutter clean && flutter pub get
```

### 2. iOS Pods Hatası

**Hata:** `CocoaPods specs out of date`

**Çözüm:**
```bash
cd ios
pod repo update
pod install
cd ..
```

### 3. Localization Generate Edilmedi

**Hata:** `AppLocalizations not found`

**Çözüm:**
```bash
flutter gen-l10n
flutter pub get
```

### 4. Android Build Hatası

**Hata:** `Duplicate class`

**Çözüm:**
```bash
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
```

---

## 📚 Sonraki Adımlar

1. **[BASE_PROJECT.md](BASE_PROJECT.md)** oku - detaylı döküman
2. İlk feature'ını ekle (yeni ekran, yeni servis)
3. Firebase Remote Config'de feature flag'lerini ayarla
4. RevenueCat'te subscription plan'larını oluştur
5. Analytics dashboard'unu incele (Firebase Console)

---

## 🎓 Öğrenme Kaynakları

- **Mimari:** [BASE_PROJECT.md - Mimari](BASE_PROJECT.md#-mimari)
- **Kullanım:** [BASE_PROJECT.md - Kullanım Örnekleri](BASE_PROJECT.md#-kullanım-örnekleri)
- **Kurallar:** [.cursor/rules/baseflutter-standards.mdc](.cursor/rules/baseflutter-standards.mdc)

---

## 💬 Yardım

Takıldıysan:
1. **BASE_PROJECT.md** içinde ara (Ctrl+F)
2. Firebase Console'da error log'larını kontrol et
3. `flutter doctor` çalıştır
4. Issue aç (GitHub)

---

**Tebrikler!** 🎉 BaseFlutter artık senin projen. Şimdi kendi feature'larını ekleyebilirsin.

**Mutlu kodlamalar!** 🚀

