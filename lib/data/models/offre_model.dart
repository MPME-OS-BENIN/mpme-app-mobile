class TypeFinancement {
  static const String credit = 'CREDIT';
  static const String subvention = 'SUBVENTION';
  static const String garantie = 'GARANTIE';

  static String libelle(String type) {
    switch (type) {
      case credit:
        return 'Crédit';
      case subvention:
        return 'Subvention';
      case garantie:
        return 'Garantie';
      default:
        return type;
    }
  }
}

/// Offre de financement publiée par une institution financière (US6/US7).
/// `estEligible` n'est renseigné que pour un entrepreneur (toujours le cas
/// dans l'app mobile) ; l'API ne renvoie que les offres actives et non
/// expirées dans la liste, donc il n'apparaîtra quasiment jamais à false
/// avec la règle d'éligibilité actuelle côté backend.
class OffreModel {
  final String id;
  final String titre;
  final String typeFinancement;
  final double montantMin;
  final double montantMax;
  final double? tauxInteret;
  final String conditionsEligibilite;
  final DateTime dateExpiration;
  final bool? estEligible;

  OffreModel({
    required this.id,
    required this.titre,
    required this.typeFinancement,
    required this.montantMin,
    required this.montantMax,
    this.tauxInteret,
    required this.conditionsEligibilite,
    required this.dateExpiration,
    this.estEligible,
  });

  factory OffreModel.fromJson(Map<String, dynamic> json) {
    return OffreModel(
      id: json['id'] as String,
      titre: json['titre'] as String,
      typeFinancement: json['type_financement'] as String,
      // DecimalField Django -> sérialisé en chaîne par DRF (précision) :
      // on passe systématiquement par .toString() avant double.parse,
      // que la valeur arrive en chaîne ou déjà en nombre.
      montantMin: double.parse(json['montant_min'].toString()),
      montantMax: double.parse(json['montant_max'].toString()),
      tauxInteret: json['taux_interet'] != null ? (json['taux_interet'] as num).toDouble() : null,
      conditionsEligibilite: json['conditions_eligibilite'] as String? ?? '',
      dateExpiration: DateTime.parse(json['date_expiration'] as String),
      estEligible: json['est_eligible'] as bool?,
    );
  }
}
