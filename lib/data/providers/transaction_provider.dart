import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();
  final _uuid = const Uuid();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _erreur;

  // Filtres pour le livre de caisse
  String? _filtreType; // VENTE | DEPENSE | null (tous)
  DateTime? _filtreDateDebut;
  DateTime? _filtreDateFin;

  List<TransactionModel> get transactions {
    var liste = List<TransactionModel>.from(_transactions);
    if (_filtreType != null) {
      liste = liste.where((t) => t.typeTransaction == _filtreType).toList();
    }
    if (_filtreDateDebut != null) {
      liste = liste.where((t) => !t.dateEffective.isBefore(_filtreDateDebut!)).toList();
    }
    if (_filtreDateFin != null) {
      liste = liste.where((t) => !t.dateEffective.isAfter(_filtreDateFin!)).toList();
    }
    return liste;
  }

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get erreur => _erreur;
  String? get filtreType => _filtreType;

  double get totalVentes => _transactions.where((t) => t.estVente).fold(0.0, (s, t) => s + t.montant);
  double get totalDepenses => _transactions.where((t) => t.estDepense).fold(0.0, (s, t) => s + t.montant);
  double get soldeDeCaisse => totalVentes - totalDepenses;

  List<TransactionModel> get activitesRecentes {
    final triees = List<TransactionModel>.from(_transactions)
      ..sort((a, b) => b.dateEffective.compareTo(a.dateEffective));
    return triees.take(5).toList();
  }

  Future<void> charger({String? entrepriseId}) async {
    _isLoading = true;
    _erreur = null;
    notifyListeners();
    try {
      _transactions = await _repository.rafraichirDepuisServeur();
    } catch (_) {
      _erreur = 'Affichage des données locales (hors-ligne).';
      _transactions = await _repository.obtenirToutesLesTransactions();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void appliquerFiltreType(String? type) {
    _filtreType = type;
    notifyListeners();
  }

  void appliquerFiltreDates(DateTime? debut, DateTime? fin) {
    _filtreDateDebut = debut;
    _filtreDateFin = fin;
    notifyListeners();
  }

  void reinitialiserFiltres() {
    _filtreType = null;
    _filtreDateDebut = null;
    _filtreDateFin = null;
    notifyListeners();
  }

  /// Crée une vente ou une dépense. `entrepriseId` doit être celle
  /// sélectionnée par l'utilisateur (EntrepriseProvider).
  Future<bool> creerTransaction({
    required String entrepriseId,
    required String type,
    required double montant,
    String? description,
    String? categorieDepense,
    DateTime? date,
  }) async {
    _isSubmitting = true;
    _erreur = null;
    notifyListeners();
    try {
      final transaction = TransactionModel(
        id: _uuid.v4(),
        entrepriseId: entrepriseId,
        typeTransaction: type,
        montant: montant,
        description: description,
        categorieDepense: categorieDepense,
        dateEffective: date ?? DateTime.now(),
      );
      final enregistree = await _repository.enregistrerTransaction(transaction);
      _transactions = [enregistree, ..._transactions];
      return true;
    } catch (e) {
      _erreur = 'Impossible d\'enregistrer la transaction.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
