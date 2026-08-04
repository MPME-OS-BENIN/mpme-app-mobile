import 'package:flutter/material.dart';
import 'package:mpme_app_mobile/presentation/screens/auth/inscription.dart';
import 'package:path/path.dart';
import '../screens/auth/login_screen.dart';
import '../screens/comptabilite/comptabilite_screen.dart';
import '../screens/financement/financement_screen.dart';
import '../screens/formalisation/formalisation_screen.dart';
import '../screens/score/score_screen.dart';
import '../screens/auth/code_otp.dart';

class AppRoutes {
  static const String login = '/login';
  static const String comptabilite = '/comptabilite';
  static const String financement = '/financement';
  static const String formalisation = '/formalisation';
  static const String score = '/score';
  static const String codeOTP = '/codeOTP';
  static const String inscription = '/inscription';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    comptabilite: (context) => const ComptabiliteScreen(),
    financement: (context) => const FinancementScreen(),
    formalisation: (context) => const FormalisationScreen(),
    score: (context) => const ScoreScreen(),
    codeOTP: (context) => const CodeOTP(),
    inscription: (context) => const Inscription(),
  };
}
