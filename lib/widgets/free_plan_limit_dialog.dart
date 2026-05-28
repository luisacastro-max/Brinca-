import 'package:flutter/material.dart';

enum FreePlanDialogAction { openPlans, backToStart }

Future<FreePlanDialogAction?> showFreePlanLimitDialog(BuildContext context) {
  return showDialog<FreePlanDialogAction>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Limite do plano free'),
      content: const Text(
        'No plano free, voce pode cadastrar apenas 1 crianca. Para cadastrar mais de 1 crianca, adquira um plano premium.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            FreePlanDialogAction.backToStart,
          ),
          child: const Text('Voltar para o inicio'),
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