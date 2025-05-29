import 'package:flutter/material.dart';
import '../models/disciplina.dart';
import '../services/disciplina_service.dart';

class RematriculaScreen extends StatefulWidget {
  const RematriculaScreen({super.key});

  @override
  State<RematriculaScreen> createState() => _RematriculaScreenState();
}

class _RematriculaScreenState extends State<RematriculaScreen> {
  Future<List<Disciplina>> futureDisciplinas = Future.value([]);
  final Set<String> selecionadas = {};
  List<String> jaRematriculadas = [];

  @override
  void initState() {
    super.initState();
    _carregarDisciplinas();
  }

  Future<void> _carregarDisciplinas() async {
    final remat = await DisciplinaService.getDisciplinasRematriculadas();
    setState(() {
      jaRematriculadas = remat;
      futureDisciplinas = DisciplinaService.getDisciplinas();
    });
  }

  void _confirmarRematricula() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Rematrícula'),
            content: Text(
              'Deseja confirmar a rematrícula nas ${selecionadas.length} disciplinas selecionadas?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        for (final nome in selecionadas) {
          await DisciplinaService.salvarRematricula(nome);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rematrícula salva com sucesso!")),
        );

        setState(() {
          selecionadas.clear();
        });

        await _carregarDisciplinas();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao salvar rematrícula.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📘 Rematrícula Online'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Disciplina>>(
        future: futureDisciplinas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erro ao carregar disciplinas',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final pendentes =
              snapshot.data!
                  .where(
                    (disc) =>
                        disc.status == "Pendente" &&
                        !jaRematriculadas.contains(disc.nome),
                  )
                  .toList();

          if (pendentes.isEmpty) {
            return const Center(child: Text('Nenhuma disciplina pendente.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: pendentes.length,
                  itemBuilder: (context, index) {
                    final disc = pendentes[index];
                    final selecionada = selecionadas.contains(disc.nome);

                    return Card(
                      color: selecionada ? Colors.green.shade100 : Colors.white,
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(
                          selecionada
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selecionada ? Colors.green : Colors.grey,
                        ),
                        title: Text(
                          disc.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (disc.professor != null)
                              Text('👨‍🏫 Professor: ${disc.professor}'),
                            if (disc.tipo != null)
                              Text('📘 Tipo: ${disc.tipo}'),
                            if (disc.horario != null)
                              Text('🕒 Horário: ${disc.horario}'),
                            if (disc.cargaHoraria != null)
                              Text('⏱ Carga Horária: ${disc.cargaHoraria}h'),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            if (selecionada) {
                              selecionadas.remove(disc.nome);
                            } else {
                              selecionadas.add(disc.nome);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed:
                      selecionadas.isEmpty ? null : _confirmarRematricula,
                  icon: const Icon(Icons.save),
                  label: const Text('Confirmar Rematrícula'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
