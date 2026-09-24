import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/formalisation_model.dart';

class FormalisationApiService {
  final _client = ApiClient.instance;

  Future<GuideFormalisationModel> guide(String entrepriseId) async {
    final data = await _client.get(ApiConfig.formalisationGuide(entrepriseId));
    return GuideFormalisationModel.fromJson(data as Map<String, dynamic>);
  }

  /// Retourne l'étape mise à jour et la nouvelle progression globale.
  Future<({EtapeFormalisationModel etape, double progression, String statutFormalisation})> majEtape({
    required String entrepriseId,
    required String etapeId,
    required String statut,
  }) async {
    final data = await _client.patch(
      ApiConfig.formalisationEtape(entrepriseId, etapeId),
      body: {'statut': statut},
    );
    final map = data as Map<String, dynamic>;
    return (
      etape: EtapeFormalisationModel.fromJson(map['etape'] as Map<String, dynamic>),
      progression: (map['progression'] as num).toDouble(),
      statutFormalisation: map['statut_formalisation'] as String,
    );
  }
}
