class TransactionModel {
  final String id;
  final String type; 
  final double montant;
  final String description;
  final String categorieDepense;
  final String date;
  final String statutSynchronisation;
  final String hashVerification;

  TransactionModel({
    required this.id,
    required this.type,
    required this.montant,
    required this.description,
    required this.categorieDepense,
    required this.date,
    required this.statutSynchronisation,
    required this.hashVerification,
  });

  // Convertit un objet Dart en Map pour pouvoir inserer dans SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'montant': montant,
      'description': description,
      'categorieDepense': categorieDepense,
      'date': date,
      'statutSynchronisation': statutSynchronisation,
      'hashVerification': hashVerification,
    };
  }

  // Convertit une ligne SQLite en objet Dart
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      montant: map['montant'],
      description: map['description'],
      categorieDepense: map['categorieDepense'],
      date: map['date'],
      statutSynchronisation: map['statutSynchronisation'],
      hashVerification: map['hashVerification'],
    );
  }
}