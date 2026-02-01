# DocuResume Pro - Flutter App

Application mobile Flutter pour DocuResume Pro avec intégration API cloud.

## Fonctionnalités

**Authentification**

- Login / Register
- Session persistante avec SharedPreferences
- Compte de test

  **Gestion des Documents**

- Upload de fichiers PDF avec FilePicker
- Liste des documents avec refresh
- Suppression de documents
- Affichage des métadonnées (pages, taille, statut)

  **Chat IA (Gemini)**

- Questions/Réponses contextuelles sur les documents
- Génération de résumés intelligents
- Interface de chat moderne
- Loading indicators

  **UI/UX**

- Animations fluides
- Loading states
- Error handling avec SnackBars

## Installation

### Prérequis

- Flutter SDK 3.0+
- IDE : Android Studio / Xcode
- Dart 3.0+

### 1. Installer les dépendances

```bash
cd flutter_app
flutter pub get
```

### 2. Configuration

L'API est configurée dans `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'https://k2mar-docuresume-backend.hf.space';
```

### 3. Lancer l'application

**Android:**

```bash
flutter run
```

**iOS:**

```bash
flutter run
```

**Build APK:**

```bash
flutter build apk --release
```

## 📂 Structure du Projet

```
flutter_app/
├── lib/
│   ├── main.dart                 # Point d'entrée
│   ├── models/                   # Modèles de données
│   │   ├── user_model.dart
│   │   ├── document_model.dart
│   │   └── summary_model.dart
│   ├── screens/                  # Écrans
│   │   ├── login_screen.dart     # Connexion/Inscription
│   │   ├── home_screen.dart      # Liste des documents
│   │   └── chat_screen.dart      # Chat IA
│   ├── services/                 # Services
│   │   └── api_service.dart      # Client API
│   ├── widgets/                  # Composants réutilisables
│   │   └── document_card.dart
│   └── utils/                    # Utilitaires
│       └── app_theme.dart        # Thème & Couleurs
└── pubspec.yaml                  # Dépendances
```

## 🎨 Écrans

### 1. LoginScreen

- Formulaire de connexion
- Formulaire d'inscription
- Validation des champs
- Loading indicator
- Info compte de test

### 2. HomeScreen

- Liste des documents uploadés
- Bouton d'upload (FilePicker)
- Refresh to reload
- Swipe actions
- Empty state élégant

### 3. ChatScreen

- Interface de chat
- Questions/Réponses avec Gemini
- Bouton "Générer un résumé"
- Bulles de messages
- Loading indicators

## 📦 Dépendances Principales

```yaml
dependencies:
  # UI & Navigation
  flutter_svg: ^2.0.9

  # State Management
  provider: ^6.1.1

  # HTTP & API
  http: ^1.2.0
  dio: ^5.4.0

  # File Picker
  file_picker: ^6.1.1

  # Local Storage
  shared_preferences: ^2.2.2

  # Loading & Toast
  flutter_spinkit: ^5.2.0
  fluttertoast: ^8.2.4

  # Utils
  intl: ^0.18.1
```

## 🔌 API Endpoints Utilisés

### Authentification

- `POST /users/register` - Inscription
- `POST /users/login` - Connexion

### Documents

- `POST /documents/upload` - Upload PDF
- `GET /documents/user/{userId}` - Liste documents
- `GET /documents/{documentId}/content` - Contenu
- `DELETE /documents/{documentId}` - Suppression

### IA Gemini

- `POST /generate/summary/gemini` - Résumé
- `POST /query/gemini` - Q&A

## 🧪 Tests

### Compte de test

```
Email: visiteur@gmail.com
Password: 123456789
```

### Workflow de test

1. Lancer l'app
2. Se connecter avec le compte test
3. Uploader un PDF
4. Ouvrir le document
5. Poser des questions
6. Générer un résumé

## 🎯 Fonctionnalités Clés

### Upload de Documents

```dart
// FilePicker intégré
final result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['pdf'],
);
```

### Loading Indicators

```dart
// SpinKit pour le chargement
SpinKitFadingCircle(
  color: AppColors.primary,
  size: 50,
)
```

### Error Handling

```dart
// SnackBars pour les erreurs
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(message),
    backgroundColor: AppColors.error,
  ),
);
```

## 🎨 Design System

### Couleurs

```dart
AppColors.primary      // #007AFF (Bleu)
AppColors.secondary    // #34C759 (Vert)
AppColors.error        // #FF3B30 (Rouge)
AppColors.warning      // #FF9500 (Orange)
```

### Typography

```dart
AppTextStyles.h1       // 32px Bold
AppTextStyles.h2       // 24px Bold
AppTextStyles.h3       // 20px SemiBold
AppTextStyles.bodyLarge// 17px Regular
```

## 📱 Compatibilité

- ✅ Android 6.0+ (API 23+)
- ✅ iOS 12.0+
- ✅ Portrait mode only
- ✅ Dark/Light theme ready

## 🐛 Troubleshooting

### Erreur de build

```bash
flutter clean
flutter pub get
flutter run
```

### FilePicker ne fonctionne pas

Vérifier les permissions dans:

- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

### API timeout

Augmenter le timeout dans `api_service.dart`:

```dart
final client = http.Client();
// Timeout à 60s pour OCR
```

## 📝 TODO

- [ ] Ajout de la recherche sémantique (FAISS)
- [ ] Cache local des documents
- [ ] Export des résumés
- [ ] Notifications push
- [ ] Statistiques utilisateur
# classroom_dev_app

## Documentation

Pour plus de détails techniques, consultez notre [Wiki](docs/wiki/Home.md) :
- [Architecture du projet](docs/wiki/Architecture.md)
- [Référence API](docs/wiki/API_Reference.md)
- [Guide d'installation complet](INSTALLATION.md)
