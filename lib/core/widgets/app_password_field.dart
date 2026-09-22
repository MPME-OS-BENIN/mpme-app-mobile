import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Champ mot de passe réutilisable (bascule affichage, style cohérent
/// avec les autres champs de saisie de l'app). Utilisé par Connexion et
/// Inscription pour éviter de dupliquer la logique de visibilité.
class AppPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  const AppPasswordField({
    super.key,
    required this.controller,
    this.label = 'Mot de passe',
    this.hintText,
    this.validator,
    this.textInputAction,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _masque = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _masque,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.white,
            // Zone tactile min. 48px pour un public en smartphones d'entrée
            // de gamme : IconButton fait déjà 48x48 par défaut.
            suffixIcon: IconButton(
              icon: Icon(
                _masque ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.surfaceMuted,
              ),
              onPressed: () => setState(() => _masque = !_masque),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Color(0xFFBDCABE), width: 2.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Color(0xFFBDCABE), width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}
