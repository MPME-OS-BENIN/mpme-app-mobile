import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/score_model.dart';

class ScoreApiService {
  final _client = ApiClient.instance;

  Future<ScoreModel> monScore() async {
    final data = await _client.get(ApiConfig.scoreMonScore);
    return ScoreModel.fromJson(data as Map<String, dynamic>);
  }
}
