import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mpme_app_mobile/core/theme/app_colors.dart';
import 'package:mpme_app_mobile/core/widgets/app_password_field.dart';
import 'package:mpme_app_mobile/core/widgets/app_phone_field.dart';
import 'package:mpme_app_mobile/core/widgets/error_banner.dart';
import 'package:mpme_app_mobile/data/providers/auth_provider.dart';
import 'package:mpme_app_mobile/presentation/navigation/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _telephoneController = TextEditingController();
  final _motDePasseController = TextEditingController();

  @override
  void dispose() {
    _telephoneController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final succes = await auth.login(
      telephoneComplet(_telephoneController.text),
      _motDePasseController.text,
    );

    if (!mounted) return;
    if (succes) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
    // En cas d'échec, AuthProvider.erreur est déjà renseigné et affiché
    // via le Consumer plus bas (message backend traduit en français par
    // ApiException, jamais de stack trace).
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 360,
                width: double.infinity,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFDBFFF0),
                        Color(0xFFFFF2E6),
                        Color(0xFFFFEFE0),
                      ],
                      stops: [0.0, 0.60, 1.0],
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final imageWidth = constraints.maxWidth > 454 ? 430.0 : constraints.maxWidth - 24;
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Image.asset(
                            'assets/img/Hero_Visual_Section.png',
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: AppColors.white,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Connexion',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Text('Entrez votre numéro et votre mot de passe.'),
                            const SizedBox(height: 30),
                            const Text(
                              'Numéro de téléphone',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            AppPhoneField(
                              controller: _telephoneController,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            AppPasswordField(
                              controller: _motDePasseController,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez votre mot de passe';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Opacity(
                              opacity: 0.8,
                              child: Text(
                                'Utilisez le mot de passe créé lors de votre inscription.',
                                style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.black),
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
                                        onPressed: auth.isLoading ? null : _seConnecter,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryAlt,
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: auth.isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Se connecter',
                                                    style: TextStyle(color: AppColors.white, fontSize: 16),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(Icons.arrow_forward, color: AppColors.white, size: 20),
                                                ],
                                              ),
                                      ),
                                    ),
                                    if (auth.erreur != null) ErrorBanner(message: auth.erreur!),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.pushReplacementNamed(context, AppRoutes.inscription),
                                child: Text(
                                  'Nouveau sur MPME OS ? Créer un compte',
                                  style: TextStyle(
                                    color: AppColors.primaryAlt,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
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
                              Text('Besoin d\'aide ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 4),
                              Text('Écoutez les instructions pour vous connecter'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
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
}
