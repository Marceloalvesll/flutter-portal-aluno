import 'package:flutter/material.dart';

class GradeCurricularScreen extends StatefulWidget {
  @override
  _GradeCurricularScreenState createState() => _GradeCurricularScreenState();
}

class _GradeCurricularScreenState extends State<GradeCurricularScreen> {
  String cursoSelecionado = 'Engenharia';
  final Map<String, Map<String, List<String>>> gradeCursos = {
    'Engenharia': {
      '1º Período': ['Cálculo I', 'Física I', 'Química Geral'],
      '2º Período': ['Cálculo II', 'Física II', 'Algoritmos']
    },
    'Direito': {
      '1º Período': ['Introdução ao Direito', 'Português Jurídico'],
      '2º Período': ['Teoria do Estado', 'Sociologia']
    }
  };

  @override
  Widget build(BuildContext context) {
    final periodos = gradeCursos[cursoSelecionado]!;

    return Scaffold(
      appBar: AppBar(title: Text('Grade Curricular')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: cursoSelecionado,
              onChanged: (value) {
                setState(() {
                  cursoSelecionado = value!;
                });
              },
              items: gradeCursos.keys.map((curso) {
                return DropdownMenuItem(
                  value: curso,
                  child: Text(curso),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView(
                children: periodos.entries.map((entry) {
                  return ExpansionTile(
                    title: Text(entry.key),
                    children: entry.value
                        .map((disciplina) => ListTile(title: Text(disciplina)))
                        .toList(),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
