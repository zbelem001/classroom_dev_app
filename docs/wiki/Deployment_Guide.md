# Guide de Déploiement

Ce guide détaille les étapes pour compiler et déployer l'application sur différentes plateformes.

## Android

### 1. Configuration de la signature (Production)
Pour la production, vous devez signer votre application.
1. Créez un keystore :
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Configurez `android/key.properties` (ne pas commiter ce fichier).
3. Modifiez `android/app/build.gradle` pour utiliser la configuration de signature.

### 2. Générer l'APK ou App Bundle
- **APK (pour tests/distribution directe)** :
  ```bash
  flutter build apk --release
  ```
  *Sortie : `build/app/outputs/flutter-apk/app-release.apk`*

- **App Bundle (pour Google Play)** :
  ```bash
  flutter build appbundle
  ```
  *Sortie : `build/app/outputs/bundle/release/app-release.aab`*

## iOS (MacOS requis)

### 1. Prérequis
- Xcode installé.
- Compte Apple Developer actif.
- Certificats et Provisioning Profiles configurés dans Xcode.

### 2. Build Archive
Utilisez la commande suivante ou passez par Xcode (`Product > Archive`) :
```bash
flutter build ipa
```
*Sortie : `build/ios/archive/Runner.xcarchive`*

## Web

DocuResume Pro est compatible Web.

### 1. Build
```bash
flutter build web
```

### 2. Déploiement
Le contenu du dossier `build/web` peut être hébergé sur n'importe quel serveur statique (Nginx, Apache, Firebase Hosting, Vercel).

Exemple avec Firebase :
```bash
firebase init hosting
firebase deploy
```

## CI/CD (Optionnel)
Ce projet peut être intégré à GitHub Actions.
Un workflow typique inclut :
1. Checkout du code.
2. Installation de Java & Flutter.
3. `flutter pub get`.
4. `flutter analyze`.
5. `flutter test`.
6. `flutter build apk`.
