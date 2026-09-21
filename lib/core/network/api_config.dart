class ApiConfig {
  ApiConfig._();

  /// Adapte cette URL selon l'environnement (émulateur Android -> 10.0.2.2,
  /// device physique -> IP locale du serveur Django, prod -> domaine réel).
  static const String baseUrl = 'http://127.0.0.1:8000';

  static const String canal = 'MOBILE';

  // Auth
  static const String register = '/api/auth/register/';
  static const String login = '/api/auth/login/';
  static const String refreshToken = '/api/auth/token/refresh/';
  static const String me = '/api/auth/me/';

  // Entreprises
  static const String entreprises = '/api/entreprises/';
  static String entrepriseDetail(String id) => '/api/entreprises/$id/';

  // Transactions
  static const String transactions = '/api/transactions/';
  static const String transactionBenefice = '/api/transactions/benefice/';
  static const String transactionRapport = '/api/transactions/rapport/';
  static String transactionDetail(String id) => '/api/transactions/$id/';
}
