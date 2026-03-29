import 'package:app_twins/pages/children_list_page/children_list_page_service.dart';
import 'package:flutter/material.dart';

class ChildrenListPageView extends StatefulWidget {
  const ChildrenListPageView({super.key});

  @override
  State<ChildrenListPageView> createState() => _ChildrenListPageViewState();
}

class _ChildrenListPageViewState extends State<ChildrenListPageView> {
  final ChildrenListPageService _service = ChildrenListPageService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _children = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _service.fetchChildren();
      if (!mounted) return;
      setState(() {
        _children = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro ao carregar criancas: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const <String>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criancas cadastradas'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadChildren,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return ListView(
        children: [
          const SizedBox(height: 120),
          Center(child: Text(_errorMessage!)),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _loadChildren,
              child: const Text('Tentar novamente'),
            ),
          ),
        ],
      );
    }

    if (_children.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 140),
          Center(child: Text('Nenhuma crianca encontrada para este usuario.')),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _children.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final child = _children[index];
        final name = (child['name'] ?? '').toString();
        final ageRange = (child['ageRange'] ?? '').toString();
        final dailyTime = (child['dailyTime'] ?? '').toString();
        final goals = _toStringList(child['developmentGoals']);
        final interests = _toStringList(child['interests']);

        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Crianca sem nome' : name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Faixa etaria: $ageRange'),
                Text('Tempo diario: $dailyTime min'),
                if (goals.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Objetivos: ${goals.join(', ')}'),
                ],
                if (interests.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Interesses: ${interests.join(', ')}'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
