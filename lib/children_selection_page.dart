import 'package:flutter/material.dart';
import 'package:app_twins/theme/theme_data_base.dart';
import 'children_option.dart';
import 'gradient_progress_bar.dart';

class ChildrenSelectionPage extends StatefulWidget {
  const ChildrenSelectionPage({super.key});

  @override
  State<ChildrenSelectionPage> createState() => _ChildrenSelectionPageState();
}

class _ChildrenSelectionPageState extends State<ChildrenSelectionPage> {
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Passo 2 de 4", style: buttonTextStyle),
              Text("50%", style: buttonTextStyle),
            ],
          ),
          const SizedBox(height: 8),

          const GradientProgressBar(progress: 0.5),

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
            "Quantos filhos você quer cadastrar?",
            style: containerTextStyle.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          ChildrenOption(
            label: "1 criança",
            color: const Color(0xFFFCA1AA),
            selected: selectedChildren == 1,
            onTap: () => select(1),
          ),
          const SizedBox(height: 20),

          ChildrenOption(
            label: "2 crianças",
            color: const Color(0xFFA8D8BB),
            selected: selectedChildren == 2,
            onTap: () => select(2),
          ),
          const SizedBox(height: 20),

          ChildrenOption(
            label: "3+ crianças",
            color: const Color(0xFF7AA4E3),
            selected: selectedChildren == 3,
            onTap: () => select(3),
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Voltar"),
              ),
              ElevatedButton(
                onPressed: selectedChildren == null ? null : () {},
                child: const Text("Continuar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
