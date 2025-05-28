// lib/services/disciplina_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/disciplina.dart';

class DisciplinaService {
  static const String baseUrl =
      'https://67f97d9d094de2fe6ea1b703.mockapi.io/disciplinasCurso';

  static const String rematriculaUrl =
      'https://67f97d9d094de2fe6ea1b703.mockapi.io/disciplinasRematricula';

  static Future<List<Disciplina>> getDisciplinas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final List jsonList = json.decode(decoded);
      return jsonList.map((json) => Disciplina.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar disciplinas');
    }
  }

  static Future<void> salvarRematricula(String nomeDisciplina) async {
    final jaExiste = await jaRematriculada(nomeDisciplina);
    if (jaExiste) return;

    final response = await http.post(
      Uri.parse(rematriculaUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nomeDisciplina}),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao salvar rematrícula');
    }
  }

  static Future<List<String>> getDisciplinasRematriculadas() async {
    final response = await http.get(Uri.parse(rematriculaUrl));
    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final List data = json.decode(decoded);
      return data.map<String>((item) => item['nome'].toString()).toList();
    } else {
      throw Exception('Erro ao carregar rematrículas');
    }
  }

  static Future<bool> jaRematriculada(String nome) async {
    final disciplinas = await getDisciplinasRematriculadas();
    return disciplinas.contains(nome);
  }
}
