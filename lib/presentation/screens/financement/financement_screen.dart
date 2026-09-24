import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/montant_fcfa.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../data/models/demande_model.dart';
import '../../../data/models/offre_model.dart';
import '../../../data/providers/demande_provider.dart';
import '../../../data/providers/offre_provider.dart';

class FinancementScreen extends StatefulWidget {
  const FinancementScreen({super.key});

  @override
  State<FinancementScreen> createState() => _FinancementScreenState();
}

class _FinancementScreenState extends State<FinancementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _charger());
  }

  Future<void> _charger() async {
    await context.read<OffreProvider>().charger();
    if (!mounted) return;
    await context.read<DemandeProvider>().charger();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Financement'),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.neutralGrey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Offres'),
              Tab(text: 'Mes demandes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OffresTab(onDemandeEnvoyee: _charger),
            const _DemandesTab(),
          ],
        ),
        bottomNavigationBar: const AppBottomNav(current: AppTab.financement),
      ),
    );
  }
}

class _OffresTab extends StatelessWidget {
  final Future<void> Function() onDemandeEnvoyee;
  const _OffresTab({required this.onDemandeEnvoyee});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OffreProvider>();

    return RefreshIndicator(
      onRefresh: provider.charger,
      child: Column(
        children: [
          if (provider.estHorsLigne) const OfflineBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _FiltresTypeRow(provider: provider),
                const SizedBox(height: 12),
                if (provider.erreur != null) ...[
                  ErrorBanner(message: provider.erreur!),
                  const SizedBox(height: 12),
                ],
                if (provider.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.offres.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('Aucune offre disponible pour le moment.')),
                  )
                else
                  ...provider.offres.map(
                    (o) => _OffreCard(
                      offre: o,
                      onDemander: () => _ouvrirFormulaireDemande(context, o),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _ouvrirFormulaireDemande(BuildContext context, OffreModel offre) async {
    final envoyee = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _FormulaireDemandeSheet(offre: offre),
    );
    if (envoyee == true) {
      await onDemandeEnvoyee();
    }
  }
}

class _FiltresTypeRow extends StatelessWidget {
  final OffreProvider provider;
  const _FiltresTypeRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Tous'),
            selected: provider.filtreType == null,
            onSelected: (_) => provider.appliquerFiltreType(null),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Crédit'),
            selected: provider.filtreType == TypeFinancement.credit,
            onSelected: (_) => provider.appliquerFiltreType(TypeFinancement.credit),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Subvention'),
            selected: provider.filtreType == TypeFinancement.subvention,
            onSelected: (_) => provider.appliquerFiltreType(TypeFinancement.subvention),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Garantie'),
            selected: provider.filtreType == TypeFinancement.garantie,
            onSelected: (_) => provider.appliquerFiltreType(TypeFinancement.garantie),
          ),
        ],
      ),
    );
  }
}

class _OffreCard extends StatelessWidget {
  final OffreModel offre;
  final VoidCallback onDemander;
  const _OffreCard({required this.offre, required this.onDemander});

