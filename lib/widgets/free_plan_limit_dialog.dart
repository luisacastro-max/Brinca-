import 'package:flutter/material.dart';

enum FreePlanDialogAction { openPlans, backToStart }

Future<FreePlanDialogAction?> showFreePlanLimitDialog(BuildContext context) {
  return showDialog<FreePlanDialogAction>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Limite do plano gratuito'),
      content: const Text(
        'No plano gratuito, você pode cadastrar apenas 1 criança. Para cadastrar mais de 1 criança, adquira um plano premium.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            FreePlanDialogAction.backToStart,
          ),
          child: const Text('Voltar para o início'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            FreePlanDialogAction.openPlans,
          ),
          child: const Text('Ver planos'),
        ),
      ],
    ),
  );
}