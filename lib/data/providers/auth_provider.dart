import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../../core/storage/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  final _client = ApiClient.instance;
  final _tokenStorage = TokenStorage.instance;

  Map<String, dynamic>? _profil; // réponse brute de /api/auth/me/
  bool _isLoading = false;
  String? _erreur;

  Map<String, dynamic>? get profil => _profil;
  bool get isLoading => _isLoading;
  String? get erreur => _erreur;
  String get prenom => (_profil?['telephone'] ?? '').toString();
  bool get estConnecte => _profil != null;

  Future<bool> restaurerSession() async {
    try {
      final token = await _tokenStorage.accessToken;
      if (token == null) return false;
      final data = await _client.get(ApiConfig.me);
      _profil = data as Map<String, dynamic>;
      notifyListeners();
      return true;
    } catch (_) {
      // Stockage sécurisé indisponible ou token invalide/expiré : on
      // retombe simplement sur le flux de connexion, jamais de crash.
      return false;
    }
  }

  Future<bool> login(String telephone, String password) async {
    _isLoading = true;
    _erreur = null;
    notifyListeners();
    try {
      final data = await _client.post(
        ApiConfig.login,
        body: {'telephone': telephone, 'password': password},
        auth: false,
      );
      await _tokenStorage.saveTokens(access: data['access'], refresh: data['refresh']);
      final me = await _client.get(ApiConfig.me);
      _profil = me as Map<String, dynamic>;
      return true;
    } on ApiException catch (e) {
      _erreur = e.message;
      return false;
    } catch (e) {
      _erreur = 'Impossible de contacter le serveur.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inscrit un nouvel entrepreneur. L'app mobile ne servant que les
  /// entrepreneurs, le rôle est fixé côté client (pas de sélecteur de rôle
  /// dans la maquette mobile).
  ///
  /// IMPORTANT : le modèle `Utilisateur` du backend ne possède pas de champ
  /// nom/prénom (voir apps/authentication/models.py). Le formulaire mobile
  /// les collecte (fidélité à la maquette) mais ils ne sont pour l'instant
  /// pas transmis ni persistés : il n'y a nulle part où les stocker côté
  /// serveur. Signalé côté produit — à ajouter au backend si nécessaire.
  Future<bool> register({
    required String telephone,
    required String password,
    required String secteurActivitePrincipal,
    required String villeResidence,
  }) async {
    _isLoading = true;
    _erreur = null;
    notifyListeners();
    try {
      final data = await _client.post(
        ApiConfig.register,
        body: {
          'telephone': telephone,
          'password': password,
          'role': 'ENTREPRENEUR',
          'secteur_activite_principal': secteurActivitePrincipal,
          'ville_residence': villeResidence,
        },
        auth: false,
      );
      await _tokenStorage.saveTokens(access: data['access'], refresh: data['refresh']);
      final me = await _client.get(ApiConfig.me);
      _profil = me as Map<String, dynamic>;
      return true;
    } on ApiException catch (e) {
      _erreur = e.message;
      return false;
    } catch (e) {
      _erreur = 'Impossible de contacter le serveur.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    _profil = null;
    notifyListeners();
  }
}
