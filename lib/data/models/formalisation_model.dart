class StatutEtape {
  static const String nonCommence = 'NON_COMMENCE';
  static const String enCours = 'EN_COURS';
  static const String termine = 'TERMINE';

  static String libelle(String statut) {
    switch (statut) {
      case nonCommence:
        return 'Non commencé';
      case enCours:
        return 'En cours';
      case termine:
        return 'Terminé';
      default:
        return statut;
    }
  }
}

/// Une étape du parcours IFU/RCCM (US12).
///
/// NOTE : `documentsRequis` est une liste de référence en lecture seule
/// côté backend (EtapeStatutSerializer n'accepte que `statut`). Il n'existe
/// aucun champ pour persister l'état individuel de chaque document — la
/// maquette montre des cases à cocher par document, mais rien ne permet de
/// sauvegarder cet état côté serveur. Affiché ici comme simple liste
/// informative, pas comme des cases interactives (pour ne pas suggérer une
/// persistance qui n'existe pas).
class EtapeFormalisationModel {
  final String id;
  final String titre;
  final String description;
  final List<String> documentsRequis;
  final String statut;
  final int ordre;
  final DateTime dateMaj;

  EtapeFormalisationModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.documentsRequis,
    required this.statut,
    required this.ordre,
    required this.dateMaj,
  });

  factory EtapeFormalisationModel.fromJson(Map<String, dynamic> json) {
    return EtapeFormalisationModel(
      id: json['id'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String? ?? '',
      documentsRequis: (json['documents_requis'] as List?)?.cast<String>() ?? const [],
      statut: json['statut'] as String,
      ordre: json['ordre'] as int,
      dateMaj: DateTime.parse(json['date_maj'] as String),
    );
  }
}

class GuideFormalisationModel {
  final String entrepriseId;
  final String statutFormalisation;
  final double progression; // 0-100
  final List<EtapeFormalisationModel> etapes;

  GuideFormalisationModel({
    required this.entrepriseId,
    required this.statutFormalisation,
    required this.progression,
    required this.etapes,
  });

  factory GuideFormalisationModel.fromJson(Map<String, dynamic> json) {
    return GuideFormalisationModel(
      entrepriseId: json['entreprise_id'] as String,
      statutFormalisation: json['statut_formalisation'] as String,
      progression: (json['progression'] as num).toDouble(),
      etapes: (json['etapes'] as List<dynamic>)
          .map((e) => EtapeFormalisationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
