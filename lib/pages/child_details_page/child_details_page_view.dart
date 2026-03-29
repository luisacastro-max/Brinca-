import 'package:app_twins/pages/child_details_page/child_details_page_router.dart';
import 'package:app_twins/model/onboarding_child_model.dart';
import 'package:app_twins/widgets/age_grid.dart';
import 'package:app_twins/widgets/child_avatar.dart';
import 'package:app_twins/widgets/child_name_field.dart';
import 'package:app_twins/widgets/progress_header.dart';
import 'package:app_twins/widgets/time_options.dart';
import 'package:flutter/material.dart';

class ChildDetailsPageView extends StatefulWidget {
  final int quantidadeTotal;
  final int indiceAtual;
  final List<OnboardingChildModel> childrenDrafts;

  const ChildDetailsPageView({
    super.key,
    required this.quantidadeTotal,
    required this.indiceAtual,
    required this.childrenDrafts,
  });

  @override
  State<ChildDetailsPageView> createState() => _ChildDetailsPageViewState();
}

class _ChildDetailsPageViewState extends State<ChildDetailsPageView> {
  late final TextEditingController _nameController;
  int? selectedAge;
  int? selectedTime;

  int get _currentIndex => widget.indiceAtual - 1;

  @override
  void initState() {
    super.initState();
    final currentDraft = widget.childrenDrafts[_currentIndex];
    _nameController = TextEditingController(text: currentDraft.name);
    selectedAge = currentDraft.ageOptionIndex;
    selectedTime = currentDraft.timeOptionIndex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCurrentChildDraft() {
    widget.childrenDrafts[_currentIndex] = widget.childrenDrafts[_currentIndex].copyWith(
      name: _nameController.text.trim(),
      ageOptionIndex: selectedAge,
      timeOptionIndex: selectedTime,
    );
  }

  void _onContinuePressed() {
    if (_nameController.text.trim().isEmpty || selectedAge == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, idade e tempo da crianca.')),
      );
      return;
    }

    _saveCurrentChildDraft();

    if (widget.indiceAtual < widget.quantidadeTotal) {
      ChildDetailsPageRouter.goToNextChild(
        context: context,
        quantidadeTotal: widget.quantidadeTotal,
        indiceAtual: widget.indiceAtual,
        childrenDrafts: widget.childrenDrafts,
      );
      return;
    }

    ChildDetailsPageRouter.goToObjectivesSelection(
      context: context,
      childrenDrafts: widget.childrenDrafts,
    );
  }

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
          ChildNameField(controller: _nameController),
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
                  ? _onContinuePressed
                  : null,
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }
}
