import 'dart:async';

import 'package:app_twins/pages/activities_page/activities_page_service.dart';
import 'package:app_twins/pages/activities_page/widgets/activity_details_header.dart';
import 'package:app_twins/pages/activities_page/widgets/activity_info_grid.dart';
import 'package:app_twins/pages/activities_page/widgets/activity_primary_button.dart';
import 'package:app_twins/pages/activities_page/widgets/adaptations_section.dart';
import 'package:app_twins/pages/activities_page/widgets/bullet_list_section.dart';
import 'package:app_twins/pages/activities_page/widgets/neurodivergence_card.dart';
import 'package:app_twins/pages/activities_page/widgets/steps_section.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter/material.dart';

class ActivitiesPageView extends StatefulWidget {
  const ActivitiesPageView({super.key, required this.activityId});

  final String activityId;

  @override
  State<ActivitiesPageView> createState() => _ActivitiesPageViewState();
}

class _ActivitiesPageViewState extends State<ActivitiesPageView> {
  final ActivitiesPageService _service = ActivitiesPageService();

  bool _isLoading = true;
  String? _errorMessage;
  ActivityDetailsModel? _details;
  ActivityProgressState _progressState = ActivityProgressState.notStarted;
  bool _isSubmittingProgress = false;
  Timer? _resetProgressTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _resetProgressTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final details = await _service.loadActivity(widget.activityId);

      final progress = await _service.loadProgressState(widget.activityId);

      if (!mounted) return;
      setState(() {
        _details = details;
        _progressState = progress;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar detalhes da atividade.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _advanceProgress() async {
    if (_isSubmittingProgress) return;

    setState(() => _isSubmittingProgress = true);

    try {
      if (_progressState == ActivityProgressState.notStarted) {
        final children = await _service.loadChildrenOptions();
        if (!mounted) return;

        if (children.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cadastre uma crianca para iniciar.')),
          );
          return;
        }

        final selectedChildIds = await _showChildrenSelectionDialog(children);
        if (!mounted || selectedChildIds == null || selectedChildIds.isEmpty) {
          return;
        }

        final next = await _service.startActivity(
          activityId: widget.activityId,
          childIds: selectedChildIds,
        );

        if (!mounted) return;
        setState(() => _progressState = next);
        return;
      }

      if (_progressState == ActivityProgressState.started) {
        final next = await _service.completeActivity(widget.activityId);
        if (!mounted) return;
        setState(() => _progressState = next);
        _scheduleProgressReset();
      }
    } on ServiceException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel atualizar a atividade.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmittingProgress = false);
      }
    }
  }

  void _scheduleProgressReset() {
    _resetProgressTimer?.cancel();
    _resetProgressTimer = Timer(const Duration(seconds: 3), () async {
      await _service.resetCompletedState(widget.activityId);
      if (!mounted) return;
      setState(() => _progressState = ActivityProgressState.notStarted);
    });
  }

  Future<List<String>?> _showChildrenSelectionDialog(
    List<ActivityChildOption> children,
  ) {
    final selectedIds = <String>{};

    return showDialog<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Selecionar criancas'),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children
                        .map(
                          (child) => CheckboxListTile(
                            value: selectedIds.contains(child.id),
                            onChanged: (checked) {
                              setDialogState(() {
                                if (checked == true) {
                                  selectedIds.add(child.id);
                                } else {
                                  selectedIds.remove(child.id);
                                }
                              });
                            },
                            title: Text(child.name),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: selectedIds.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(selectedIds.toList()),
                  child: const Text('Iniciar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: _buildBody(_details),
    );
  }

  Widget _buildBody(ActivityDetailsModel? details) {
    if (_isLoading) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    if (_errorMessage != null) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFB42318)),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (details == null) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          const SliverToBoxAdapter(child: SizedBox.shrink()),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                ActivityDetailsHeader(
                  title: details.title,
                  description: details.description,
                  isFree: details.isFree,
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    spacing: 18,
                    children: [
                      ActivityInfoGrid(
                        duration: details.durationLabel,
                        age: details.ageLabel,
                        area: details.areaLabel,
                        difficulty: details.difficulty,
                      ),
                      const SizedBox(height: 12),
                      NeurodivergenceCard(),
                      if (details.whyImportant.isNotEmpty)
                        BulletListSection(
                          title: 'Por que esta atividade importa',
                          items: details.whyImportant,
                          emptyMessage: 'Nenhuma informação disponível.',
                          icon: Icons.lightbulb_outline,
                          backgroundColor: const Color(0xFFF0FDF4),
                        iconColor: const Color(0xFF00A63E),
                      ),
                      if (details.materials.isNotEmpty)
                        BulletListSection(
                          title: 'Materiais Necessarios',
                          items: details.materials,
                          emptyMessage: 'Nenhum material especificado.',
                          icon: Icons.inventory_2_outlined,
                          backgroundColor: Colors.white,
                        iconColor: const Color(0xFFF97316),
                      ),
                      if (details.steps.isNotEmpty)
                        StepsSection(steps: details.steps),
                      if (details.adaptations.isNotEmpty)
                        AdaptationsSection(
                          title: 'Adaptacoes e alternativas',
                          items: details.adaptations,
                          emptyMessage: 'Nenhuma adaptação especificada.',
                        ),
                      if (details.adultTips.isNotEmpty)
                        BulletListSection(
                          title: 'Dicas para adultos',
                          items: details.adultTips,
                          emptyMessage: 'Nenhuma dica especificada.',
                          icon: Icons.info_outline,
                        backgroundColor: const Color(0xFFEFF4FC),
                        iconColor: const Color(0xFF3B82F6),
                      ),
                      const SizedBox(height: 14),
                      ActivityPrimaryButton(
                        state: _progressState,
                        isLoading: _isSubmittingProgress,
                        onPressed: _advanceProgress,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: false,
      floating: false,
      snap: false,
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Brinca+',
        style: TextStyle(
          color: Color(0xFF101828),
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFE5E9F0), width: 1),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF3A4558)),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
