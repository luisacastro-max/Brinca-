import 'package:app_twins/children_option.dart';
import 'package:app_twins/design_system/components/gradient_progress_bar/gradient_progress_bar.dart';
import 'package:app_twins/design_system/components/gradient_progress_bar/gradient_progress_bar_vm.dart';
import 'package:app_twins/pages/children_selection_page/children_selection_page_router.dart';
import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

class ChildrenSelectionPageView extends StatefulWidget {
  const ChildrenSelectionPageView({super.key});

  @override
  State<ChildrenSelectionPageView> createState() =>
      _ChildrenSelectionPageViewState();
}

class _ChildrenSelectionPageViewState extends State<ChildrenSelectionPageView> {
  int? selectedChildren;

  void select(int value) {
    setState(() => selectedChildren = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => ChildrenSelectionPageRouter.goBack(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Passo 2 de 4', style: buttonTextStyle),
              Text('50%', style: buttonTextStyle),
            ],
          ),
          const SizedBox(height: 8),
          GradientProgressBarComponent.instantiate(
            viewModel: GradientProgressBarViewModel(
              progress: 0.5,
              height: 8,
              backgroundColor: Colors.grey[200]!,
              gradientColors: const [
                Color(0xFFFCA1AA),
                Color(0xFF7AA4E3),
                Color(0xFFA8D8BB),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFCA1AA),
                  Color(0xFF7AA4E3),
                  Color(0xFFA8D8BB),
                ],
              ),
            ),
            child: const Icon(Icons.people, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 30),
          Text(
            'Quantos filhos voce quer cadastrar?',
            style: containerTextStyle.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ChildrenOption(
            label: '1 crianca',
            color: const Color(0xFFFCA1AA),
            selected: selectedChildren == 1,
            onTap: () => select(1),
          ),
          const SizedBox(height: 20),
          ChildrenOption(
            label: '2 criancas',
            color: const Color(0xFFA8D8BB),
            selected: selectedChildren == 2,
            onTap: () => select(2),
          ),
          const SizedBox(height: 20),
          ChildrenOption(
            label: '3+ criancas',
            color: const Color(0xFF7AA4E3),
            selected: selectedChildren == 3,
            onTap: () => select(3),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => ChildrenSelectionPageRouter.goBack(context),
                child: const Text('Voltar'),
              ),
              ElevatedButton(
                onPressed: selectedChildren == null
                    ? null
                    : () => ChildrenSelectionPageRouter.goToChildDetails(
                          context: context,
                          quantidadeTotal: selectedChildren!,
                        ),
                child: const Text('Continuar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
