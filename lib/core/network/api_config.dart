class ApiConfig {
  ApiConfig._();

  /// Adapte cette URL selon l'environnement (émulateur Android -> 10.0.2.2,
  /// device physique -> IP locale du serveur Django, prod -> domaine réel).
  static const String baseUrl = 'http://10.0.2.2:8000';

  static const String canal = 'MOBILE';

  // Auth
  static const String register = '/api/auth/register/';
  static const String login = '/api/auth/login/';
  static const String refreshToken = '/api/auth/token/refresh/';
  static const String me = '/api/auth/me/';
  static const String meLangue = '/api/auth/me/langue/';

  // Entreprises
  static const String entreprises = '/api/entreprises/';
  static String entrepriseDetail(String id) => '/api/entreprises/$id/';

  // Transactions
  static const String transactions = '/api/transactions/';
  static const String transactionBenefice = '/api/transactions/benefice/';
  static const String transactionRapport = '/api/transactions/rapport/';
  static String transactionDetail(String id) => '/api/transactions/$id/';

  // Score financier
  static const String scoreMonScore = '/api/scores/mon-score/';

  // Offres de financement
  static const String offres = '/api/offres/';
  static String offreDetail(String id) => '/api/offres/$id/';

  // Demandes de financement
  static const String demandes = '/api/demandes/';
  static String demandeDetail(String id) => '/api/demandes/$id/';
  static String demandeAnnuler(String id) => '/api/demandes/$id/annuler/';

  // Formalisation (guide IFU/RCCM, imbriqué sous l'entreprise)
  static String formalisationGuide(String entrepriseId) =>
      '/api/entreprises/$entrepriseId/formalisation/';
  static String formalisationEtape(String entrepriseId, String etapeId) =>
      '/api/entreprises/$entrepriseId/formalisation/$etapeId/';
}
