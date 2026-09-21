import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/entreprise_provider.dart';
import '../theme/app_colors.dart';

/// Menu déroulant pour choisir l'entreprise à laquelle rattacher une
/// transaction. Si l'entrepreneur n'a aucune entreprise, propose d'en
/// créer une rapidement (obligatoire côté API pour toute transaction).
class EntrepriseSelector extends StatelessWidget {
  const EntrepriseSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EntrepriseProvider>();

    if (provider.isLoading) {
      return const LinearProgressIndicator();
    }

    if (!provider.aAuMoinsUneEntreprise) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.errorSoftBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Aucune entreprise enregistrée. Créez-en une pour continuer.",
                style: TextStyle(color: AppColors.error),
              ),
            ),
            TextButton(
              onPressed: () => _creerEntreprise(context),
              child: const Text('Créer'),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: provider.selectionnee?.id,
      decoration: const InputDecoration(labelText: 'Entreprise'),
      items: provider.entreprises
          .map((e) => DropdownMenuItem(value: e.id, child: Text(e.raisonSociale)))
          .toList(),
      onChanged: (id) {
        final entreprise = provider.entreprises.firstWhere((e) => e.id == id);
        provider.selectionner(entreprise);
      },
      validator: (value) => value == null ? 'Sélectionnez une entreprise' : null,
    );
  }

  Future<void> _creerEntreprise(BuildContext context) async {
    final controller = TextEditingController();
    final nom = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouvelle entreprise'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Raison sociale'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
    if (nom != null && nom.isNotEmpty && context.mounted) {
      await context.read<EntrepriseProvider>().creerEntreprise(nom);
    }
  }
}
