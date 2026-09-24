import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Bandeau "Mode Hors-ligne" affiché en haut d'un écran quand les données
/// viennent du cache local faute de connexion (état distinct d'une vraie
/// erreur : voir ErrorBanner). Reproduit le bandeau rouge de la maquette
/// (écran Formalisation & Marketplace, variante "with offline banner").
class OfflineBanner extends StatelessWidget {
  final String message;

  const OfflineBanner({
    super.key,
    this.message = 'Mode Hors-ligne — Les données seront synchronisées',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.error,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, color: AppColors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