  @override
  Widget build(BuildContext context) {
    final nonEligible = offre.estEligible == false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    offre.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoftBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    TypeFinancement.libelle(offre.typeFinancement),
                    style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${formatFcfa(offre.montantMin)} — ${formatFcfa(offre.montantMax)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (offre.tauxInteret != null) ...[
              const SizedBox(height: 4),
              Text('Taux : ${offre.tauxInteret}%', style: const TextStyle(color: AppColors.neutralGrey)),
            ],
            if (offre.conditionsEligibilite.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                offre.conditionsEligibilite,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.neutralGrey, fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            if (nonEligible)
              const Text(
                'Vous ne remplissez pas les conditions de cette offre pour le moment.',
                style: TextStyle(color: AppColors.error, fontSize: 12),
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onDemander,
                  child: const Text('Demander ce financement'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FormulaireDemandeSheet extends StatefulWidget {
  final OffreModel offre;
  const _FormulaireDemandeSheet({required this.offre});

  @override
  State<_FormulaireDemandeSheet> createState() => _FormulaireDemandeSheetState();
}

class _FormulaireDemandeSheetState extends State<_FormulaireDemandeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _objetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DemandeProvider>().clearErreur();
    });
  }

  @override
  void dispose() {
    _montantController.dispose();
    _objetController.dispose();
    super.dispose();
  }

  Future<void> _envoyer() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<DemandeProvider>();
    final ok = await provider.soumettre(
      offreId: widget.offre.id,
      montantDemande: double.parse(_montantController.text.replaceAll(' ', '').replaceAll(',', '.')),
      objetDemande: _objetController.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
    }
    // En cas d'échec, provider.erreur est déjà renseigné, affiché ci-dessous.
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DemandeProvider>();
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.offre.titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              'Entre ${formatFcfa(widget.offre.montantMin)} et ${formatFcfa(widget.offre.montantMax)}',
              style: const TextStyle(color: AppColors.neutralGrey),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _montantController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Montant demandé',
                suffixText: 'FCFA',
                prefixIcon: Icon(Icons.payments_rounded, color: AppColors.primary),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Montant requis';
                final parsed = double.tryParse(value.replaceAll(' ', '').replaceAll(',', '.'));
                if (parsed == null || parsed <= 0) return 'Montant invalide';
                if (parsed < widget.offre.montantMin || parsed > widget.offre.montantMax) {
                  return 'Doit être entre ${formatFcfa(widget.offre.montantMin)} et ${formatFcfa(widget.offre.montantMax)}';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _objetController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Objet de la demande",
                hintText: 'Ex: Achat de matériel pour développer mon activité',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return "L'objet de la demande est requis";
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.isSubmitting ? null : _envoyer,
                child: provider.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Envoyer la demande'),
              ),
            ),
            if (provider.erreur != null) ErrorBanner(message: provider.erreur!),
          ],
        ),
      ),
    );
  }
}

class _DemandesTab extends StatelessWidget {
  const _DemandesTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DemandeProvider>();

    return RefreshIndicator(
      onRefresh: provider.charger,
      child: Column(
        children: [
          if (provider.estHorsLigne) const OfflineBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (provider.erreur != null) ...[
                  ErrorBanner(message: provider.erreur!),
                  const SizedBox(height: 12),
                ],
                if (provider.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.demandes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('Vous n\'avez soumis aucune demande pour le moment.')),
                  )
                else
                  ...provider.demandes.map((d) => _DemandeTile(demande: d)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemandeTile extends StatelessWidget {
  final DemandeModel demande;
  const _DemandeTile({required this.demande});

  @override
  Widget build(BuildContext context) {
    final date = demande.dateDepot;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    demande.objetDemande,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                _StatutBadge(statut: demande.statut),
              ],
            ),
            const SizedBox(height: 6),
            Text(formatFcfa(demande.montantDemande), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              'Déposée le ${date.day}/${date.month}/${date.year}',
              style: const TextStyle(fontSize: 12, color: AppColors.neutralGrey),
            ),
            if (demande.statut == StatutDemande.rejetee && demande.motifRejet != null) ...[
              const SizedBox(height: 6),
              Text(
                'Motif : ${demande.motifRejet}',
                style: const TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ],
            if (demande.estAnnulable) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _confirmerAnnulation(context, demande.id),
                  child: const Text('Annuler la demande'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmerAnnulation(BuildContext context, String id) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Annuler la demande ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Non')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Oui, annuler')),
        ],
      ),
    );
    if (confirme == true && context.mounted) {
      await context.read<DemandeProvider>().annuler(id);
    }
  }
}

class _StatutBadge extends StatelessWidget {
  final String statut;
  const _StatutBadge({required this.statut});

  @override
  Widget build(BuildContext context) {
    final couleur = _couleur(statut);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        StatutDemande.libelle(statut),
        style: TextStyle(fontSize: 11, color: couleur, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _couleur(String statut) {
    switch (statut) {
      case StatutDemande.approuvee:
        return AppColors.primary;
      case StatutDemande.rejetee:
        return AppColors.error;
      case StatutDemande.annulee:
        return AppColors.neutralGrey;
      case StatutDemande.enCours:
        return AppColors.goldTertiary;
      default:
        return AppColors.brownTertiaryAlt;
    }
  }
}
