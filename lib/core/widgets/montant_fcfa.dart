import 'package:intl/intl.dart';

/// Formate un montant en FCFA avec séparateur de milliers, ex: 452 500 FCFA.
String formatFcfa(double montant) {
  final formatter = NumberFormat('#,##0', 'fr_FR');
  return '${formatter.format(montant).replaceAll(',', ' ')} FCFA';
}

String formatFcfaSigne(double montant) {
  final signe = montant >= 0 ? '+' : '-';
  return '$signe${formatFcfa(montant.abs())}';
}
