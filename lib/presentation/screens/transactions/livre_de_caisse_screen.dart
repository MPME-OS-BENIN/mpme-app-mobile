import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/montant_fcfa.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/providers/transaction_provider.dart';
import '../../navigation/app_routes.dart';

class LivreDeCaisseScreen extends StatefulWidget {
  const LivreDeCaisseScreen({super.key});

  @override
  State<LivreDeCaisseScreen> createState() => _LivreDeCaisseScreenState();
}

class _LivreDeCaisseScreenState extends State<LivreDeCaisseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().charger();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comptabilité : Livre de Caisse'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Transaction'),
        onPressed: () => _ouvrirChoixTransaction(context),
      ),
      body: Column(
        children: [
          if (provider.estHorsLigne) const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => provider.charger(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Suivi chronologique de vos flux de trésorerie.',
                    style: TextStyle(color: AppColors.neutralGrey),
                  ),
                  const SizedBox(height: 16),
                  _ResumeCards(
                    totalVentes: provider.totalVentes,
                    totalDepenses: provider.totalDepenses,
                    solde: provider.soldeDeCaisse,
                  ),
                  const SizedBox(height: 16),
                  _FiltresRow(provider: provider),
                  const SizedBox(height: 8),
                  if (provider.erreur != null) ...[
                    ErrorBanner(message: provider.erreur!),
                    const SizedBox(height: 8),
                  ],
                  if (provider.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (transactions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('Aucune transaction pour le moment.')),
                    )
                  else
                    ...transactions.map((t) => _TransactionTile(transaction: t)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: AppTab.compta),
    );
  }

  void _ouvrirChoixTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.shopping_cart_rounded, color: Colors.white),
              ),
              title: const Text('Nouvelle vente'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, AppRoutes.saisieVente);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.brownTertiaryAlt,
                child: Icon(Icons.receipt_long_rounded, color: Colors.white),
              ),
              title: const Text('Nouvelle dépense'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, AppRoutes.saisieDepense);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeCards extends StatelessWidget {
  final double totalVentes;
  final double totalDepenses;
  final double solde;
  const _ResumeCards({required this.totalVentes, required this.totalDepenses, required this.solde});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                titre: 'TOTAL VENTES (MOIS)',
                valeur: formatFcfa(totalVentes),
                icon: Icons.trending_up_rounded,
                couleurIcone: AppColors.primary,
                fond: AppColors.primarySoftBg,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                titre: 'TOTAL DÉPENSES (MOIS)',
                valeur: formatFcfa(totalDepenses),
                icon: Icons.trending_down_rounded,
                couleurIcone: AppColors.error,
                fond: AppColors.errorSoftBg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatCard(
          titre: 'SOLDE DE CAISSE',
          valeur: formatFcfa(solde),
          icon: Icons.account_balance_rounded,
          couleurIcone: AppColors.onDark,
          fond: AppColors.sageContainer,
          pleineLargeur: true,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String titre;
  final String valeur;
  final IconData icon;
  final Color couleurIcone;
  final Color fond;
  final bool pleineLargeur;
  const _StatCard({
    required this.titre,
    required this.valeur,
    required this.icon,
    required this.couleurIcone,
    required this.fond,
    this.pleineLargeur = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: pleineLargeur ? fond : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    titre,
                    style: const TextStyle(fontSize: 11, color: AppColors.neutralGrey, letterSpacing: 0.5),
                  ),
                ),
                if (!pleineLargeur)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: fond, shape: BoxShape.circle),
                    child: Icon(icon, size: 16, color: couleurIcone),
                  )
                else
                  Icon(icon, size: 20, color: couleurIcone),
              ],
            ),
            const SizedBox(height: 8),
            Text(valeur, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _FiltresRow extends StatelessWidget {
  final TransactionProvider provider;
  const _FiltresRow({required this.provider});

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
            label: const Text('Ventes'),
            selected: provider.filtreType == TypeTransaction.vente,
            selectedColor: AppColors.primarySoftBg,
            onSelected: (_) => provider.appliquerFiltreType(TypeTransaction.vente),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Dépenses'),
            selected: provider.filtreType == TypeTransaction.depense,
            selectedColor: AppColors.errorSoftBg,
            onSelected: (_) => provider.appliquerFiltreType(TypeTransaction.depense),
          ),
          const SizedBox(width: 8),
          if (provider.filtreType != null)
            TextButton(
              onPressed: provider.reinitialiserFiltres,
              child: const Text('Réinitialiser'),
            ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final estVente = transaction.estVente;
    final couleur = estVente ? AppColors.primary : AppColors.error;
    final date = transaction.dateEffective;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                estVente ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                color: couleur,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description?.isNotEmpty == true
                        ? transaction.description!
                        : (estVente ? 'Vente' : 'Dépense'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}/${date.month}/${date.year}'
                    '${transaction.categorieDepense != null ? ' · ${transaction.categorieDepense}' : ''}',
                    style: const TextStyle(fontSize: 12, color: AppColors.neutralGrey),
                  ),
                  const SizedBox(height: 6),
                  _StatutBadge(statut: transaction.statutSynchronisation),
                ],
              ),
            ),
            Text(
              '${estVente ? '+' : '-'}${formatFcfa(transaction.montant)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: couleur),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatutBadge extends StatelessWidget {
  final String statut;
  const _StatutBadge({required this.statut});

  @override
  Widget build(BuildContext context) {
    final enAttente = statut == StatutSync.local;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: enAttente ? AppColors.tertiaryContainerOrange : AppColors.primarySoftBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        enAttente ? 'En attente de sync' : 'Synchronisé',
        style: TextStyle(
          fontSize: 11,
          color: enAttente ? AppColors.deepBrown : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
