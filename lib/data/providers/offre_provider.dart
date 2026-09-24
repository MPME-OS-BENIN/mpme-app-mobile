import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/offre_model.dart';
import '../services/offre_api_service.dart';

class OffreProvider extends ChangeNotifier {
  final _api = OffreApiService();

  List<OffreModel> _offres = [];
  bool _isLoading = false;
  bool _horsLigne = false;
  String? _erreur;
  String? _filtreType;

  List<OffreModel> get offres => _offres;
  bool get isLoading => _isLoading;
  bool get estHorsLigne => _horsLigne;
  String? get erreur => _erreur;
  String? get filtreType => _filtreType;

  Future<void> charger() async {
    _isLoading = true;
    _erreur = null;
    _horsLigne = false;
    notifyListeners();
    try {
      _offres = await _api.lister(typeFinancement: _filtreType);
    } on ApiException catch (e) {
      _erreur = e.message;
    } catch (_) {
      // Pas de cache local pour les offres (hors périmètre offline-first,
      // limité à la comptabilité) : simplement indisponible hors-ligne.
      _horsLigne = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> appliquerFiltreType(String? type) async {
    _filtreType = type;
    await charger();
  }
}
