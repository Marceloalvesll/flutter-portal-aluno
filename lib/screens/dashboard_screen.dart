import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'title': 'Boletim', 'route': '/boletim'},
    {'title': 'Grade Curricular', 'route': '/grade'},
    {'title': 'Rematrícula Online', 'route': '/rematricula'},
    {'title': 'Situação Acadêmica', 'route': '/situacao'},
    {'title': 'Análise Curricular', 'route': '/analise'},
    {'title': 'Rematriculadas', 'route': '/rematriculadas'}, // opcional
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children:
            items.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item['route']);
                },
                child: Card(
                  elevation: 4,
                  child: Center(
                    child: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
