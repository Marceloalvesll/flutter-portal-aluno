import 'dart:convert';
import 'package:http/http.dart' as http;

class RematriculaService {
  static const String baseUrl =
      'https://67f97d9d094de2fe6ea1b703.mockapi.io/disciplinasRematricula';

  static Future<List<String>> getDisciplinas() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes); // <- Aqui é o segredo
      final List jsonList = json.decode(decoded);
      return jsonList.map((e) => e['nome'].toString()).toList();
    } else {
      throw Exception('Erro ao buscar disciplinas de rematrícula');
    }
  }
}
