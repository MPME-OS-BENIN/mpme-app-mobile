import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/formalisation_model.dart';
import '../services/formalisation_api_service.dart';

class FormalisationProvider extends ChangeNotifier {
  final _api = FormalisationApiService();

  GuideFormalisationModel? _guide;
  bool _isLoading = false;
  bool _isUpdating = false;
  bool _horsLigne = false;
  String? _erreur;

  GuideFormalisationModel? get guide => _guide;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  bool get estHorsLigne => _horsLigne;
  String? get erreur => _erreur;

  Future<void> charger(String entrepriseId) async {
    _isLoading = true;
    _erreur = null;
    _horsLigne = false;
    notifyListeners();
    try {
      _guide = await _api.guide(entrepriseId);
    } on ApiException catch (e) {
      _erreur = e.message;
    } catch (_) {
      // Pas de cache local pour le guide (hors périmètre offline-first,
      // limité à la comptabilité) : simplement indisponible hors-ligne.
      _horsLigne = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changerStatutEtape({
    required String entrepriseId,
    required String etapeId,
    required String statut,
  }) async {
    if (_guide == null) return false;
    _isUpdating = true;
    _erreur = null;
    notifyListeners();
    try {
      final resultat = await _api.majEtape(
        entrepriseId: entrepriseId,
        etapeId: etapeId,
        statut: statut,
      );
      final nouvellesEtapes =
          _guide!.etapes.map((e) => e.id == etapeId ? resultat.etape : e).toList();
      _guide = GuideFormalisationModel(
        entrepriseId: _guide!.entrepriseId,
        statutFormalisation: resultat.statutFormalisation,
        progression: resultat.progression,
        etapes: nouvellesEtapes,
      );
      return true;
    } on ApiException catch (e) {
      _erreur = e.message;
      return false;
    } catch (_) {
      _erreur = "Impossible de mettre à jour l'étape. Vérifiez votre connexion.";
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
