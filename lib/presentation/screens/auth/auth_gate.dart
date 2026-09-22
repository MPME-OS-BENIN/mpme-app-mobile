import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/auth_provider.dart';
import '../../navigation/app_routes.dart';

/// Point d'entrée réel de l'app (remplace l'ancien `home: Onboarding()`
/// fixe). Tente de restaurer une session existante à partir du token
/// stocké de façon sécurisée ; si elle est valide, va directement au
/// tableau de bord au lieu de repasser par l'onboarding et la connexion.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decider());
  }

  Future<void> _decider() async {
    final auth = context.read<AuthProvider>();
    final connecte = await auth.restaurerSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      connecte ? AppRoutes.dashboard : AppRoutes.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.tertiaryBg,
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}
