import 'package:flutter/material.dart';

class AnaliseCurricularScreen extends StatelessWidget {
  final List<String> concluidas = [
    'Introdução à Programação',
    'Matemática Discreta',
    'Lógica de Programação',
  ];

  final List<String> pendentes = [
    'Estrutura de Dados',
    'Engenharia de Software',
    'Sistemas Operacionais',
    'Redes de Computadores'
  ];

  @override
  Widget build(BuildContext context) {
    final total = concluidas.length + pendentes.length;
    final progresso = concluidas.length / total;

    return Scaffold(
      appBar: AppBar(title: Text('Análise Curricular')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progresso do Curso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progresso,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text('Disciplinas Concluídas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...concluidas.map((disc) => ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(disc),
            )),
            SizedBox(height: 16),
            Text('Disciplinas Pendentes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...pendentes.map((disc) => ListTile(
              leading: Icon(Icons.pending, color: Colors.orange),
              title: Text(disc),
            )),
          ],
        ),
      ),
    );
  }
}
