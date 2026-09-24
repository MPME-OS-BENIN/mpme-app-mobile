import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/demande_provider.dart';
import 'data/providers/entreprise_provider.dart';
import 'data/providers/formalisation_provider.dart';
import 'data/providers/offre_provider.dart';
import 'data/providers/score_provider.dart';
import 'data/providers/transaction_provider.dart';
import 'presentation/navigation/app_routes.dart';
import 'presentation/screens/auth/auth_gate.dart';

void main() {
  runApp(const MpmeApp());
}

class MpmeApp extends StatelessWidget {
  const MpmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EntrepriseProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ScoreProvider()),
        ChangeNotifierProvider(create: (_) => OffreProvider()),
        ChangeNotifierProvider(create: (_) => DemandeProvider()),
        ChangeNotifierProvider(create: (_) => FormalisationProvider()),
      ],
      child: MaterialApp(
        title: 'MPME OS',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
