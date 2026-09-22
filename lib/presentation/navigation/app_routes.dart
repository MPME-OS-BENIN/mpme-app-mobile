import 'package:flutter/material.dart';
import '../screens/auth/inscription.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/onboarding.dart';
import '../screens/comptabilite/comptabilite_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/financement/financement_screen.dart';
import '../screens/formalisation/formalisation_screen.dart';
import '../screens/score/score_screen.dart';
import '../screens/transactions/livre_de_caisse_screen.dart';
import '../screens/transactions/saisie_depense_screen.dart';
import '../screens/transactions/saisie_vente_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String inscription = '/inscription';
  static const String comptabilite = '/comptabilite';
  static const String dashboard = '/dashboard';
  static const String saisieVente = '/saisie-vente';
  static const String saisieDepense = '/saisie-depense';
  static const String livreDeCaisse = '/livre-de-caisse';
  static const String financement = '/financement';
  static const String formalisation = '/formalisation';
  static const String score = '/score';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const Onboarding(),
    login: (context) => const LoginScreen(),
    inscription: (context) => const Inscription(),
    comptabilite: (context) => const ComptabiliteScreen(),
    dashboard: (context) => const DashboardScreen(),
    saisieVente: (context) => const SaisieVenteScreen(),
    saisieDepense: (context) => const SaisieDepenseScreen(),
    livreDeCaisse: (context) => const LivreDeCaisseScreen(),
    financement: (context) => const FinancementScreen(),
    formalisation: (context) => const FormalisationScreen(),
    score: (context) => const ScoreScreen(),
  };
}
