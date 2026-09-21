import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mpme_app_mobile/main.dart';

void main() {
  testWidgets('MpmeApp démarre et affiche l\'écran d\'accueil', (WidgetTester tester) async {
    await tester.pumpWidget(const MpmeApp());
    await tester.pumpAndSettle();

    expect(find.text('MPME OS - Test navigation'), findsOneWidget);
    expect(find.text('Comptabilité'), findsOneWidget);
  });
}
