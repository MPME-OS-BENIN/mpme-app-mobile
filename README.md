
# MPME OS — Mobile (Flutter)

Application mobile Flutter de la plateforme **MPME OS**, destinée aux micro, petites et moyennes entreprises (MPME) au Bénin.

Ce dépôt contient uniquement la partie **mobile**. La partie web (Nuxt.js) et la partie API (Django) sont gérées dans des dépôts séparés.



---

## Stack Technique

| Composant | Technologie |
|---|---|
| Framework | Flutter (Dart) |
| Cibles | Android, iOS |
| Stockage hors-ligne | SQLite (à mettre en place — Sprint 1) |
| Gestion d'état | À définir avec l'équipe |
| Communication API | HTTP vers le Backend Django (`/api/...`) |

---

## Architecture

Le projet suit les principes de la **Clean Architecture**, qui sépare le code en 3 couches indépendantes :

- **`presentation/`** → ce que l'utilisateur voit : écrans, widgets, navigation
- **`domain/`** → les règles métier pures (ex : calcul du bénéfice, éligibilité à une offre), indépendantes de Flutter
- **`data/`** → la récupération des données : appels à l'API Django, lecture/écriture SQLite

Cette séparation permet de modifier l'interface sans toucher à la logique métier, et inversement.

### Structure des dossiers

```
mpme-app-mobile/
└── lib/
    ├── core/
    │   ├── constants/        # couleurs, textes, routes fixes
    │   ├── theme/             # thème global de l'application
    │   └── utils/             # fonctions utilitaires (formatage, validation...)
    │
    ├── data/
    │   ├── models/            # objets représentant les données brutes (JSON API)
    │   ├── repositories/      # implémentation concrète de l'accès aux données
    │   └── services/          # appels API Django + accès SQLite
    │
    ├── domain/
    │   ├── entities/           # objets métier purs (Transaction, ScoreFinancier...)
    │   ├── repositories/       # contrats abstraits (interfaces)
    │   └── usecases/           # actions métier (EnregistrerVente, ConsulterScore...)
    │
    ├── presentation/
    │   ├── screens/
    │   │   ├── auth/            # connexion (US1)
    │   │   ├── comptabilite/    # ventes, dépenses, livre de caisse (US3, US4)
    │   │   ├── financement/     # catalogue d'offres, demandes (US7)
    │   │   ├── formalisation/   # suivi IFU / RCCM (US12)
    │   │   └── score/           # score financier (US8)
    │   ├── widgets/             # composants réutilisables
    │   ├── navigation/          # routes de l'app (app_routes.dart, home_screen.dart)
    │   └── providers/           # gestion d'état (vide — en attente de décision d'équipe)
    │
    └── main.dart
```

> **Note** : les écrans listés ci-dessus sont volontairement provisoires. Le découpage exact (nombre d'écrans, sous-écrans) sera ajusté à réception des maquettes Design, livrées progressivement sprint par sprint (voir Orchestration des Sprints).

---

## Installation & lancement

### Prérequis

- Flutter SDK installé
- Android Studio (SDK + cmdline-tools) ou Xcode pour iOS
- Vérifier l'installation :

```bash
flutter doctor
```

### 1. Cloner le dépôt

```bash
git clone git@github.com:MPME-OS-BENIN/mpme-app-mobile.git
cd mpme-app-mobile
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Lancer le projet

```bash
flutter run
```

---

## Lien avec le Backend

L'application consomme l'API Django décrite dans le dépôt `mpme-backend`. Endpoints déjà disponibles côté authentification :

| Méthode | Endpoint | Description |
|---|---|---|
| `POST` | `/api/auth/register/` | Inscription |
| `POST` | `/api/auth/login/` | Connexion (renvoie `access`/`refresh`) |
| `POST` | `/api/auth/token/refresh/` | Rafraîchissement du token |
| `GET` | `/api/auth/me/` | Profil de l'utilisateur connecté |

D'autres endpoints (entreprises, transactions, financement...) seront ajoutés au fil des sprints — se référer au README du Backend pour la liste complète et à jour.

---


### Architecture & Navigation
- [x] Structure Clean Architecture en place (`core/`, `data/`, `domain/`, `presentation/`)
- [x] Squelette de navigation fonctionnel entre les 5 zones identifiées au Product Backlog
- [ ] Validation de la navigation avec l'équipe Design (suite à réception des croquis basse fidélité)

### Préparation Sprint 1
- [ ] Mise en place du stockage local SQLite (US9 — préparation)
- [ ] Définition du gestionnaire d'état avec l'équipe

