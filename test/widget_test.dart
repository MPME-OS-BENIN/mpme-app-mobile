import 'package:flutter_test/flutter_test.dart';

import 'package:mpme_app_mobile/main.dart';

void main() {
  testWidgets(
    "MpmeApp démarre sur l'écran d'accueil (Onboarding) quand aucune session n'est stockée",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MpmeApp());
      // AuthGate affiche un indicateur de chargement pendant la tentative
      // de restauration de session, puis redirige vers Onboarding faute
      // de token stocké dans cet environnement de test.
      await tester.pumpAndSettle();

      expect(find.text('MPME OS'), findsOneWidget);
      expect(find.text('Commencer'), findsOneWidget);
    },
  );
}
