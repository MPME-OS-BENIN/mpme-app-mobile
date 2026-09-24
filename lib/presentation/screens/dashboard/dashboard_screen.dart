import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/montant_fcfa.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../data/models/score_model.dart';
import '../../../data/providers/entreprise_provider.dart';
import '../../../data/providers/score_provider.dart';
import '../../../data/providers/transaction_provider.dart';
import '../../navigation/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _charger());
  }

  Future<void> _charger() async {
    await context.read<EntrepriseProvider>().charger();
    if (!mounted) return;
    await context.read<TransactionProvider>().charger();
    if (!mounted) return;
    await context.read<ScoreProvider>().charger();
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final entrepriseProvider = context.watch<EntrepriseProvider>();
    final scoreProvider = context.watch<ScoreProvider>();

    // Une seule source de vérité pour le bandeau hors-ligne : si l'un des
    // trois chargements est retombé sur du cache local / est indisponible
    // faute de connexion, on le signale une fois en haut de l'écran plutôt
    // que de répéter le bandeau à chaque carte.
    final horsLigne = entrepriseProvider.estHorsLigne || txProvider.estHorsLigne || scoreProvider.estHorsLigne;
    // Une vraie erreur serveur (pas juste hors-ligne) sur l'un des chargements
    // principaux : on l'affiche, sans bloquer le reste de l'écran.
    final erreur = entrepriseProvider.erreur ?? txProvider.erreur;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.storefront_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('MPME OS', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainerOrange,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.volume_up_rounded, color: AppColors.deepBrown),
              onPressed: () {},
              tooltip: 'Aide audio',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (horsLigne) const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _charger,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SoldeCard(solde: txProvider.soldeDeCaisse, isLoading: txProvider.isLoading),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _ScoreCard(provider: scoreProvider)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _VentesFraisCard(
                          ventes: txProvider.totalVentes,
                          depenses: txProvider.totalDepenses,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          label: 'Vente',
                          icon: Icons.shopping_cart_rounded,
                          color: AppColors.primary,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.saisieVente),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          label: 'Dépense',
                          icon: Icons.receipt_long_rounded,
                          color: AppColors.brownTertiaryAlt,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.saisieDepense),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          label: 'Mon Score',
                          icon: Icons.speed_rounded,
                          color: AppColors.goldTertiary,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.score),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          label: 'Financement',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.surfaceDarkContainer,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.financement),
                        ),
                      ),
                    ],
                  ),
                  if (erreur != null) ...[
                    const SizedBox(height: 16),
                    ErrorBanner(message: erreur),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: AppTab.accueil),
    );
  }
}

class _SoldeCard extends StatelessWidget {
  final double solde;
  final bool isLoading;
  const _SoldeCard({required this.solde, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Solde Quotidien',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.credit_card_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isLoading
              ? const SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  formatFcfa(solde),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}

/// Carte score réelle (US7/US13) : /100, jamais /1000 (correction produit).
/// États gérés : chargement, erreur (message serveur), hors-ligne (le score
/// est calculé côté serveur, pas de cache local possible), succès.
class _ScoreCard extends StatelessWidget {
  final ScoreProvider provider;
  const _ScoreCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Votre Score', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildContenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContenu(BuildContext context) {
    if (provider.isLoading && provider.score == null) {
      return const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (provider.score == null) {
      // Erreur ou hors-ligne : pas de valeur à afficher, message court
      // plutôt qu'une jauge vide trompeuse.
      final message = provider.estHorsLigne
          ? 'Indisponible hors-ligne'
          : 'Score indisponible';
      return SizedBox(
        height: 56,
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.neutralGrey, fontSize: 12),
          ),
        ),
      );
    }

    final score = provider.score!;
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: CustomPaint(
            size: const Size(double.infinity, 56),
            painter: _GaugePainter(progress: score.progression, color: _couleurRisque(score.niveauRisque)),
          ),
        ),
        const SizedBox(height: 8),
        Text('${score.valeur.round()} /100', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Color _couleurRisque(String niveau) {
    switch (niveau) {
      case NiveauRisque.faible:
        return AppColors.primary;
      case NiveauRisque.eleve:
        return AppColors.error;
      default:
        return AppColors.goldTertiary;
    }
  }
}

class _GaugePainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;
  _GaugePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final bgPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 3.1416, 3.1416, false, bgPaint);
    canvas.drawArc(rect, 3.1416, 3.1416 * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _VentesFraisCard extends StatelessWidget {
  final double ventes;
  final double depenses;
  const _VentesFraisCard({required this.ventes, required this.depenses});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Ventes: ${_compact(ventes)}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.trending_down_rounded, color: AppColors.error, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Frais: ${_compact(depenses)}',
                    style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _compact(double v) => v >= 1000 ? '${(v / 1000).toStringAsFixed(0)}k' : v.toStringAsFixed(0);
}

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
