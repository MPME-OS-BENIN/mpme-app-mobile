class EntrepriseModel {
  final String id;
  final String raisonSociale;
  final String? ifu;
  final String? rccm;
  final String statutFormalisation;

  EntrepriseModel({
    required this.id,
    required this.raisonSociale,
    this.ifu,
    this.rccm,
    this.statutFormalisation = 'INFORMEL',
  });

  factory EntrepriseModel.fromJson(Map<String, dynamic> json) {
    return EntrepriseModel(
      id: json['id'],
      raisonSociale: json['raison_sociale'],
      ifu: json['ifu'],
      rccm: json['rccm'],
      statutFormalisation: json['statut_formalisation'] ?? 'INFORMEL',
    );
  }
}
