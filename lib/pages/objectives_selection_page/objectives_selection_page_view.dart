import 'package:app_twins/children_option.dart';
import 'package:app_twins/design_system/components/gradient_progress_bar/gradient_progress_bar.dart';
import 'package:app_twins/design_system/components/gradient_progress_bar/gradient_progress_bar_vm.dart';
import 'package:app_twins/model/onboarding_child_model.dart';
import 'package:app_twins/pages/children_list_page/children_list_page_router.dart';
import 'package:app_twins/pages/objectives_selection_page/objectives_selection_page_router.dart';
import 'package:app_twins/pages/objectives_selection_page/objectives_selection_page_service.dart';
import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

class ObjectivesSelectionPageView extends StatefulWidget {
  const ObjectivesSelectionPageView({
    super.key,
    required this.childrenDrafts,
    required this.currentChildIndex,
  });

  final List<OnboardingChildModel> childrenDrafts;
  final int currentChildIndex;

  @override
  State<ObjectivesSelectionPageView> createState() =>
      _ObjectivesSelectionPageViewState();
}

class _ObjectivesSelectionPageViewState extends State<ObjectivesSelectionPageView> {
  final ObjectivesSelectionPageService _service = ObjectivesSelectionPageService();
  final Set<int> selectedObjectives = {};
  final Set<int> selectedInterests = {};
  bool _isSaving = false;

  final List<Map<String, dynamic>> objectives = const [
    {'label': '🤸 Coordenacao motora', 'value': 'Coordenação motora', 'color': Color(0xFFFCA1AA)},
    {'label': '🎨 Criatividade', 'value': 'Criatividade', 'color': Color(0xFF7AA4E3)},
    {'label': '🗣️ Linguagem', 'value': 'Linguagem', 'color': Color(0xFFA8D8BB)},
    {'label': '👥 Socializacao', 'value': 'Socialização', 'color': Color(0xFFFEC578)},
    {'label': '🍎 Autonomia', 'value': 'Autonomia', 'color': Color(0xFFFCA1AA)},
    {'label': '🧘 Concentracao', 'value': 'Concentração', 'color': Color(0xFF7AA4E3)},
    {'label': '🧠 Pensamento logico', 'value': 'Pensamento lógico', 'color': Color(0xFFA8D8BB)},
  ];

  final List<Map<String, dynamic>> interests = const [
    {'label': '🎼 Musica', 'value': 'Música', 'color': Color(0xFFFCA1AA)},
    {'label': '💃 Danca', 'value': 'Dança', 'color': Color(0xFF7AA4E3)},
    {'label': '🌿 Natureza', 'value': 'Natureza', 'color': Color(0xFFA8D8BB)},
    {'label': '🎨 Artes', 'value': 'Artes', 'color': Color(0xFFFEC578)},
    {'label': '🏗️ Construcao', 'value': 'Construção', 'color': Color(0xFFFCA1AA)},
    {'label': '🎭 Faz de conta', 'value': 'Faz de conta', 'color': Color(0xFF7AA4E3)},
    {'label': '🔬 Ciencias', 'value': 'Ciências', 'color': Color(0xFFA8D8BB)},
    {'label': '📚 Leitura', 'value': 'Leitura', 'color': Color(0xFFFEC578)},
  ];

  @override
  void initState() {
    super.initState();
    final currentDraft = widget.childrenDrafts[widget.currentChildIndex];

    for (var i = 0; i < objectives.length; i++) {
      final value = objectives[i]['value'] as String;
      if (currentDraft.developmentGoals.contains(value)) {
        selectedObjectives.add(i);
      }
    }

    for (var i = 0; i < interests.length; i++) {
      final value = interests[i]['value'] as String;
      if (currentDraft.interests.contains(value)) {
        selectedInterests.add(i);
      }
    }
  }

  void _saveCurrentSelections() {
    final current = widget.childrenDrafts[widget.currentChildIndex];
    current.developmentGoals = selectedObjectives
        .map((index) => objectives[index]['value'] as String)
        .toList();
    current.interests = selectedInterests
        .map((index) => interests[index]['value'] as String)
        .toList();
  }

  Future<void> _onContinuePressed() async {
    if (selectedObjectives.isEmpty || selectedInterests.isEmpty) {
      return;
    }

    _saveCurrentSelections();

    if (widget.currentChildIndex < widget.childrenDrafts.length - 1) {
      await ObjectivesSelectionPageRouter.goReplacement(
        context,
        childrenDrafts: widget.childrenDrafts,
        currentChildIndex: widget.currentChildIndex + 1,
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _service.createChildren(widget.childrenDrafts);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil criado com sucesso!')),
      );
      await ChildrenListPageRouter.goAndClearStack(context);
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar perfil: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => ObjectivesSelectionPageRouter.goBack(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Passo 4 de 4', style: buttonTextStyle),
              Text('100%', style: buttonTextStyle),
            ],
          ),
          const SizedBox(height: 8),
          GradientProgressBarComponent.instantiate(
            viewModel: GradientProgressBarViewModel(
              progress: 1.0,
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
          Text(
            'Objetivos de desenvolvimento',
            style: containerTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escolha quantos quiser',
            style: buttonTextStyle.copyWith(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: objectives.length,
            itemBuilder: (context, index) {
              final isSelected = selectedObjectives.contains(index);
              return ChildrenOption(
                label: objectives[index]['label'],
                color: objectives[index]['color'],
                selected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedObjectives.remove(index);
                    } else {
                      selectedObjectives.add(index);
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(height: 40),
          Text(
            'Interesses da criança',
            style: containerTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: interests.length,
            itemBuilder: (context, index) {
              final isSelected = selectedInterests.contains(index);
              return ChildrenOption(
                label: interests[index]['label'],
                color: interests[index]['color'],
                selected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedInterests.remove(index);
                    } else {
                      selectedInterests.add(index);
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => ObjectivesSelectionPageRouter.goBack(context),
                child: const Text('Voltar'),
              ),
              ElevatedButton(
                onPressed: selectedObjectives.isEmpty || selectedInterests.isEmpty
                    ? null
                    : (_isSaving ? null : _onContinuePressed),
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        widget.currentChildIndex == widget.childrenDrafts.length - 1
                            ? 'Finalizar'
                            : 'Continuar',
                      ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
