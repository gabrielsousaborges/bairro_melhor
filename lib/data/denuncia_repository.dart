import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/denuncia.dart';

class DenunciaRepository {
  DenunciaRepository._();
  static final DenunciaRepository instance = DenunciaRepository._();

  static const _storageKey = 'denuncias';

  List<Denuncia> _denuncias = [];
  bool _carregado = false;

  List<Denuncia> get all => List.unmodifiable(_denuncias);

  int get total => _denuncias.length;
  int get resolvidos =>
      _denuncias.where((d) => d.status == StatusDenuncia.resolvido).length;
  int get pendentes =>
      _denuncias.where((d) => d.status != StatusDenuncia.resolvido).length;

  Future<void> carregar() async {
    if (_carregado) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null) {
      _denuncias = _seed();
      await _salvar();
    } else {
      final List<dynamic> lista = jsonDecode(raw);
      _denuncias = lista.map((e) => Denuncia.fromJson(e)).toList();
    }

    _carregado = true;
  }

  Future<void> add(Denuncia denuncia) async {
    _denuncias.insert(0, denuncia);
    await _salvar();
  }

  Future<void> remove(String id) async {
    _denuncias.removeWhere((d) => d.id == id);
    await _salvar();
  }

  Future<void> _salvar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_denuncias.map((d) => d.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }

  List<Denuncia> _seed() => [
    Denuncia(
      id: '1',
      tipo: TipoProblema.buraco,
      descricao: 'Buraco grande na Rua das Flores',
      localizacao: 'Rua das Flores, 120 - Vila Madalena',
      data: DateTime(2025, 5, 12),
      status: StatusDenuncia.resolvido,
    ),
    Denuncia(
      id: '2',
      tipo: TipoProblema.lixo,
      descricao: 'Lixo acumulado na Av. Principal',
      localizacao: 'Av. Principal - Vila Madalena',
      data: DateTime(2025, 5, 28),
      status: StatusDenuncia.analise,
    ),
  ];
}
