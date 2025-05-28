import 'package:flutter/material.dart';
import '../models/disciplina.dart';
import '../services/disciplina_service.dart';

class BoletimScreen extends StatefulWidget {
  @override
  _BoletimScreenState createState() => _BoletimScreenState();
}

class _BoletimScreenState extends State<BoletimScreen> {
  late Future<List<Disciplina>> futureBoletim;

  @override
  void initState() {
    super.initState();
    futureBoletim = _filtrarDisciplinasBoletim();
  }

  Future<List<Disciplina>> _filtrarDisciplinasBoletim() async {
    final todas = await DisciplinaService.getDisciplinas();
    return todas
        .where((d) => d.status == "Aprovado" || d.status == "Reprovado")
        .toList();
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'Aprovado':
        return Colors.green.shade100;
      case 'Reprovado':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Icon _iconeStatus(String status) {
    switch (status) {
      case 'Aprovado':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'Reprovado':
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📊 Boletim')),
      body: FutureBuilder<List<Disciplina>>(
        future: futureBoletim,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Erro ao carregar boletim'),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma disciplina finalizada.'));
          }

          final disciplinas = snapshot.data!;
          final agrupadasPorPeriodo = <int, List<Disciplina>>{};

          for (var d in disciplinas) {
            agrupadasPorPeriodo.putIfAbsent(d.periodo, () => []).add(d);
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children:
                agrupadasPorPeriodo.entries.map((entry) {
                  final periodo = entry.key;
                  final lista = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📚 ${periodo}º Período',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...lista.map(
                        (d) => Card(
                          color: _corStatus(d.status),
                          child: ListTile(
                            leading: _iconeStatus(d.status),
                            title: Text(
                              d.nome,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (d.nota != null)
                                  Text('Nota: ${d.nota!.toStringAsFixed(1)}'),
                                if (d.frequencia != null)
                                  Text('Frequência: ${d.frequencia}%'),
                                Text(
                                  'Status: ${d.status}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        d.status == 'Aprovado'
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
