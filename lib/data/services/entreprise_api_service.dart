import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/entreprise_model.dart';

class EntrepriseApiService {
  final _client = ApiClient.instance;

  Future<List<EntrepriseModel>> lister() async {
    final data = await _client.get(ApiConfig.entreprises) as List<dynamic>;
    return data.map((e) => EntrepriseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<EntrepriseModel> creer({required String raisonSociale, String? ifu, String? rccm}) async {
    final data = await _client.post(ApiConfig.entreprises, body: {
      'raison_sociale': raisonSociale,
      if (ifu != null && ifu.isNotEmpty) 'ifu': ifu,
      if (rccm != null && rccm.isNotEmpty) 'rccm': rccm,
    });
    return EntrepriseModel.fromJson(data as Map<String, dynamic>);
  }
}
