import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mpme_app_mobile/core/theme/app_colors.dart';
import 'package:mpme_app_mobile/core/widgets/app_password_field.dart';
import 'package:mpme_app_mobile/core/widgets/app_phone_field.dart';
import 'package:mpme_app_mobile/core/widgets/error_banner.dart';
import 'package:mpme_app_mobile/data/providers/auth_provider.dart';
import 'package:mpme_app_mobile/presentation/navigation/app_routes.dart';

/// Secteurs d'activité proposés à l'inscription. Liste fermée pour éviter
/// les saisies libres non exploitables par les analyses sectorielles à
/// venir (US15). À faire valider / compléter côté produit si besoin.
const List<String> kSecteursActivite = [
  'Commerce',
  'Agriculture',
  'Artisanat',
  'Restauration',
  'Services',
  'Transport',
  'Textile & Couture',
  'Autre',
];

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _Inscription();
}

class _Inscription extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _villeController = TextEditingController();
  String? _secteur;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _motDePasseController.dispose();
    _villeController.dispose();
    super.dispose();
  }

  Future<void> _creerCompte() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final succes = await auth.register(
      telephone: telephoneComplet(_telephoneController.text),
      password: _motDePasseController.text,
      secteurActivitePrincipal: _secteur ?? '',
      villeResidence: _villeController.text.trim(),
    );

    if (!mounted) return;
    if (succes) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  String? _requis(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryBg,
      appBar: AppBar(
        backgroundColor: AppColors.tertiaryBg,
        title: Text(
          'MPME OS',
          style: TextStyle(color: AppColors.primaryAlt, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.question_mark, color: AppColors.primaryAlt),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.volume_up, color: AppColors.primaryAlt),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: const Opacity(
                          opacity: 0.8,
                          child: Text('Profil Entrepreneur', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        backgroundColor: const Color(0xFF8DF8B7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('assets/img/Illustration.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'Inscription',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.black),
                ),
                const SizedBox(height: 15),
                const Opacity(
                  opacity: 0.8,
                  child: Text(
                    'Remplissez ces informations pour\ncommencer à gérer votre activité\nprofessionnelle en toute simplicité.',
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nom de famille',
                          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _nomController,
                        keyboardType: TextInputType.text,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s'-]"))],
                        validator: (v) => _requis(v, 'Entrez votre nom de famille'),
                        decoration: _decoration('Ex: Kouandété'),
                      ),
                      const SizedBox(height: 15),
                      Text('Prénom(s)',
                          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _prenomController,
                        keyboardType: TextInputType.text,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s'-]"))],
                        validator: (v) => _requis(v, 'Entrez votre/vos prénom(s)'),
                        decoration: _decoration('Ex: Jean-Baptiste'),
                      ),
                      const SizedBox(height: 15),
                      Text('Numéro de téléphone',
                          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 15),
                      AppPhoneField(controller: _telephoneController),
                      const SizedBox(height: 15),
                      AppPasswordField(
                        controller: _motDePasseController,
                        hintText: 'Au moins 8 caractères',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Choisissez un mot de passe';
                          if (v.length < 8) return 'Au moins 8 caractères';
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Text("Secteur d'activité",
                          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        initialValue: _secteur,
                        validator: (v) => v == null ? 'Choisissez votre secteur' : null,
                        decoration: _decoration('Choisissez votre secteur'),
                        items: kSecteursActivite
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) => setState(() => _secteur = v),
                      ),
                      const SizedBox(height: 15),
                      Text('Ville de résidence',
                          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _villeController,
                        keyboardType: TextInputType.text,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s'-]"))],
                        validator: (v) => _requis(v, 'Entrez votre ville de résidence'),
                        decoration: _decoration('Ex: Cotonou'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDDC6),
                      border: Border.all(color: const Color(0xFFFF8E31), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFF954A00),
                          child: Icon(Icons.record_voice_over, color: AppColors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Besoin d'aide ?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 4),
                              Text('Écoutez les instructions pour remplir ce formulaire.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : _creerCompte,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAlt,
                              minimumSize: const Size(double.infinity, 56),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
                            ),
                            child: auth.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Créer mon compte',
                                        style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, color: AppColors.white),
                                    ],
                                  ),
                          ),
                        ),
                        if (auth.erreur != null) ErrorBanner(message: auth.erreur!),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Opacity(
                  opacity: 0.6,
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'En créant un compte, vous acceptez ',
                        style: TextStyle(fontSize: 12, color: AppColors.black),
                        children: [
                          TextSpan(
                            text: "nos conditions d'utilisation",
                            style: TextStyle(
                              color: AppColors.primaryAlt,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                debugPrint("Conditions d'utilisation");
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                    child: Text(
                      'Déjà un compte ? Se connecter',
                      style: TextStyle(color: AppColors.primaryAlt, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.tertiaryBg,
            border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.record_voice_over, color: AppColors.black),
                  Opacity(
                    opacity: 0.8,
                    child: Text('Aide audio', style: TextStyle(color: AppColors.black)),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8E31),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                  shape: const StadiumBorder(),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 20, color: AppColors.black),
                    Text('Retour', style: TextStyle(color: AppColors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFFBDCABE), width: 2.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFFBDCABE), width: 2.0),
      ),
    );
  }
}
