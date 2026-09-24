import 'package:flutter/material.dart';
import 'app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MPME OS - Test navigation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              child: const Text('Connexion'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.dashboard),
              child: const Text('Comptabilité'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.financement),
              child: const Text('Financement'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.formalisation),
              child: const Text('Formalisation'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.score),
              child: const Text('Score financier'),
            ),
          ],
        ),
      ),
    );
  }
}