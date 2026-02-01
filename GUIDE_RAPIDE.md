# 🚀 GUIDE RAPIDE - Lancer l'Application

## ⚡ Solution Express (2 commandes)

```bash
# Méthode 1: Utiliser le script automatique
.\fix_ndk.bat

# OU Méthode 2: Manuel
flutter clean
flutter run
```

---

## 🎯 Si le script bat ne fonctionne pas

### Commandes manuelles:

```bash
# 1. Supprimer le NDK corrompu
Remove-Item "C:\Users\danie\AppData\Local\Android\sdk\ndk\27.0.12077973" -Recurse -Force

# 2. Nettoyer Flutter
cd C:\Users\danie\Desktop\projetPamousso\flutter_app
flutter clean

# 3. Lancer l'app
flutter run
```

---

## 📱 Alternative: Build APK

Si `flutter run` ne fonctionne toujours pas:

```bash
# Build l'APK
flutter build apk --debug

# L'APK sera dans:
# build\app\outputs\flutter-apk\app-debug.apk
```

**Ensuite:**
1. Transférez `app-debug.apk` sur votre Samsung
2. Installez-le manuellement
3. Ouvrez l'app "DocuResume Pro"

---

## 🔐 Connexion

```
Email:    visiteur@gmail.com  
Password: 123456789
```

---

## ✅ Ce qui va se passer

1. **Premier lancement:** 5-10 minutes (Gradle télécharge le NDK)
2. **L'app s'installe** automatiquement sur votre Samsung
3. **L'app se lance** automatiquement
4. **Vous verrez** l'écran de connexion

---

## 🎯 Tester l'application

Une fois connecté:

1. ✅ Voir les 3 documents existants
2. ✅ Uploader un PDF (bouton bleu en bas)
3. ✅ Ouvrir un document (tap dessus)
4. ✅ Générer un résumé (icône en haut)
5. ✅ Poser une question dans le chat

---

## 🐛 Si ça ne marche toujours pas

### Solution Android Studio (LA PLUS FIABLE):

1. Ouvrez **Android Studio**
2. Cliquez sur **More Actions** → **SDK Manager**
3. Onglet **SDK Tools**
4. **Décochez** "NDK (Side by side)"
5. Cliquez sur **Apply** (désinstallation)
6. **Recochez** "NDK (Side by side)"
7. Cliquez sur **Apply** (réinstallation ~500MB)
8. Attendez la fin du téléchargement
9. Puis:
   ```bash
   flutter clean
   flutter run
   ```

---

## 📚 Documentation Complète

- `RESOLUTION_NDK.md` - 5 solutions détaillées
- `LANCER_APP.md` - Guide de lancement complet
- `INSTALLATION.md` - Guide d'installation

---

## 💡 Commandes Utiles

```bash
# Vérifier les devices connectés
flutter devices

# Vérifier l'état Flutter
flutter doctor -v

# Clean complet
flutter clean

# Build APK debug
flutter build apk --debug

# Build APK release (optimisé)
flutter build apk --release

# Installer APK via ADB
adb install build\app\outputs\flutter-apk\app-debug.apk
```

---

## ⚡ Résumé Ultra-Rapide

```bash
# Si tout va bien:
.\fix_ndk.bat
# Puis choisir "O" pour lancer

# Si problème:
# Ouvrir Android Studio → SDK Manager → Réinstaller NDK
# Puis: flutter clean && flutter run
```

---

**Questions? Consultez RESOLUTION_NDK.md pour toutes les solutions! 🎯**
