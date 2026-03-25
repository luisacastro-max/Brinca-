import 'package:app_twins/pages/child_details_page/child_details_page_router.dart';
import 'package:app_twins/widgets/age_grid.dart';
import 'package:app_twins/widgets/child_avatar.dart';
import 'package:app_twins/widgets/child_name_field.dart';
import 'package:app_twins/widgets/progress_header.dart';
import 'package:app_twins/widgets/time_options.dart';
import 'package:flutter/material.dart';

class ChildDetailsPageView extends StatefulWidget {
  final int quantidadeTotal;
  final int indiceAtual;

  const ChildDetailsPageView({
    super.key,
    required this.quantidadeTotal,
    required this.indiceAtual,
  });

  @override
  State<ChildDetailsPageView> createState() => _ChildDetailsPageViewState();
}

class _ChildDetailsPageViewState extends State<ChildDetailsPageView> {
  int? selectedAge;
  int? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => ChildDetailsPageRouter.goBack(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressHeader(step: 'Passo 3 de 4', percentage: '75%'),
            const SizedBox(height: 20),
            _buildForm(),
            const SizedBox(height: 30),
            _buildFooter(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChildAvatar(childIndex: widget.indiceAtual),
          const SizedBox(height: 30),
          const ChildNameField(),
          const SizedBox(height: 30),
          AgeGrid(
            selectedIndex: selectedAge,
            onSelectAge: (index) => setState(() => selectedAge = index),
          ),
          const SizedBox(height: 30),
          TimeOptions(
            selectedIndex: selectedTime,
            onSelectTime: (index) => setState(() => selectedTime = index),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => ChildDetailsPageRouter.goBack(context),
              child: const Text('Voltar'),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: (selectedAge != null && selectedTime != null)
                  ? () {
                      if (widget.indiceAtual < widget.quantidadeTotal) {
                        ChildDetailsPageRouter.goToNextChild(
                          context: context,
                          quantidadeTotal: widget.quantidadeTotal,
                          indiceAtual: widget.indiceAtual,
                        );
                      } else {
                        ChildDetailsPageRouter.goToObjectivesSelection(context);
                      }
                    }
                  : null,
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }
}
