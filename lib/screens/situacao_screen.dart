import 'package:flutter/material.dart';

class SituacaoScreen extends StatelessWidget {
  final Map<String, String> status = {
    'Matrícula': 'Ativa',
    'Documentação': 'Completa',
    'Pendências Financeiras': 'Nenhuma',
    'Status Geral': 'Regular'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Situação Acadêmica')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: status.length,
        itemBuilder: (context, index) {
          final chave = status.keys.elementAt(index);
          final valor = status[chave];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(chave),
              subtitle: Text(valor!),
              leading: Icon(Icons.info_outline),
            ),
          );
        },
      ),
    );
  }
}
