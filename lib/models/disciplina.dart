class Disciplina {
  final String nome;
  final int periodo;
  final String status;
  final double? nota;
  final int? frequencia;
  final String? professor;
  final String? tipo;
  final String? horario;
  final int? cargaHoraria;

  Disciplina({
    required this.nome,
    required this.periodo,
    required this.status,
    this.nota,
    this.frequencia,
    this.professor,
    this.tipo,
    this.horario,
    this.cargaHoraria,
  });

  factory Disciplina.fromJson(Map<String, dynamic> json) {
    return Disciplina(
      nome: json['nome'],
      periodo: json['periodo'],
      status: json['status'],
      nota: (json['nota'] as num?)?.toDouble(),
      frequencia: json['frequencia'],
      professor: json['professor'],
      tipo: json['tipo'],
      horario: json['horario'],
      cargaHoraria: json['cargaHoraria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'periodo': periodo,
      'status': status,
      'nota': nota,
      'frequencia': frequencia,
      'professor': professor,
      'tipo': tipo,
      'horario': horario,
      'cargaHoraria': cargaHoraria,
    };
  }
}
