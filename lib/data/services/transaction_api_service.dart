import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/transaction_model.dart';

class BeneficeResult {
  final double chiffreAffaires;
  final double totalDepenses;
  final double beneficeNet;

  BeneficeResult({required this.chiffreAffaires, required this.totalDepenses, required this.beneficeNet});

  factory BeneficeResult.fromJson(Map<String, dynamic> json) {
    return BeneficeResult(
      chiffreAffaires: double.parse(json['chiffre_affaires'].toString()),
      totalDepenses: double.parse(json['total_depenses'].toString()),
      beneficeNet: double.parse(json['benefice_net'].toString()),
    );
  }
}

class TransactionApiService {
  final _client = ApiClient.instance;

  Future<TransactionModel> creer(TransactionModel transaction) async {
    final data = await _client.post(ApiConfig.transactions, body: transaction.toApiJson());
    return TransactionModel.fromApiJson(data as Map<String, dynamic>);
  }

  Future<List<TransactionModel>> lister({
    String? dateDebut,
    String? dateFin,
    String? typeTransaction,
  }) async {
    final query = <String, String>{
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dateFin != null) 'date_fin': dateFin,
      if (typeTransaction != null) 'type_transaction': typeTransaction,
    };
    final data = await _client.get(ApiConfig.transactions, query: query) as List<dynamic>;
    return data.map((e) => TransactionModel.fromApiJson(e as Map<String, dynamic>)).toList();
  }

  Future<BeneficeResult> benefice({String? dateDebut, String? dateFin}) async {
    final query = <String, String>{
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dateFin != null) 'date_fin': dateFin,
    };
    final data = await _client.get(ApiConfig.transactionBenefice, query: query);
    return BeneficeResult.fromJson(data as Map<String, dynamic>);
  }
}
