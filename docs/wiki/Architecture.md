# Architecture Système

## Vue d'ensemble
L'application **DocuResume Pro** est construite avec le framework **Flutter** et suit une architecture en couches (Layered Architecture) pour assurer la maintenabilité et l'évolutivité.

## Stack Technique

| Catégorie | Technologie | Description |
|-----------|-------------|-------------|
| **Frawework** | Flutter 3.x / Dart 3.x | Cross-platform dev |
| **State Management** | Provider | Gestion d'état simple et efficace |
| **Networking** | Dio / Http | Requêtes API REST |
| **Stockage Local** | SharedPreferences | Persistance des sessions |
| **Fichiers** | File Picker | Sélection de documents PDF |
| **PDF** | Flutter PDFView | Visualisation de documents |
| **UI** | Material 3 | Design System Google |

## Diagramme d'Architecture Simplifié

```mermaid
graph TD
    UI[Interface Utilisateur (Screens)] -->|Utilise| VM[Logic BLC / Providers]
    VM -->|Appelle| CS[Client Services (API)]
    CS -->|Requêtes HTTP| Back[Backend API]
    UI -->|Navigation| Nav[Navigator]
    VM -->|Stocke/Lit| Local[SharedPreferences]
```

## Description des Couches

### 1. Presentation Layer (`lib/screens`, `lib/widgets`)
Contient tous les éléments visuels.
- **Screens**: Pages complètes (Login, Home, Chat).
- **Widgets**: Composants réutilisables (DocumentCard, InputFields).
- **Theme**: Définition centralisée du style (`lib/utils/app_theme.dart`).

### 2. Business Logic Layer
Gérée principalement via **Provider** (si implémenté) ou directement dans les contrôleurs de widgets pour les cas simples.
Gestion des états de chargement (`isLoading`), des erreurs et des données métier.

### 3. Data Layer (`lib/models`, `lib/services`)
- **Models**: Classes Dart pures pour la sérialisation JSON (`fromJson`/`toJson`).
- **Services**: `ApiService` agit comme un singleton pour communiquer avec le backend via REST.
  - Gestion des tokens d'authentification.
  - Intercepteurs pour les erreurs globales.

## Sécurité
- Les tokens (JWT) sont stockés localement sur l'appareil.
- Les communications réseau se font via HTTPS.
