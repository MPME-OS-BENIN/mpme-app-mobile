import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  // Instance unique de la base (pattern Singleton)
  static Database? _database;

  // Ouvre la base, la crée si elle n'existe pas encore
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Chemin du fichier sur le téléphone
    String path = join(await getDatabasesPath(), 'mpme_os.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  // Crée la table transactions au premier lancement
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        entrepriseId TEXT NOT NULL,
        type TEXT NOT NULL,
        montant REAL NOT NULL,
        description TEXT,
        categorieDepense TEXT,
        date TEXT NOT NULL,
        statutSynchronisation TEXT NOT NULL,
        hashVerification TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE transactions ADD COLUMN entrepriseId TEXT NOT NULL DEFAULT ''");
    }
  }

  // Insérer une nouvelle transaction
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Lire toutes les transactions (les plus récentes en premier)
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  // Lire uniquement les transactions pas encore synchronisées
  Future<List<TransactionModel>> getUnsyncedTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'statutSynchronisation = ?',
      whereArgs: [StatutSync.local],
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  // Marquer une transaction comme synchronisée
  Future<void> markAsSynchronised(String id, {String? hash}) async {
    final db = await database;
    await db.update(
      'transactions',
      {
        'statutSynchronisation': StatutSync.synchronise,
        'hashVerification': ?hash,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> replaceAll(List<TransactionModel> transactions) async {
    final db = await database;
    final batch = db.batch();
    for (final t in transactions) {
      batch.insert('transactions', t.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
