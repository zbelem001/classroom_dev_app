# Référence API

L'application communique avec un backend REST.

## Configuration
L'URL de base est définie dans `lib/services/api_service.dart`.

## Endpoints Principaux

### Authentification
- `POST /auth/login`: Connexion.
- `POST /auth/register`: Inscription.

### Documents
- `POST /upload`: Upload de fichier PDF (Multipart).
- `GET /documents`: Récupérer la liste des documents de l'utilisateur.
- `DELETE /documents/{id}`: Supprimer un document.

### Chat & Résumé
- `POST /chat`: Envoyer un message au contexte d'un document.
- `POST /summary`: Demander le résumé d'un document.
