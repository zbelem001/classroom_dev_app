# Guide d'Installation - Flutter App

## 📋 Prérequis

### 1. Flutter SDK
Installez Flutter depuis: https://docs.flutter.dev/get-started/install

**Vérifier l'installation:**
```bash
flutter doctor
```

### 2. Éditeur
- **Android Studio** (recommandé) - https://developer.android.com/studio
- **VS Code** avec extension Flutter - https://code.visualstudio.com/

### 3. Émulateurs
- **Android:** AVD Manager dans Android Studio
- **iOS:** Simulator sur macOS uniquement

---

## 🚀 Installation

### Étape 1: Cloner et naviguer
```bash
cd projetPamousso/flutter_app
```

### Étape 2: Installer les dépendances
```bash
flutter pub get
```

### Étape 3: Vérifier la configuration
```bash
flutter doctor -v
```

### Étape 4: Lister les devices disponibles
```bash
flutter devices
```

---

## 🔧 Configuration Android

### 1. Permissions (AndroidManifest.xml)
Fichier: `android/app/src/main/AndroidManifest.xml`

Ajouter avant `</manifest>`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### 2. Min SDK Version
Fichier: `android/app/build.gradle`

Vérifier:
```gradle
android {
    defaultConfig {
        minSdkVersion 23  // Android 6.0+
        targetSdkVersion 33
    }
}
```

---

## 🍎 Configuration iOS (macOS uniquement)

### 1. Permissions (Info.plist)
Fichier: `ios/Runner/Info.plist`

Ajouter avant `</dict>`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Nous avons besoin d'accéder à vos photos pour sélectionner des documents PDF.</string>
<key>NSCameraUsageDescription</key>
<string>Nous avons besoin d'accéder à votre caméra pour scanner des documents.</string>
```

### 2. Pods
```bash
cd ios
pod install
cd ..
```

---

## ▶️ Lancer l'Application

### Option 1: Mode Debug
```bash
flutter run
```

### Option 2: Mode Release
```bash
flutter run --release
```

### Option 3: Sur un device spécifique
```bash
# Lister les devices
flutter devices

# Lancer sur un device
flutter run -d <device-id>
```

---

## 📦 Build APK/IPA

### Android APK
```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release

# Split per ABI (plus petit)
flutter build apk --split-per-abi
```

**APK généré dans:** `build/app/outputs/flutter-apk/`

### Android App Bundle (pour Play Store)
```bash
flutter build appbundle
```

**AAB généré dans:** `build/app/outputs/bundle/release/`

### iOS (macOS uniquement)
```bash
flutter build ios --release
```

Puis ouvrir Xcode pour signer et exporter:
```bash
open ios/Runner.xcworkspace
```

---

## 🧪 Tests

### Tests unitaires
```bash
flutter test
```

### Lancer l'app sur tous les devices
```bash
flutter run -d all
```

---

## 🐛 Résolution de Problèmes

### 1. Erreur "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### 2. Erreur "SDK location not found"
Créer `android/local.properties`:
```properties
sdk.dir=/path/to/Android/sdk
```

### 3. Erreur de dépendances
```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
```

### 4. Hot reload ne fonctionne pas
```bash
# Redémarrer l'app
r

# Hot restart
R

# Quit
q
```

### 5. iOS build failed (Pods)
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

---

## 📱 Tester sur Device Physique

### Android
1. Activer "Mode développeur" sur le téléphone
2. Activer "Débogage USB"
3. Connecter avec câble USB
4. Autoriser le débogage sur le téléphone
5. `flutter run`

### iOS
1. Connecter l'iPhone avec câble
2. Trust l'ordinateur sur l'iPhone
3. Ouvrir Xcode > Window > Devices and Simulators
4. Vérifier que l'iPhone est détecté
5. `flutter run`

---

## 🔑 Variables d'Environnement

### API Base URL
Modifier dans `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://k2mar-docuresume-backend.hf.space';
```

---

## 📊 Performance

### Profiler l'app
```bash
flutter run --profile
```

### Analyser la taille de l'APK
```bash
flutter build apk --analyze-size
```

---

## 🎯 Commandes Utiles

```bash
# Version de Flutter
flutter --version

# Mettre à jour Flutter
flutter upgrade

# Nettoyer le cache
flutter clean

# Lister les packages obsolètes
flutter pub outdated

# Upgrade packages
flutter pub upgrade

# Format du code
flutter format .

# Analyze code
flutter analyze
```

---

## 📚 Ressources

- **Flutter Docs:** https://docs.flutter.dev/
- **Dart Docs:** https://dart.dev/guides
- **Pub.dev (Packages):** https://pub.dev/
- **Flutter Cookbook:** https://docs.flutter.dev/cookbook
- **Flutter Community:** https://flutter.dev/community

---

## ✅ Checklist Avant Release

- [ ] Tester sur device physique
- [ ] Tester sur plusieurs résolutions
- [ ] Vérifier les permissions
- [ ] Tester le mode hors-ligne
- [ ] Optimiser les images
- [ ] Minifier le code
- [ ] Obfusquer le code
- [ ] Changer l'icône de l'app
- [ ] Mettre à jour la version dans `pubspec.yaml`
- [ ] Build en mode release
- [ ] Tester l'APK/IPA final

---

**Besoin d'aide?** Consultez la documentation officielle ou ouvrez une issue sur GitHub.
