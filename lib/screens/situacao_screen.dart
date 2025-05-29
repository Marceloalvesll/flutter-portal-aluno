import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SituacaoScreen extends StatelessWidget {
  final Map<String, bool> documentos = {
    'Identidade (RG)': true,
    'CPF': true,
    'Histórico Escolar': false,
    'Comprovante de Residência': true,
    'Foto 3x4': false,
  };

  @override
  Widget build(BuildContext context) {
    final nome = Provider.of<UserProvider>(context).nomeUsuario;
    final documentosPendentes =
        documentos.entries.where((doc) => !doc.value).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Situação Acadêmica'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: ListTile(
                title: Text('Nº de Matrícula'),
                subtitle: Text('2025001234'),
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(title: Text('Nome'), subtitle: Text(nome)),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text('Curso'),
                subtitle: Text('Sistemas de Informação'),
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text('Situação'),
                subtitle: Text('Matriculado'),
                trailing: Chip(
                  label: Text('Ativo'),
                  backgroundColor: Colors.green.shade100,
                  labelStyle: TextStyle(color: Colors.green.shade800),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Documentos Exigidos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...documentos.entries.map((doc) {
              return ListTile(
                leading: Icon(
                  doc.value ? Icons.check_circle : Icons.cancel,
                  color: doc.value ? Colors.green : Colors.red,
                ),
                title: Text(doc.key),
                trailing: Text(
                  doc.value ? 'Enviado' : 'Faltando',
                  style: TextStyle(
                    color: doc.value ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
            if (documentosPendentes > 0)
              Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Existem $documentosPendentes documento(s) pendente(s). Regularize para manter sua matrícula ativa.',
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
