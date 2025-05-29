import 'package:flutter/material.dart';
import '../models/disciplina.dart';
import '../services/disciplina_service.dart';

class GradeCurricularScreen extends StatefulWidget {
  @override
  State<GradeCurricularScreen> createState() => _GradeCurricularScreenState();
}

class _GradeCurricularScreenState extends State<GradeCurricularScreen> {
  late Future<List<Disciplina>> futureDisciplinas;

  @override
  void initState() {
    super.initState();
    futureDisciplinas = DisciplinaService.getDisciplinas();
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'Aprovado':
        return Colors.green;
      case 'Reprovado':
        return Colors.red;
      case 'Pendente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _iconeStatus(String status) {
    switch (status) {
      case 'Aprovado':
        return Icons.check_circle_outline;
      case 'Reprovado':
        return Icons.cancel_outlined;
      case 'Pendente':
        return Icons.hourglass_bottom;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📘 Grade Curricular'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Disciplina>>(
        future: futureDisciplinas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar a grade curricular'),
            );
          }

          final disciplinas = snapshot.data!;
          final periodos = <int, List<Disciplina>>{};

          for (var d in disciplinas) {
            periodos.putIfAbsent(d.periodo, () => []).add(d);
          }

          final periodosOrdenados = periodos.keys.toList()..sort();

          return ListView(
            padding: const EdgeInsets.all(12),
            children:
                periodosOrdenados.map((periodo) {
                  final lista = periodos[periodo]!;
                  return ExpansionTile(
                    title: Text(
                      '📚 ${periodo}º Período (${lista.length} disciplinas)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.indigo.shade50,
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    children:
                        lista.map((disc) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            elevation: 3,
                            child: ListTile(
                              leading: Icon(
                                _iconeStatus(disc.status),
                                color: _corStatus(disc.status),
                              ),
                              title: Text(
                                disc.nome,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                'CH: ${disc.cargaHoraria ?? 'N/A'}h',
                              ),
                              trailing: Text(
                                disc.status,
                                style: TextStyle(
                                  color: _corStatus(disc.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
