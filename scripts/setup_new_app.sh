#!/bin/bash

# =============================================================================
# BaseFlutter - Yeni Uygulama Kurulum Script'i
# =============================================================================
# Bu script base projeyi yeni bir uygulamaya dönüştürür:
# - Package name değiştirir (Android & iOS)
# - Uygulama adını değiştirir
# - Firebase bağlantısını koparır
# =============================================================================

set -e

# Renkli output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Banner
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         BaseFlutter - Yeni Uygulama Kurulumu              ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Proje kök dizininde miyiz kontrol et
if [ ! -f "pubspec.yaml" ]; then
    print_error "Bu script proje kök dizininde çalıştırılmalı!"
    exit 1
fi

# Parametreleri al
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Kullanım: ./scripts/setup_new_app.sh <package_name> <app_name> <app_display_name>"
    echo ""
    echo "Örnek:"
    echo "  ./scripts/setup_new_app.sh com.mycompany.myapp myapp \"My Awesome App\""
    echo ""
    echo "Parametreler:"
    echo "  package_name     - Android package name / iOS bundle identifier (örn: com.company.app)"
    echo "  app_name         - Dart package name, küçük harf ve underscore (örn: my_app)"
    echo "  app_display_name - Kullanıcının göreceği uygulama adı (örn: \"My App\")"
    exit 1
fi

PACKAGE_NAME=$1
APP_NAME=$2
APP_DISPLAY_NAME=$3

# Mevcut değerler
OLD_PACKAGE_NAME="com.base.base"
OLD_APP_NAME="base"

echo "Yapılacak değişiklikler:"
echo "  Package Name: $OLD_PACKAGE_NAME → $PACKAGE_NAME"
echo "  App Name: $OLD_APP_NAME → $APP_NAME"
echo "  Display Name: Base → $APP_DISPLAY_NAME"
echo ""

read -p "Devam etmek istiyor musunuz? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "İptal edildi."
    exit 0
fi

echo ""

# =============================================================================
# 1. PUBSPEC.YAML
# =============================================================================
print_step "pubspec.yaml güncelleniyor..."

sed -i '' "s/^name: $OLD_APP_NAME$/name: $APP_NAME/" pubspec.yaml

print_success "pubspec.yaml güncellendi"

# =============================================================================
# 2. ANDROID
# =============================================================================
print_step "Android dosyaları güncelleniyor..."

# build.gradle.kts - namespace ve applicationId
sed -i '' "s/namespace = \"$OLD_PACKAGE_NAME\"/namespace = \"$PACKAGE_NAME\"/" android/app/build.gradle.kts
sed -i '' "s/applicationId = \"$OLD_PACKAGE_NAME\"/applicationId = \"$PACKAGE_NAME\"/" android/app/build.gradle.kts

# AndroidManifest.xml - package ve label
sed -i '' "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/main/AndroidManifest.xml
sed -i '' "s/android:label=\"[^\"]*\"/android:label=\"$APP_DISPLAY_NAME\"/" android/app/src/main/AndroidManifest.xml

sed -i '' "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/debug/AndroidManifest.xml 2>/dev/null || true
sed -i '' "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/profile/AndroidManifest.xml 2>/dev/null || true

# Kotlin klasör yapısını değiştir
OLD_PACKAGE_PATH=$(echo $OLD_PACKAGE_NAME | tr '.' '/')
NEW_PACKAGE_PATH=$(echo $PACKAGE_NAME | tr '.' '/')

if [ -d "android/app/src/main/kotlin/$OLD_PACKAGE_PATH" ]; then
    mkdir -p "android/app/src/main/kotlin/$NEW_PACKAGE_PATH"
    
    # MainActivity.kt'yi taşı ve package'ı güncelle
    if [ -f "android/app/src/main/kotlin/$OLD_PACKAGE_PATH/MainActivity.kt" ]; then
        sed "s/package $OLD_PACKAGE_NAME/package $PACKAGE_NAME/" \
            "android/app/src/main/kotlin/$OLD_PACKAGE_PATH/MainActivity.kt" \
            > "android/app/src/main/kotlin/$NEW_PACKAGE_PATH/MainActivity.kt"
        
        # Eski klasörleri sil
        rm -rf "android/app/src/main/kotlin/com/base"
    fi
fi

print_success "Android dosyaları güncellendi"

# =============================================================================
# 3. iOS
# =============================================================================
print_step "iOS dosyaları güncelleniyor..."

# project.pbxproj - PRODUCT_BUNDLE_IDENTIFIER
sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE_NAME/PRODUCT_BUNDLE_IDENTIFIER = $PACKAGE_NAME/g" ios/Runner.xcodeproj/project.pbxproj

# Info.plist - CFBundleDisplayName ve CFBundleName
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $APP_DISPLAY_NAME" ios/Runner/Info.plist 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string $APP_DISPLAY_NAME" ios/Runner/Info.plist

/usr/libexec/PlistBuddy -c "Set :CFBundleName $APP_DISPLAY_NAME" ios/Runner/Info.plist

print_success "iOS dosyaları güncellendi"

# =============================================================================
# 4. DART IMPORTS
# =============================================================================
print_step "Dart import'ları güncelleniyor..."

# Tüm dart dosyalarındaki import'ları güncelle
find lib -name "*.dart" -type f -exec sed -i '' "s/package:$OLD_APP_NAME\//package:$APP_NAME\//g" {} \;
find test -name "*.dart" -type f -exec sed -i '' "s/package:$OLD_APP_NAME\//package:$APP_NAME\//g" {} \; 2>/dev/null || true

print_success "Dart import'ları güncellendi"

# =============================================================================
# 5. FIREBASE BAĞLANTISINI KOPAR
# =============================================================================
print_step "Firebase bağlantısı koparılıyor..."

