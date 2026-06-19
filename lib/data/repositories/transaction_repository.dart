import '../models/transaction_model.dart';
import '../services/database_service.dart';

class TransactionRepository {
  final DatabaseService _databaseService = DatabaseService();

  // Enregistre une transaction localement
  // (hors-ligne ou en attente de sync)
  Future<void> enregistrerTransaction(TransactionModel transaction) async {
    await _databaseService.insertTransaction(transaction);
  }

  // Récupère toutes les transactions
  Future<List<TransactionModel>> obtenirToutesLesTransactions() async {
    return await _databaseService.getAllTransactions();
  }

  // Récupère uniquement celles pas encore envoyées au serveur
  Future<List<TransactionModel>> obtenirTransactionsNonSynchronisees() async {
    return await _databaseService.getUnsyncedTransactions();
  }

  // Marque une transaction comme envoyée au serveur
  Future<void> marquerCommeSynchronisee(String id) async {
    await _databaseService.markAsSynchronised(id);
  }
}