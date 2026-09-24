import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/auth_provider.dart';
import '../../navigation/app_routes.dart';

/// Écran Réglages minimal : le 3e onglet interne de la maquette
/// Formalisation ("Réglages", confirmé par le produit le 2026-09-22)
/// n'a pas de contenu défini dans le Product Backlog. On couvre ici ce
/// qui a un vrai support backend : la préférence de langue (US10, réglage
/// seul — la traduction des interfaces elle-même est un chantier séparé)
/// et la déconnexion.
class ReglagesScreen extends StatefulWidget {
  const ReglagesScreen({super.key});

  @override
  State<ReglagesScreen> createState() => _ReglagesScreenState();
}

class _ReglagesScreenState extends State<ReglagesScreen> {
  bool _enregistrementEnCours = false;

  Future<void> _choisirLangue(String code) async {
    setState(() => _enregistrementEnCours = true);
    final ok = await context.read<AuthProvider>().changerLangue(code);
    if (!mounted) return;
    setState(() => _enregistrementEnCours = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Langue mise à jour.')),
      );
    }
  }

  Future<void> _seDeconnecter() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Se déconnecter')),
        ],
      ),
    );
    if (confirme != true || !mounted) return;
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.onboarding, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final langueActuelle = auth.profil?['langue_preference'] as String? ?? 'fr';

    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Langue', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<String>(
              groupValue: langueActuelle,
              onChanged: (v) {
                if (_enregistrementEnCours || v == null) return;
                _choisirLangue(v);
              },
              child: const Column(
                children: [
                  RadioListTile<String>(title: Text('Français'), value: 'fr'),
                  RadioListTile<String>(title: Text('Fon'), value: 'fon'),
                  RadioListTile<String>(title: Text('Yoruba'), value: 'yor'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Opacity(
            opacity: 0.7,
            child: Text(
              "Seule la préférence est enregistrée pour l'instant : la "
              "traduction complète des écrans en fon/yoruba (US10) reste à "
              "développer.",
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _seDeconnecter,
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: const Text('Se déconnecter', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
            ),
          ),
        ],
      ),
    );
  }
}