# google-services.json'u temizle
cat > android/app/google-services.json << 'EOF'
{
  "project_info": {
    "project_number": "000000000000",
    "project_id": "your-project-id",
    "storage_bucket": "your-project-id.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:000000000000:android:0000000000000000000000",
        "android_client_info": {
          "package_name": "PACKAGE_NAME_PLACEHOLDER"
        }
      },
      "api_key": [
        {
          "current_key": "YOUR_API_KEY_HERE"
        }
      ]
    }
  ],
  "configuration_version": "1"
}
EOF
sed -i '' "s/PACKAGE_NAME_PLACEHOLDER/$PACKAGE_NAME/" android/app/google-services.json

# GoogleService-Info.plist'i temizle
cat > ios/Runner/GoogleService-Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_KEY</key>
    <string>YOUR_API_KEY_HERE</string>
    <key>GCM_SENDER_ID</key>
    <string>000000000000</string>
    <key>PLIST_VERSION</key>
    <string>1</string>
    <key>BUNDLE_ID</key>
    <string>BUNDLE_ID_PLACEHOLDER</string>
    <key>PROJECT_ID</key>
    <string>your-project-id</string>
    <key>STORAGE_BUCKET</key>
    <string>your-project-id.appspot.com</string>
    <key>IS_ADS_ENABLED</key>
    <false/>
    <key>IS_ANALYTICS_ENABLED</key>
    <false/>
    <key>IS_APPINVITE_ENABLED</key>
    <true/>
    <key>IS_GCM_ENABLED</key>
    <true/>
    <key>IS_SIGNIN_ENABLED</key>
    <true/>
    <key>GOOGLE_APP_ID</key>
    <string>1:000000000000:ios:0000000000000000000000</string>
</dict>
</plist>
EOF
sed -i '' "s/BUNDLE_ID_PLACEHOLDER/$PACKAGE_NAME/" ios/Runner/GoogleService-Info.plist

# firebase_options.dart'ı temizle
cat > lib/firebase_options.dart << 'EOF'
// ============================================================================
// FIREBASE YAPILANDIRMASI GEREKLİ
// ============================================================================
// Bu dosya Firebase CLI ile otomatik oluşturulmalıdır.
//
// Kurulum:
// 1. Firebase CLI'yi yükleyin: npm install -g firebase-tools
// 2. FlutterFire CLI'yi yükleyin: dart pub global activate flutterfire_cli
// 3. Firebase'e giriş yapın: firebase login
// 4. Yapılandırın: flutterfire configure
//
// Bu komut firebase_options.dart dosyasını otomatik oluşturacaktır.
// ============================================================================

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web için Firebase yapılandırması yapılmamış.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS için Firebase yapılandırması yapılmamış.');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows için Firebase yapılandırması yapılmamış.');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux için Firebase yapılandırması yapılmamış.');
      default:
        throw UnsupportedError('Bu platform desteklenmiyor.');
    }
  }

  // TODO: flutterfire configure çalıştırarak bu değerleri güncelleyin
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: '1:000000000000:android:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );

  // TODO: flutterfire configure çalıştırarak bu değerleri güncelleyin
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosBundleId: 'BUNDLE_ID_PLACEHOLDER',
  );
}
EOF
sed -i '' "s/BUNDLE_ID_PLACEHOLDER/$PACKAGE_NAME/" lib/firebase_options.dart

# firebase.json'u temizle
cat > firebase.json << 'EOF'
{
  "flutter": {
    "platforms": {
      "android": {
        "default": {
          "projectId": "your-project-id",
          "appId": "YOUR_APP_ID",
          "fileOutput": "android/app/google-services.json"
        }
      },
      "ios": {
        "default": {
          "projectId": "your-project-id",
          "appId": "YOUR_APP_ID",
          "fileOutput": "ios/Runner/GoogleService-Info.plist"
        }
      }
    }
  }
}
EOF

print_success "Firebase bağlantısı koparıldı"

# =============================================================================
# 6. LOCALIZATION
# =============================================================================
print_step "Localization dosyaları güncelleniyor..."

# app_en.arb ve app_tr.arb'deki appTitle'ı güncelle
sed -i '' "s/\"appTitle\": \"Base\"/\"appTitle\": \"$APP_DISPLAY_NAME\"/" lib/l10n/app_en.arb
sed -i '' "s/\"appTitle\": \"Base\"/\"appTitle\": \"$APP_DISPLAY_NAME\"/" lib/l10n/app_tr.arb

print_success "Localization dosyaları güncellendi"

# =============================================================================
# 7. CLEAN & GET
# =============================================================================
print_step "Proje temizleniyor ve bağımlılıklar alınıyor..."

flutter clean > /dev/null 2>&1
flutter pub get > /dev/null 2>&1

print_success "Proje hazır"

# =============================================================================
# ÖZET
# =============================================================================
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    KURULUM TAMAMLANDI                      ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Sonraki adımlar:"
echo ""
echo "  1. Firebase Console'da yeni proje oluşturun"
echo "     https://console.firebase.google.com"
echo ""
echo "  2. FlutterFire CLI ile yapılandırın:"
echo "     flutterfire configure"
echo ""
echo "  3. Gerekli Firebase servislerini aktifleştirin:"
echo "     - Authentication (Anonymous)"
echo "     - Cloud Firestore"
echo "     - Remote Config"
echo "     - Analytics"
echo ""
echo "  4. iOS için pod'ları güncelleyin:"
echo "     cd ios && pod install && cd .."
echo ""
echo "  5. Uygulamayı çalıştırın:"
echo "     flutter run"
echo ""
print_warning "NOT: RevenueCat kullanacaksanız lib/data/services/revenuecat_api_key_io.dart dosyasını güncelleyin"
echo ""
