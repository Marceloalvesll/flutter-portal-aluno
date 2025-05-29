import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'title': 'Boletim', 'route': '/boletim', 'icon': Icons.grade},
    {'title': 'Grade Curricular', 'route': '/grade', 'icon': Icons.list_alt},
    {'title': 'Rematrícula', 'route': '/rematricula', 'icon': Icons.assignment},
    {'title': 'Situação Acadêmica', 'route': '/situacao', 'icon': Icons.info},
    {
      'title': 'Análise Curricular',
      'route': '/analise',
      'icon': Icons.analytics,
    },
    {
      'title': 'Rematriculadas',
      'route': '/rematriculadas',
      'icon': Icons.check_circle,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final nome = Provider.of<UserProvider>(context).nomeUsuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $nome 👋'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Text(
              '📚 Portal Acadêmico',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Selecione uma opção abaixo:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children:
                  items.map((item) {
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(context, item['route']),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.indigo.shade50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'], size: 36, color: Colors.indigo),
                            SizedBox(height: 12),
                            Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
