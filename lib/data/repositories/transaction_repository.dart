import '../models/transaction_model.dart';
import '../services/database_service.dart';
import '../services/transaction_api_service.dart';
import '../../core/network/api_client.dart';

class TransactionRepository {
  final DatabaseService _databaseService = DatabaseService();
  final TransactionApiService _api = TransactionApiService();

  /// Enregistre d'abord en local (l'écran reste utilisable hors-ligne),
  /// puis tente immédiatement la synchronisation avec le serveur.
  /// Retourne la transaction telle que connue en local (avec son statut
  /// éventuellement mis à jour si la sync a réussi).
  Future<TransactionModel> enregistrerTransaction(TransactionModel transaction) async {
    await _databaseService.insertTransaction(transaction);
    try {
      final synced = await _api.creer(transaction);
      final withStatus = synced.copyWith(statutSynchronisation: StatutSync.synchronise);
      await _databaseService.markAsSynchronised(transaction.id, hash: synced.hashVerification);
      return withStatus;
    } catch (_) {
      // Pas de réseau ou erreur serveur : la transaction reste en LOCAL,
      // elle sera renvoyée plus tard via synchroniserEnAttente().
      return transaction;
    }
  }

  /// Récupère toutes les transactions locales (vue immédiate, hors-ligne friendly).
  Future<List<TransactionModel>> obtenirToutesLesTransactions() async {
    return await _databaseService.getAllTransactions();
  }

  /// Récupère uniquement celles pas encore envoyées au serveur.
  Future<List<TransactionModel>> obtenirTransactionsNonSynchronisees() async {
    return await _databaseService.getUnsyncedTransactions();
  }

  /// Tente de renvoyer toutes les transactions en attente (à appeler par ex.
  /// au retour de connexion, ou périodiquement).
  Future<void> synchroniserEnAttente() async {
    final enAttente = await _databaseService.getUnsyncedTransactions();
    for (final t in enAttente) {
      try {
        final synced = await _api.creer(t);
        await _databaseService.markAsSynchronised(t.id, hash: synced.hashVerification);
      } catch (_) {
        // on continue avec les suivantes, celle-ci reste en attente
      }
    }
  }

  /// Rafraîchit le cache local depuis le serveur (source de vérité) et
  /// retourne la liste à jour. En cas d'échec réseau, retourne le cache local.
  Future<List<TransactionModel>> rafraichirDepuisServeur({
    String? dateDebut,
    String? dateFin,
    String? typeTransaction,
  }) async {
    try {
      final distantes = await _api.lister(
        dateDebut: dateDebut,
        dateFin: dateFin,
        typeTransaction: typeTransaction,
      );
      // On ne remplace pas les transactions locales encore en attente de sync
      final enAttente = await _databaseService.getUnsyncedTransactions();
      await _databaseService.replaceAll([...distantes, ...enAttente]);
      return await _databaseService.getAllTransactions();
    } on ApiException {
      return await _databaseService.getAllTransactions();
    } catch (_) {
      return await _databaseService.getAllTransactions();
    }
  }
}
