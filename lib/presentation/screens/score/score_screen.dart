import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/montant_fcfa.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../data/models/score_model.dart';
import '../../../data/providers/score_provider.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<ScoreProvider>().charger());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScoreProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mon Score')),
      body: Column(
        children: [
          if (provider.estHorsLigne) const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: provider.charger,
              child: _Contenu(provider: provider),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: AppTab.score),
    );
  }
}

class _Contenu extends StatelessWidget {
  final ScoreProvider provider;
  const _Contenu({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading && provider.score == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final score = provider.score;
    if (score == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (provider.erreur != null) ErrorBanner(message: provider.erreur!),
          if (provider.estHorsLigne)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Le score est calculé par le serveur : il est indisponible '
                  'sans connexion pour le moment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.neutralGrey),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: provider.charger,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
            ),
          ),
        ],
      );
    }

    final indicateurs = score.indicateurs;
    final regularite = (indicateurs['regularite'] as num?)?.toDouble() ?? 0.0;
    final volumeNormalise = (indicateurs['volume_normalise'] as num?)?.toDouble() ?? 0.0;
    final volumeMoyenMensuel = (indicateurs['volume_moyen_mensuel'] as num?)?.toDouble() ?? 0.0;
    final tendance = (indicateurs['tendance'] as num?)?.toDouble() ?? 0.5;
    final ventesMoisCourant = (indicateurs['ventes_mois_courant'] as num?)?.toDouble() ?? 0.0;
    final ventesMoisPrecedent = (indicateurs['ventes_mois_precedent'] as num?)?.toDouble() ?? 0.0;
    final nb3 = (indicateurs['nb_transactions_3mois'] as num?)?.toInt() ?? 0;
    final nb6 = (indicateurs['nb_transactions_6mois'] as num?)?.toInt() ?? 0;
    final nb12 = (indicateurs['nb_transactions_12mois'] as num?)?.toInt() ?? 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (provider.erreur != null) ...[
          ErrorBanner(message: provider.erreur!),
          const SizedBox(height: 16),
        ],
        Center(
          child: Column(
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: score.progression,
                        strokeWidth: 12,
                        backgroundColor: AppColors.divider,
                        color: _couleurRisque(score.niveauRisque),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${score.valeur.round()}',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        const Text('sur 100', style: TextStyle(color: AppColors.neutralGrey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _couleurRisque(score.niveauRisque).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Risque ${_libelleRisque(score.niveauRisque)}',
                  style: TextStyle(
                    color: _couleurRisque(score.niveauRisque),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Calculé le ${_formatDate(score.dateCalcul)}',
                style: const TextStyle(color: AppColors.neutralGrey, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Text('Comment ce score est calculé', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        const Text(
          'Trois indicateurs mesurés sur vos transactions des 12 derniers mois.',
          style: TextStyle(color: AppColors.neutralGrey, fontSize: 12),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _IndicateurCard(
                titre: 'Régularité',
                sousTitre: '40% du score',
                valeur: '${(regularite * 100).round()}%',
                progression: regularite,
                description: 'Part des semaines avec au moins une vente sur 12 mois.',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _IndicateurCard(
                titre: 'Volume',
                sousTitre: '40% du score',
                valeur: '${(volumeNormalise * 100).round()}%',
                progression: volumeNormalise,
                description: 'Moyenne mensuelle des ventes : ${formatFcfa(volumeMoyenMensuel)} (sur 6 mois).',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _TendanceCard(
          tendance: tendance,
          ventesMoisCourant: ventesMoisCourant,
          ventesMoisPrecedent: ventesMoisPrecedent,
        ),
        const SizedBox(height: 20),
        const Text('Activité récente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatMini(label: '3 mois', valeur: nb3)),
            const SizedBox(width: 8),
            Expanded(child: _StatMini(label: '6 mois', valeur: nb6)),
            const SizedBox(width: 8),
            Expanded(child: _StatMini(label: '12 mois', valeur: nb12)),
          ],
        ),
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

  String _libelleRisque(String niveau) {
    switch (niveau) {
      case NiveauRisque.faible:
        return 'Faible';
      case NiveauRisque.eleve:
        return 'Élevé';
      default:
        return 'Moyen';
    }
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _IndicateurCard extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final String valeur;
  final double progression;
  final String description;

  const _IndicateurCard({
    required this.titre,
    required this.sousTitre,
    required this.valeur,
    required this.progression,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(sousTitre, style: const TextStyle(fontSize: 11, color: AppColors.neutralGrey)),
            const SizedBox(height: 10),
            Text(valeur, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progression.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppColors.divider,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 11, color: AppColors.neutralGrey)),
          ],
        ),
      ),
    );
  }
}

class _TendanceCard extends StatelessWidget {
  final double tendance; // 0..1, 0.5 = stable
  final double ventesMoisCourant;
  final double ventesMoisPrecedent;

  const _TendanceCard({
    required this.tendance,
    required this.ventesMoisCourant,
    required this.ventesMoisPrecedent,
  });

  @override
  Widget build(BuildContext context) {
    final hausse = tendance > 0.55;
    final baisse = tendance < 0.45;
    final couleur = hausse ? AppColors.primary : (baisse ? AppColors.error : AppColors.goldTertiary);
    final icone = hausse ? Icons.trending_up_rounded : (baisse ? Icons.trending_down_rounded : Icons.trending_flat_rounded);
    final libelle = hausse ? 'En hausse' : (baisse ? 'En baisse' : 'Stable');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: couleur.withValues(alpha: 0.15), child: Icon(icone, color: couleur)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tendance : $libelle', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    'Ce mois : ${formatFcfa(ventesMoisCourant)} · Mois dernier : ${formatFcfa(ventesMoisPrecedent)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.neutralGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final String label;
  final int valeur;
  const _StatMini({required this.label, required this.valeur});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text('$valeur', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('transactions\n$label', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.neutralGrey)),
          ],
        ),
      ),
    );
  }
}
