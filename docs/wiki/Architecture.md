# Architecture de l'Application

L'application suit une architecture standard Flutter, séparée en couches.

## Structure des Dossiers (`lib/`)

### `models/`
Contient les classes de données (POJO) qui mappent les réponses JSON de l'API.
- `user_model.dart`: Données utilisateur (token, email).
- `document_model.dart`: Métadonnées des fichiers uploadés.
- `summary_model.dart`: Résumés générés.

### `screens/`
Les écrans de l'application (UI).
- `login_screen.dart`: Écran de connexion et inscription.
- `home_screen.dart`: Dashboard principal, liste des documents.
- `chat_screen.dart`: Interface de chat avec Gemini.

### `services/`
Logique métier et appels réseau.
- `api_service.dart`: Singleton gérant toutes les requêtes HTTP (Dio/Http) vers le backend.

### `widgets/`
Composants réutilisables.
- `document_card.dart`: Carte affichant un document dans la liste.

### `utils/`
Utilitaires et configuration.
- `app_theme.dart`: Thème global (couleurs, styles de texte).
