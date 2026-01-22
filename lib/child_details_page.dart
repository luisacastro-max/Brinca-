import 'package:app_twins/widgets/age_grid.dart';
import 'package:app_twins/widgets/child_avatar.dart';
import 'package:app_twins/widgets/child_name_field.dart';
import 'package:app_twins/widgets/progress_header.dart';
import 'package:app_twins/widgets/time_options.dart';
import 'package:flutter/material.dart';

class ChildDetailsPage extends StatefulWidget {
  final int quantidadeTotal;
  final int indiceAtual;

  const ChildDetailsPage({
    super.key,
    required this.quantidadeTotal,
    required this.indiceAtual,
  });

  @override
  State<ChildDetailsPage> createState() => _ChildDetailsPageState();
}

class _ChildDetailsPageState extends State<ChildDetailsPage> {
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com progresso
            const ProgressHeader(step: "Passo 3 de 4", percentage: "75%"),
            const SizedBox(height: 20),

            // Formulário
            _buildForm(context),

            const SizedBox(height: 30),

            // Botões de ação
            _buildFooter(context),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar da criança
          ChildAvatar(childIndex: widget.indiceAtual),
          const SizedBox(height: 30),

          // Nome
          const ChildNameField(),
          const SizedBox(height: 30),

          // Idade
          AgeGrid(
            selectedIndex: selectedAge,
            onSelectAge: (index) => setState(() => selectedAge = index),
          ),
          const SizedBox(height: 30),

          // Tempo
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar"),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: (selectedAge != null && selectedTime != null)
                  ? () {
                      if (widget.indiceAtual < widget.quantidadeTotal) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChildDetailsPage(
                              quantidadeTotal: widget.quantidadeTotal,
                              indiceAtual: widget.indiceAtual + 1,
                            ),
                          ),
                        );
                      } else {
                        debugPrint("Finalizado cadastro de ${widget.quantidadeTotal} crianças");
                      }
                    }
                  : null,
              child: const Text("Continuar"),
            ),
          ),
        ],
      ),
    );
  }
}

