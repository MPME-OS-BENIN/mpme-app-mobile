import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/entreprise_selector.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/providers/entreprise_provider.dart';
import '../../../data/providers/transaction_provider.dart';

const List<String> _categoriesDepense = [
  'Charges Fixes',
  'Stock',
  'Transport',
  'Salaires',
  'Marketing',
  'Autre',
];

class SaisieDepenseScreen extends StatefulWidget {
  const SaisieDepenseScreen({super.key});

  @override
  State<SaisieDepenseScreen> createState() => _SaisieDepenseScreenState();
}

class _SaisieDepenseScreenState extends State<SaisieDepenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _categorie;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _montantController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final selection = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selection != null) setState(() => _date = selection);
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    final entreprise = context.read<EntrepriseProvider>().selectionnee;
    if (entreprise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélectionnez une entreprise avant de continuer.')),
      );
      return;
    }

    final txProvider = context.read<TransactionProvider>();
    final ok = await txProvider.creerTransaction(
      entrepriseId: entreprise.id,
      type: TypeTransaction.depense,
      montant: double.parse(_montantController.text.replaceAll(' ', '').replaceAll(',', '.')),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      categorieDepense: _categorie,
      date: _date,
    );

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dépense enregistrée.'), backgroundColor: AppColors.brownTertiaryAlt),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(txProvider.erreur ?? 'Erreur lors de l\'enregistrement.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.watch<TransactionProvider>().isSubmitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Enregistrer une dépense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const EntrepriseSelector(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _montantController,
              decoration: const InputDecoration(
                labelText: 'Montant',
                suffixText: 'FCFA',
                prefixIcon: Icon(Icons.payments_rounded, color: AppColors.brownTertiaryAlt),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Montant requis';
                final parsed = double.tryParse(value.replaceAll(' ', '').replaceAll(',', '.'));
                if (parsed == null || parsed <= 0) return 'Montant invalide (doit être > 0)';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _categorie,
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                prefixIcon: Icon(Icons.category_rounded),
              ),
              items: _categoriesDepense
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _categorie = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optionnel)',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _choisirDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                child: Text('${_date.day}/${_date.month}/${_date.year}'),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.brownTertiaryAlt),
              onPressed: isSubmitting ? null : _enregistrer,
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Enregistrer la dépense'),
            ),
          ],
        ),
      ),
    );
  }
}
