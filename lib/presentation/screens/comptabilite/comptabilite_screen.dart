import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';

/// Point d'entrée historique de la section "Comptabilité".
/// Redirige vers le nouveau Dashboard (Tableau de bord & Compta).
class ComptabiliteScreen extends StatelessWidget {
  const ComptabiliteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}