import 'package:flutter/material.dart';
import '../models/disciplina.dart';
import '../services/disciplina_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AnaliseCurricularScreen extends StatefulWidget {
  @override
  _AnaliseCurricularScreenState createState() =>
      _AnaliseCurricularScreenState();
}

class _AnaliseCurricularScreenState extends State<AnaliseCurricularScreen> {
  List<Disciplina> todasDisciplinas = [];
  int? periodoSelecionado;

  @override
  void initState() {
    super.initState();
    carregarDisciplinas();
  }

  Future<void> carregarDisciplinas() async {
    final disciplinas = await DisciplinaService.getDisciplinas();
    setState(() {
      todasDisciplinas = disciplinas;
    });
  }

  List<Disciplina> get filtradas {
    return periodoSelecionado == null
        ? todasDisciplinas
        : todasDisciplinas
            .where((d) => d.periodo == periodoSelecionado)
            .toList();
  }

  int calcularCH(String status) {
    return filtradas
        .where(
          (d) => d.status.trim().toLowerCase() == status.trim().toLowerCase(),
        )
        .fold(0, (soma, d) => soma + (d.cargaHoraria ?? 0));
  }

  Future<void> gerarPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Análise Curricular',
                  style: pw.TextStyle(fontSize: 24),
                ),
                pw.SizedBox(height: 12),
                pw.Text('Total CH Aprovada: ${calcularCH('Aprovado')}h'),
                pw.Text('Total CH Pendente: ${calcularCH('Pendente')}h'),
                pw.SizedBox(height: 16),
                pw.Text('Disciplinas:', style: pw.TextStyle(fontSize: 18)),
                ...filtradas.map(
                  (d) => pw.Bullet(
                    text:
                        '${d.nome} (${d.status}) - CH: ${d.cargaHoraria ?? 0}h',
                  ),
                ),
              ],
            ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final concluidas =
        filtradas
            .where((d) => d.status.trim().toLowerCase() == 'aprovado')
            .toList();
    final pendentes =
        filtradas
            .where((d) => d.status.trim().toLowerCase() == 'pendente')
            .toList();

    final chConcluida = concluidas.fold(
      0,
      (sum, d) => sum + (d.cargaHoraria ?? 0),
    );
    final chPendente = pendentes.fold(
      0,
      (sum, d) => sum + (d.cargaHoraria ?? 0),
    );
    final totalCH = chConcluida + chPendente;
    final progresso = totalCH == 0 ? 0.0 : chConcluida / totalCH;

    final periodos =
        todasDisciplinas.map((d) => d.periodo).toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(title: Text('📘 Análise Curricular')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: periodoSelecionado,
                            decoration: InputDecoration(
                              labelText: 'Filtrar por Período',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text('Todos'),
                              ),
                              ...periodos.map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text('Período $p'),
                                ),
                              ),
                            ],
                            onChanged: (valor) {
                              setState(() {
                                periodoSelecionado = valor;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: gerarPdf,
                          icon: Icon(Icons.picture_as_pdf),
                          label: Text('Exportar PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Progresso do Curso',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progresso,
                      minHeight: 12,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'CH Aprovada: ${chConcluida}h | CH Pendente: ${chPendente}h',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              '✅ Disciplinas Concluídas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...concluidas.map(
              (disc) => Card(
                color: Colors.green.shade50,
                child: ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text(disc.nome),
                  subtitle: Text('CH: ${disc.cargaHoraria ?? 0}h'),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '🕒 Disciplinas Pendentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...pendentes.map(
              (disc) => Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: Icon(Icons.pending_actions, color: Colors.orange),
                  title: Text(disc.nome),
                  subtitle: Text('CH: ${disc.cargaHoraria ?? 0}h'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
