import 'package:flutter/material.dart';

/// Palette exacte fournie depuis la maquette Figma (MPME OS).
/// Les valeurs `xxxxAA` (8 chiffres) sont des couleurs avec alpha :
/// les 2 derniers caractères hex codent l'opacité (ARGB inversé -> on
/// reconstruit en RRGGBBAA -> AARRGGBB pour Flutter).
class AppColors {
  AppColors._();

  // ---- Couleurs pleines ----
  static const Color primary = Color(0xFF006B3F); // vert principal
  static const Color primaryAlt = Color(0xFF008751); // vert drapeau Bénin
  static const Color onDark = Color(0xFF1A1C1A); // texte sombre principal
  static const Color onDarkAlt = Color(0xFF191D0E);
  static const Color surfaceDarkContainer = Color(0xFF3E4A41);
  static const Color surfaceMuted = Color(0xFF6E7A70);
  static const Color white = Color(0xFFFFFFFF);
  static const Color sageContainer = Color(0xFFBDCABE); // ex: carte "Solde de caisse"
  static const Color error = Color(0xFFBA1A1A);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color background = Color(0xFFF9FAF6); // fond principal écrans
  static const Color backgroundAlt = Color(0xFFFDFFF9);
  static const Color brownTertiary = Color(0xFF7D562D); // icône "Dépense"
  static const Color brownTertiaryAlt = Color(0xFF7A532A);
  static const Color surfaceSoft = Color(0xFFF3F4F0);
  static const Color darkSurfaceAlt = Color(0xFF1F1B15);
  static const Color neutralGrey = Color(0xFF6B7280);
  static const Color surfaceSoft2 = Color(0xFFE7E9E5);
  static const Color surfaceSoft3 = Color(0xFFEDEEEA);
  static const Color black = Color(0xFF000000);
  static const Color surfaceSoft4 = Color(0xFFE2E3DF);
  static const Color tertiaryContainerOrange = Color(0xFFFFCA98); // pill "Audio Support"
  static const Color tertiaryBg = Color(0xFFFFF8F3);
  static const Color deepBrown = Color(0xFF301400);
  static const Color goldTertiary = Color(0xFF7B5700); // icône "Mon Score"
  static const Color goldTertiaryAlt = Color(0xFF954A00);
  static const Color sageLight = Color(0xFFC4C9B1);
  static const Color oliveLight = Color(0xFFE0E5CC);
  static const Color beige = Color(0xFFE8E2D9);
  static const Color peachLight = Color(0xFFF6ECE2);
  static const Color orangeContainer = Color(0xFFFFDCC6);

  // ---- Couleurs avec alpha (format fourni : RRGGBBAA) ----
  static const Color primarySoftBg = Color(0x1A006B3F); // fond vert très clair (10%)
  static const Color primaryFaintBg = Color(0x0D006B3F); // fond vert quasi transparent (5%)
  static const Color whiteOverlay70 = Color(0xB2FFFFFF);
  static const Color whiteOverlayTransparent = Color(0x01FFFFFF);
  static const Color darkOverlay10 = Color(0x1A191D0E);
  static const Color greenAccentOverlay = Color(0x3370DB9D);
  static const Color brownOverlay10 = Color(0x1A7B5700);
  static const Color errorSoftBg = Color(0x1ABA1A1A);
  static const Color sageOverlay50 = Color(0x80BDCABE);
  static const Color sageOverlay30 = Color(0x4DBDCABE);
  static const Color errorContainerSoft = Color(0x4DFFDAD6);
  static const Color whiteOverlay60 = Color(0x99FFFFFF);
  static const Color whiteOverlay50 = Color(0x80FFFFFF);
  static const Color whiteOverlay40 = Color(0x66FFFFFF);

  /// Couleur de badge/statut selon le type de transaction.
  static Color statusColor(String type) {
    switch (type) {
      case 'VENTE':
        return primary;
      case 'DEPENSE':
        return error;
      default:
        return neutralGrey;
    }
  }
}
