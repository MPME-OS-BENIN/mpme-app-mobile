import 'package:flutter/foundation.dart';
import '../models/entreprise_model.dart';
import '../services/entreprise_api_service.dart';
import '../../core/network/api_client.dart';

class EntrepriseProvider extends ChangeNotifier {
  final _api = EntrepriseApiService();

  List<EntrepriseModel> _entreprises = [];
  EntrepriseModel? _selectionnee;
  bool _isLoading = false;
  bool _horsLigne = false;
  String? _erreur;

  List<EntrepriseModel> get entreprises => _entreprises;
  EntrepriseModel? get selectionnee => _selectionnee;
  bool get isLoading => _isLoading;
  bool get estHorsLigne => _horsLigne;
  String? get erreur => _erreur;
  bool get aAuMoinsUneEntreprise => _entreprises.isNotEmpty;

  Future<void> charger() async {
    _isLoading = true;
    _erreur = null;
    _horsLigne = false;
    notifyListeners();
    try {
      _entreprises = await _api.lister();
      if (_entreprises.isNotEmpty) {
        _selectionnee ??= _entreprises.first;
      }
    } on ApiException catch (e) {
      _erreur = e.message;
    } catch (_) {
      // Pas de cache local pour les entreprises (hors périmètre offline-first,
      // limité à la comptabilité) : sans connexion, la liste reste simplement
      // indisponible pour l'instant, ce n'est pas une erreur applicative.
      _horsLigne = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectionner(EntrepriseModel entreprise) {
    _selectionnee = entreprise;
    notifyListeners();
  }

  Future<bool> creerEntreprise(String raisonSociale) async {
    try {
      final nouvelle = await _api.creer(raisonSociale: raisonSociale);
      _entreprises = [..._entreprises, nouvelle];
      _selectionnee = nouvelle;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _erreur = e.message;
      notifyListeners();
      return false;
    }
  }
}
