/// Types de transaction acceptés par l'API.
class TypeTransaction {
  static const String vente = 'VENTE';
  static const String depense = 'DEPENSE';
}

/// Statut de synchronisation local (offline-first).
class StatutSync {
  static const String local = 'LOCAL'; // créé hors-ligne, pas encore envoyé
  static const String synchronise = 'SYNCHRONISE';
}

class TransactionModel {
  final String id; // UUID généré côté client
  final String entrepriseId;
  final String typeTransaction; // VENTE | DEPENSE
  final double montant;
  final String? description;
  final String? categorieDepense;
  final DateTime dateEffective;
  final String statutSynchronisation;
  final String? hashVerification;

  TransactionModel({
    required this.id,
    required this.entrepriseId,
    required this.typeTransaction,
    required this.montant,
    this.description,
    this.categorieDepense,
    required this.dateEffective,
    this.statutSynchronisation = StatutSync.local,
    this.hashVerification,
  });

  TransactionModel copyWith({
    String? statutSynchronisation,
    String? hashVerification,
  }) {
    return TransactionModel(
      id: id,
      entrepriseId: entrepriseId,
      typeTransaction: typeTransaction,
      montant: montant,
      description: description,
      categorieDepense: categorieDepense,
      dateEffective: dateEffective,
      statutSynchronisation: statutSynchronisation ?? this.statutSynchronisation,
      hashVerification: hashVerification ?? this.hashVerification,
    );
  }

  // ---- SQLite (stockage local offline-first) ----
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entrepriseId': entrepriseId,
      'type': typeTransaction,
      'montant': montant,
      'description': description,
      'categorieDepense': categorieDepense,
      'date': dateEffective.toIso8601String(),
      'statutSynchronisation': statutSynchronisation,
      'hashVerification': hashVerification,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      entrepriseId: map['entrepriseId'] ?? '',
      typeTransaction: map['type'],
      montant: (map['montant'] as num).toDouble(),
      description: map['description'],
      categorieDepense: map['categorieDepense'],
      dateEffective: DateTime.parse(map['date']),
      statutSynchronisation: map['statutSynchronisation'] ?? StatutSync.local,
      hashVerification: map['hashVerification'],
    );
  }

  // ---- API (POST /api/transactions/) ----
  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'entreprise_id': entrepriseId,
      'type_transaction': typeTransaction,
      'montant': montant,
      'description': description,
      'categorie_depense': categorieDepense,
      'date_effective': dateEffective.toIso8601String(),
    };
  }

  factory TransactionModel.fromApiJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      entrepriseId: json['entreprise_id'],
      typeTransaction: json['type_transaction'],
      montant: double.parse(json['montant'].toString()),
      description: json['description'],
      categorieDepense: json['categorie_depense'],
      dateEffective: DateTime.parse(json['date_effective']),
      statutSynchronisation: json['statut_synchronisation'] ?? StatutSync.synchronise,
      hashVerification: json['hash_verification'],
    );
  }

  bool get estVente => typeTransaction == TypeTransaction.vente;
  bool get estDepense => typeTransaction == TypeTransaction.depense;
}
