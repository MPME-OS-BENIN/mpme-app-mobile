import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/demande_model.dart';
import '../services/demande_api_service.dart';

class DemandeProvider extends ChangeNotifier {
  final _api = DemandeApiService();

  List<DemandeModel> _demandes = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _horsLigne = false;
  String? _erreur;

  List<DemandeModel> get demandes => _demandes;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get estHorsLigne => _horsLigne;
  String? get erreur => _erreur;

  Future<void> charger() async {
    _isLoading = true;
    _erreur = null;
    _horsLigne = false;
    notifyListeners();
    try {
      _demandes = await _api.lister();
    } on ApiException catch (e) {
      _erreur = e.message;
    } catch (_) {
      _horsLigne = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Soumet une nouvelle demande. Contrairement à la comptabilité, ceci
  /// n'est PAS offline-first : une demande de financement engage une
  /// institution tierce, elle doit être acceptée par le serveur pour
  /// exister. Sans connexion, l'envoi échoue simplement (message clair).
  Future<bool> soumettre({
    required String offreId,
    required double montantDemande,
    required String objetDemande,
  }) async {
    _isSubmitting = true;
    _erreur = null;
    notifyListeners();
    try {
      final nouvelle = await _api.creer(
        offreId: offreId,
        montantDemande: montantDemande,
        objetDemande: objetDemande,
      );
      _demandes = [nouvelle, ..._demandes];
      return true;
    } on ApiException catch (e) {
      _erreur = e.message;
      return false;
    } catch (_) {
      _erreur = "Impossible d'envoyer la demande. Vérifiez votre connexion.";
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearErreur() {
    if (_erreur == null) return;
    _erreur = null;
    notifyListeners();
  }

  Future<bool> annuler(String id) async {
    try {
      final maj = await _api.annuler(id);
      _demandes = _demandes.map((d) => d.id == id ? maj : d).toList();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _erreur = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _erreur = "Impossible d'annuler la demande. Vérifiez votre connexion.";
      notifyListeners();
      return false;
    }
  }
}
