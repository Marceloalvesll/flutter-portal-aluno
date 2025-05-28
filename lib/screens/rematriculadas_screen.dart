import 'package:flutter/material.dart';
import '../services/disciplina_service.dart';

class RematriculadasScreen extends StatefulWidget {
  const RematriculadasScreen({super.key});

  @override
  State<RematriculadasScreen> createState() => _RematriculadasScreenState();
}

class _RematriculadasScreenState extends State<RematriculadasScreen> {
  late Future<List<String>> futureRematriculadas;

  @override
  void initState() {
    super.initState();
    carregarRematriculadas();
  }

  void carregarRematriculadas() {
    setState(() {
      futureRematriculadas = DisciplinaService.getDisciplinasRematriculadas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Disciplinas Rematriculadas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: carregarRematriculadas,
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: futureRematriculadas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar rematrículas'));
          }

          final disciplinas = snapshot.data ?? [];

          if (disciplinas.isEmpty) {
            return const Center(
              child: Text('Nenhuma disciplina rematriculada.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: disciplinas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final nome = disciplinas[index];
              return Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(
                    nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
