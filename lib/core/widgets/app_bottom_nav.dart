import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../presentation/navigation/app_routes.dart';

enum AppTab { accueil, compta, score, profil }

/// Bottom nav mobile reproduisant la maquette (Accueil / Compta / Score / Profil).
/// Navigue via Navigator.pushReplacementNamed pour rester en navigation
/// classique (pas de TabBar/IndexedStack), conformément au choix retenu.
class AppBottomNav extends StatelessWidget {
  final AppTab current;
  const AppBottomNav({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final index = AppTab.values.indexOf(current);
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (i) => _onTap(context, AppTab.values[i]),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.neutralGrey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Compta'),
        BottomNavigationBarItem(icon: Icon(Icons.speed_rounded), label: 'Score'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
      ],
    );
  }

  void _onTap(BuildContext context, AppTab tab) {
    if (tab == current) return;
    switch (tab) {
      case AppTab.accueil:
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        break;
      case AppTab.compta:
        Navigator.pushReplacementNamed(context, AppRoutes.livreDeCaisse);
        break;
      case AppTab.score:
        Navigator.pushReplacementNamed(context, AppRoutes.score);
        break;
      case AppTab.profil:
        // Écran profil pas encore dans le périmètre : on reste sur place.
        break;
    }
  }
}
