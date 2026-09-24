class StatutDemande {
  static const String enAttente = 'EN_ATTENTE';
  static const String enCours = 'EN_COURS';
  static const String approuvee = 'APPROUVEE';
  static const String rejetee = 'REJETEE';
  static const String annulee = 'ANNULEE';

  static String libelle(String statut) {
    switch (statut) {
      case enAttente:
        return 'En attente';
      case enCours:
        return 'En cours de traitement';
      case approuvee:
        return 'Approuvée';
      case rejetee:
        return 'Rejetée';
      case annulee:
        return 'Annulée';
      default:
        return statut;
    }
  }
}

/// Demande de financement soumise par l'entrepreneur (US7).
class DemandeModel {
  final String id;
  final String offreId;
  final double montantDemande;
  final String objetDemande;
  final String statut;
  final DateTime dateDepot;
  final DateTime dateMajStatut;
  final String? motifRejet;
  final double? scoreAuDepot;

  DemandeModel({
    required this.id,
    required this.offreId,
    required this.montantDemande,
    required this.objetDemande,
    required this.statut,
    required this.dateDepot,
    required this.dateMajStatut,
    this.motifRejet,
    this.scoreAuDepot,
  });

  bool get estAnnulable => statut == StatutDemande.enAttente;

  factory DemandeModel.fromJson(Map<String, dynamic> json) {
    return DemandeModel(
      id: json['id'] as String,
      offreId: json['offre_id'] as String,
      montantDemande: double.parse(json['montant_demande'].toString()),
      objetDemande: json['objet_demande'] as String? ?? '',
      statut: json['statut'] as String,
      dateDepot: DateTime.parse(json['date_depot'] as String),
      dateMajStatut: DateTime.parse(json['date_maj_statut'] as String),
      motifRejet: json['motif_rejet'] as String?,
      scoreAuDepot: json['score_au_depot'] != null ? (json['score_au_depot'] as num).toDouble() : null,
    );
  }
}
