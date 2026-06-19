# MPME OS — Mobile (Flutter)

Application mobile Flutter de la plateforme **MPME OS**, destinée aux micro, petites et moyennes entreprises (MPME) au Bénin.

Ce dépôt contient uniquement la partie **mobile**. La partie web (Nuxt.js) et la partie API (Django) sont gérées dans des dépôts séparés.

---

## Stack Technique

| Composant           | Technologie                              |
| ------------------- | ---------------------------------------- |
| Framework           | Flutter (Dart)                           |
| Cibles              | Android, iOS                             |
| Stockage hors-ligne | SQLite via `sqflite ^2.3.0`              |
| Gestion d'état      | À définir avec l'équipe                  |
| Communication API   | HTTP vers le Backend Django (`/api/...`) |

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
    │   ├── theme/            # thème global de l'application
    │   └── utils/            # fonctions utilitaires (formatage, validation...)
    │
    ├── data/
    │   ├── models/
    │   │   └── transaction_model.dart     # structure d'une transaction (Sprint 1 ✅)
    │   ├── repositories/
    │   │   └── transaction_repository.dart # orchestre accès données (Sprint 1 ✅)
    │   └── services/
    │       └── database_service.dart       # gestion base SQLite locale (Sprint 1 ✅)
    │
    ├── domain/
    │   ├── entities/         # objets métier purs (Transaction, ScoreFinancier...)
    │   ├── repositories/     # contrats abstraits (interfaces)
    │   └── usecases/         # actions métier (EnregistrerVente, ConsulterScore...)
    │
    ├── presentation/
    │   ├── screens/
    │   │   ├── auth/            # connexion (US1)
    │   │   ├── comptabilite/    # ventes, dépenses, livre de caisse (US3, US4)
    │   │   ├── financement/     # catalogue d'offres, demandes (US7)
    │   │   ├── formalisation/   # suivi IFU / RCCM (US12)
    │   │   └── score/           # score financier (US8)
    │   ├── widgets/             # composants réutilisables
    │   ├── navigation/          # routes de l'app
    │   └── providers/           # gestion d'état (à définir)
    │
    └── main.dart
```

> **Note** : les écrans listés ci-dessus sont volontairement provisoires. Le découpage exact sera ajusté à réception des maquettes Design, livrées progressivement sprint par sprint.

---

## Stockage local hors-ligne (SQLite)

### Pourquoi SQLite ?

Les entrepreneurs béninois n'ont pas toujours accès à internet. SQLite permet de **sauvegarder les données directement sur le téléphone** sans connexion, puis de les synchroniser automatiquement avec le serveur Django dès que le réseau est disponible. C'est ce que le projet appelle la **synchronisation différée**.

### Comment ça fonctionne

```
Entrepreneur saisit une vente
        ↓
Connexion disponible ?
        ↓                    ↓
       OUI                  NON
        ↓                    ↓
Envoi direct          Sauvegarde en SQLite
à l'API Django        (statut = LOCAL)
                             ↓
                    Connexion retrouvée
                             ↓
                    Envoi à l'API Django
                    (statut = SYNCHRONISE)
```

### Fichiers mis en place (Sprint 1)

| Fichier                                         | Rôle                                                      |
| ----------------------------------------------- | --------------------------------------------------------- |
| `data/models/transaction_model.dart`            | Représente une transaction (structure des données)        |
| `data/services/database_service.dart`           | Gère la base SQLite : créer, insérer, lire, mettre à jour |
| `data/repositories/transaction_repository.dart` | Point d'entrée pour la couche présentation                |

### Structure de la table `transactions`

| Colonne                 | Type        | Description                                 |
| ----------------------- | ----------- | ------------------------------------------- |
| `id`                    | TEXT (UUID) | Identifiant unique généré côté mobile       |
| `type`                  | TEXT        | `VENTE` ou `DEPENSE`                        |
| `montant`               | REAL        | Montant en FCFA                             |
| `description`           | TEXT        | Description libre                           |
| `categorieDepense`      | TEXT        | Catégorie de la dépense                     |
| `date`                  | TEXT        | Date de la transaction                      |
| `statutSynchronisation` | TEXT        | `LOCAL`, `SYNCHRONISE` ou `ERREUR`          |
| `hashVerification`      | TEXT        | Empreinte SHA-256 pour vérifier l'intégrité |

> La structure de cette table est basée exactement sur le diagramme de classes du Dossier de Conception Technique (section 2.2 — Comptabilité & synchronisation hors-ligne).

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

| Méthode | Endpoint                   | Description                            |
| ------- | -------------------------- | -------------------------------------- |
| `POST`  | `/api/auth/register/`      | Inscription                            |
| `POST`  | `/api/auth/login/`         | Connexion (renvoie `access`/`refresh`) |
| `POST`  | `/api/auth/token/refresh/` | Rafraîchissement du token              |
| `GET`   | `/api/auth/me/`            | Profil de l'utilisateur connecté       |

D'autres endpoints (transactions, financement...) seront ajoutés au fil des sprints.

---

## Sync S0 → S1 — Checklist Frontend Mobile

### Architecture & Navigation

- [x] Structure Clean Architecture en place (`core/`, `data/`, `domain/`, `presentation/`)
- [x] Squelette de navigation fonctionnel entre les 5 zones identifiées au Product Backlog
- [ ] Validation de la navigation avec l'équipe Design (suite à réception des croquis basse fidélité)

### Sprint 1

- [x] Mise en place du stockage local SQLite (TransactionModel, DatabaseService, TransactionRepository)
- [ ] Définition du gestionnaire d'état avec l'équipe
