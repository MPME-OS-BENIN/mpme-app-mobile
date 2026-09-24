import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/entreprise_selector.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../data/models/formalisation_model.dart';
import '../../../data/providers/entreprise_provider.dart';
import '../../../data/providers/formalisation_provider.dart';
import '../../navigation/app_routes.dart';

class FormalisationScreen extends StatefulWidget {
  const FormalisationScreen({super.key});

  @override
  State<FormalisationScreen> createState() => _FormalisationScreenState();
}

class _FormalisationScreenState extends State<FormalisationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _charger());
  }

  Future<void> _charger() async {
    final entrepriseProvider = context.read<EntrepriseProvider>();
    if (entrepriseProvider.entreprises.isEmpty) {
      await entrepriseProvider.charger();
      if (!mounted) return;
    }
    final entreprise = entrepriseProvider.selectionnee;
    if (entreprise == null) return;
    await context.read<FormalisationProvider>().charger(entreprise.id);
  }

  @override
  Widget build(BuildContext context) {
    final entrepriseProvider = context.watch<EntrepriseProvider>();
    final formalisationProvider = context.watch<FormalisationProvider>();
    final entreprise = entrepriseProvider.selectionnee;

    return Scaffold(
      appBar: AppBar(title: const Text('Formalisation')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _PillTabs(
              onFinancement: () => Navigator.pushReplacementNamed(context, AppRoutes.financement),
              onReglages: () => Navigator.pushNamed(context, AppRoutes.reglages),
            ),
          ),
          if (formalisationProvider.estHorsLigne) const OfflineBanner(),
          Expanded(
            child: entrepriseProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : !entrepriseProvider.aAuMoinsUneEntreprise
                    ? const SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Créez d'abord votre entreprise pour accéder au "
                              "guide de formalisation.",
                              style: TextStyle(color: AppColors.neutralGrey),
                            ),
                            SizedBox(height: 16),
                            EntrepriseSelector(),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _charger,
                        child: _ContenuGuide(
                          provider: formalisationProvider,
                          entrepriseId: entreprise!.id,
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: AppTab.financement),
    );
  }
}

/// Reproduit les pill-tabs de la maquette (Formalisation | Financement |
/// Réglages). "Formalisation" est l'onglet courant (pas de navigation) ;
/// les deux autres renvoient vers leurs écrans dédiés respectifs.
class _PillTabs extends StatelessWidget {
  final VoidCallback onFinancement;
  final VoidCallback onReglages;
  const _PillTabs({required this.onFinancement, required this.onReglages});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Pill(label: 'Formalisation', active: true, onTap: () {}),
          const SizedBox(width: 8),
          _Pill(label: 'Financement', active: false, onTap: onFinancement),
          const SizedBox(width: 8),
          _Pill(label: 'Réglages', active: false, onTap: onReglages),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Pill({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceSoft2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.deepBrown,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ContenuGuide extends StatelessWidget {
  final FormalisationProvider provider;
  final String entrepriseId;
  const _ContenuGuide({required this.provider, required this.entrepriseId});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading && provider.guide == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final guide = provider.guide;
    if (guide == null) {
      // Erreur ou hors-ligne, rien à afficher : message + bouton réessayer.
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (provider.erreur != null) ErrorBanner(message: provider.erreur!),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: () => provider.charger(entrepriseId),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
            ),
          ),
        ],
      );
    }

    if (guide.etapes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Aucune étape de formalisation définie pour le moment.'),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.tertiaryContainerOrange,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Votre Progression', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (guide.progression / 100).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: AppColors.divider,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${guide.etapes.where((e) => e.statut == StatutEtape.termine).length} '
                'sur ${guide.etapes.length} étapes complétées',
                style: const TextStyle(color: AppColors.neutralGrey, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (provider.erreur != null) ...[
          ErrorBanner(message: provider.erreur!),
          const SizedBox(height: 12),
        ],
        ...guide.etapes.map(
          (e) => _EtapeTile(
            etape: e,
            enCoursDeMaj: provider.isUpdating,
            onChangerStatut: (statut) => provider.changerStatutEtape(
              entrepriseId: entrepriseId,
              etapeId: e.id,
              statut: statut,
            ),
          ),
        ),
      ],
    );
  }
}

class _EtapeTile extends StatelessWidget {
  final EtapeFormalisationModel etape;
  final bool enCoursDeMaj;
  final Future<bool> Function(String statut) onChangerStatut;
  const _EtapeTile({required this.etape, required this.enCoursDeMaj, required this.onChangerStatut});

  @override
  Widget build(BuildContext context) {
    final termine = etape.statut == StatutEtape.termine;
    final enCours = etape.statut == StatutEtape.enCours;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: enCoursDeMaj ? null : () => _ouvrirChoixStatut(context),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: termine
                      ? AppColors.primary
                      : enCours
                          ? Colors.white
                          : AppColors.surfaceSoft2,
                  child: termine
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${etape.ordre}',
                          style: TextStyle(
                            color: enCours ? AppColors.primary : AppColors.neutralGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etape.titre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: termine ? AppColors.primary : AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(etape.description, style: const TextStyle(color: AppColors.neutralGrey)),
                if (etape.documentsRequis.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: etape.documentsRequis
                        .map((doc) => Chip(
                              label: Text(doc, style: const TextStyle(fontSize: 11)),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 6),
                TextButton(
                  onPressed: enCoursDeMaj ? null : () => _ouvrirChoixStatut(context),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 48)),
                  child: Text(StatutEtape.libelle(etape.statut)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _ouvrirChoixStatut(BuildContext context) async {
    final choisi = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(StatutEtape.libelle(StatutEtape.nonCommence)),
              onTap: () => Navigator.pop(ctx, StatutEtape.nonCommence),
            ),
            ListTile(
              title: Text(StatutEtape.libelle(StatutEtape.enCours)),
              onTap: () => Navigator.pop(ctx, StatutEtape.enCours),
            ),
            ListTile(
              title: Text(StatutEtape.libelle(StatutEtape.termine)),
              onTap: () => Navigator.pop(ctx, StatutEtape.termine),
            ),
          ],
        ),
      ),
    );
    if (choisi != null && choisi != etape.statut) {
      await onChangerStatut(choisi);
    }
  }
}
