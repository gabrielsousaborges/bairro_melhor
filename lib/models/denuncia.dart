import 'package:flutter/material.dart';

enum TipoProblema { buraco, lixo, iluminacao, esgoto }

enum StatusDenuncia { pendente, analise, resolvido }

extension TipoProblemaExt on TipoProblema {
  String get label {
    switch (this) {
      case TipoProblema.buraco:
        return 'Buraco na via';
      case TipoProblema.lixo:
        return 'Lixo acumulado';
      case TipoProblema.iluminacao:
        return 'Iluminação';
      case TipoProblema.esgoto:
        return 'Esgoto/Água';
    }
  }

  IconData get icon {
    switch (this) {
      case TipoProblema.buraco:
        return Icons.warning_amber_rounded;
      case TipoProblema.lixo:
        return Icons.delete_outline;
      case TipoProblema.iluminacao:
        return Icons.lightbulb_outline;
      case TipoProblema.esgoto:
        return Icons.water_drop_outlined;
    }
  }
}

extension StatusDenunciaExt on StatusDenuncia {
  String get label {
    switch (this) {
      case StatusDenuncia.pendente:
        return 'Pendente';
      case StatusDenuncia.analise:
        return 'Em análise';
      case StatusDenuncia.resolvido:
        return 'Resolvido';
    }
  }

  Color get color {
    switch (this) {
      case StatusDenuncia.pendente:
        return Colors.orange;
      case StatusDenuncia.analise:
        return Colors.blue;
      case StatusDenuncia.resolvido:
        return Colors.green;
    }
  }
}

class Denuncia {
  final String id;
  final TipoProblema tipo;
  final String descricao;
  final String localizacao;
  final DateTime data;
  StatusDenuncia status;
  final String? fotoPath;

  Denuncia({
    required this.id,
    required this.tipo,
    required this.descricao,
    required this.localizacao,
    required this.data,
    this.status = StatusDenuncia.pendente,
    this.fotoPath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'tipo': tipo.index,
    'descricao': descricao,
    'localizacao': localizacao,
    'data': data.toIso8601String(),
    'status': status.index,
    'fotoPath': fotoPath,
  };

  factory Denuncia.fromJson(Map<String, dynamic> json) => Denuncia(
    id: json['id'],
    tipo: TipoProblema.values[json['tipo']],
    descricao: json['descricao'],
    localizacao: json['localizacao'],
    data: DateTime.parse(json['data']),
    status: StatusDenuncia.values[json['status']],
    fotoPath: json['fotoPath'],
  );
}
