import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/score_model.dart';
import '../services/score_api_service.dart';

class ScoreProvider extends ChangeNotifier {
  final _api = ScoreApiService();

  ScoreModel? _score;
  bool _isLoading = false;
  bool _horsLigne = false;
  String? _erreur;

  ScoreModel? get score => _score;
  bool get isLoading => _isLoading;
  bool get estHorsLigne => _horsLigne;
  String? get erreur => _erreur;

  Future<void> charger() async {
    _isLoading = true;
    _erreur = null;
    _horsLigne = false;
    notifyListeners();
    try {
      _score = await _api.monScore();
    } on ApiException catch (e) {
      // Réponse du serveur, mais en erreur (ex: profil entrepreneur
      // introuvable, session expirée) : un vrai message, pas juste "hors-ligne".
      _erreur = e.message;
    } catch (_) {
      // Le score est calculé côté serveur (pas de cache local) : sans
      // connexion, il est simplement indisponible pour l'instant.
      _horsLigne = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
