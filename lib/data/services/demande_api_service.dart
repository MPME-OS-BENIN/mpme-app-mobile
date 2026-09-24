import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/demande_model.dart';

class DemandeApiService {
  final _client = ApiClient.instance;

  /// Idem OffreApiService : première page seulement pour l'instant.
  Future<List<DemandeModel>> lister({String? statut}) async {
    final query = <String, String>{
      'statut': ?statut,
    };
    final data = await _client.get(ApiConfig.demandes, query: query);
    final results = (data as Map<String, dynamic>)['results'] as List<dynamic>;
    return results.map((e) => DemandeModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<DemandeModel> creer({
    required String offreId,
    required double montantDemande,
    required String objetDemande,
  }) async {
    final data = await _client.post(ApiConfig.demandes, body: {
      'offre_id': offreId,
      'montant_demande': montantDemande,
      'objet_demande': objetDemande,
    });
    return DemandeModel.fromJson(data as Map<String, dynamic>);
  }

  Future<DemandeModel> annuler(String id) async {
    final data = await _client.patch(ApiConfig.demandeAnnuler(id));
    return DemandeModel.fromJson(data as Map<String, dynamic>);
  }
}
