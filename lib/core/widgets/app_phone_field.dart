import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Indicatif Bénin utilisé pour composer le numéro complet envoyé au
/// backend (ex: 90 00 00 00 -> +22990000000).
const String kIndicatifBenin = '+229';

/// Champ de saisie du numéro de téléphone local (10 chiffres), avec le
/// préfixe +229 affiché mais non saisissable. Réutilisé par Connexion et
/// Inscription pour garder un format de téléphone identique des deux côtés.
class AppPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  const AppPhoneField({
    super.key,
    required this.controller,
    this.validator,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: validator ??
          (value) {
            if (value == null || value.length != 10) {
              return 'Entrez un numéro à 10 chiffres';
            }
            return null;
          },
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFFBDCABE), width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFFBDCABE), width: 2.0),
        ),
        prefixText: '$kIndicatifBenin ',
        hintText: '0190045678',
      ),
    );
  }
}

/// Concatène l'indicatif et les 10 chiffres saisis pour obtenir le format
/// complet attendu par le backend (ex: +22990000000).
String telephoneComplet(String dixChiffres) => '$kIndicatifBenin$dixChiffres';
