import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/offre_model.dart';

class OffreApiService {
  final _client = ApiClient.instance;

  /// Liste paginée côté serveur (page_size=20) : on ne récupère que la
  /// première page pour l'instant, cohérent avec un catalogue qui reste
  /// petit dans le prototype. À revoir si le nombre d'offres actives
  /// dépasse 20 (pagination à implémenter côté écran).
  Future<List<OffreModel>> lister({String? typeFinancement}) async {
    final query = <String, String>{
      'type_financement': ?typeFinancement,
    };
    final data = await _client.get(ApiConfig.offres, query: query);
    final results = (data as Map<String, dynamic>)['results'] as List<dynamic>;
    return results.map((e) => OffreModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
