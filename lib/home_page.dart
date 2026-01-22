import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, bool> dictContainerColor = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListView.separated(
                  itemCount: 4,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String labelChild = index >= 1 ? "Crianças" : "Criança";
                    dictContainerColor.putIfAbsent(index, () => false);
                    List<Color> colorBorderContainer = [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.orange,
                    ];
                    return _buildCustomContainer(
                      borderColor: colorBorderContainer[index],
                      labelText: "${index + 1} $labelChild",
                    );
                  },
                  separatorBuilder: (sepContext, sepIndex) {
                    return const SizedBox(height: 40);
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Voltar"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Continuar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomContainer({
    required Color borderColor,
    required String labelText,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        labelText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
