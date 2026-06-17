import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/comptabilite/comptabilite_screen.dart';
import '../screens/financement/financement_screen.dart';
import '../screens/formalisation/formalisation_screen.dart';
import '../screens/score/score_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String comptabilite = '/comptabilite';
  static const String financement = '/financement';
  static const String formalisation = '/formalisation';
  static const String score = '/score';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    comptabilite: (context) => const ComptabiliteScreen(),
    financement: (context) => const FinancementScreen(),
    formalisation: (context) => const FormalisationScreen(),
    score: (context) => const ScoreScreen(),
  };
}