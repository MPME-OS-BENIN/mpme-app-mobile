import 'package:flutter_test/flutter_test.dart';

import 'package:mpme_app_mobile/main.dart';

void main() {
  testWidgets(
    "MpmeApp démarre sur l'écran d'accueil (Onboarding) quand aucune session n'est stockée",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MpmeApp());
      // Premier frame : AuthGate affiche un CircularProgressIndicator
      // (animation indéterminée, sans fin). pumpAndSettle() ne peut donc
      // jamais se stabiliser tant que ce spinner est à l'écran, même
      // brièvement -> on pompe un nombre borné de frames à la place, le
      // Laisse le temps à restaurerSession() de se résoudre : elle a un
      // timeout défensif de 3s sur la lecture du stockage sécurisé (voir
      // AuthProvider), qui n'a aucune réponse dans cet environnement de
      // test. On pompe donc au-delà de ce délai, en temps simulé (le test
      // reste rapide en temps réel).
      for (var i = 0; i < 45 && find.text('Commencer').evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('MPME OS'), findsOneWidget);
      expect(find.text('Commencer'), findsOneWidget);
    },
  );
}
