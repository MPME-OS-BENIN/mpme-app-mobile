/// Score financier de l'entrepreneur (US7/US13). Échelle 0-100 côté
/// backend (voir apps/scoring/models.py : valeur validée entre 0 et 100).
/// Correction produit du 2026-09-22 : la maquette affichait "/1000",
/// c'était une erreur — l'échelle réelle et définitive est /100.
class ScoreModel {
  final String id;
  final double valeur; // 0-100
  final String niveauRisque; // FAIBLE | MOYEN | ELEVE
  final Map<String, dynamic> indicateurs;
  final DateTime dateCalcul;
  final bool estPartageable;

  ScoreModel({
    required this.id,
    required this.valeur,
    required this.niveauRisque,
    required this.indicateurs,
    required this.dateCalcul,
    required this.estPartageable,
  });

  /// Progression 0..1 pour les jauges (CustomPainter, indicateurs circulaires).
  double get progression => (valeur / 100).clamp(0.0, 1.0);

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      id: json['id'] as String,
      valeur: (json['valeur'] as num).toDouble(),
      niveauRisque: json['niveau_risque'] as String? ?? 'MOYEN',
      indicateurs: (json['indicateurs'] as Map?)?.cast<String, dynamic>() ?? const {},
      dateCalcul: DateTime.parse(json['date_calcul'] as String),
      estPartageable: json['est_partageable'] as bool? ?? false,
    );
  }
}

class NiveauRisque {
  static const String faible = 'FAIBLE';
  static const String moyen = 'MOYEN';
  static const String eleve = 'ELEVE';
}
