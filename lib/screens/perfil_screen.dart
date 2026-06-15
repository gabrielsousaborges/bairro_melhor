import 'package:flutter/material.dart';
import '../data/denuncia_repository.dart';
import '../widgets/denuncia_card.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = DenunciaRepository.instance;
    final denuncias = repo.all;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFF1565C0),
                child: Text(
                  'JM',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Joao Morador',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('Vila Madalena, SP'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Estatistica(label: 'Enviadas', valor: repo.total),
              _Estatistica(label: 'Resolvidas', valor: repo.resolvidos),
              _Estatistica(label: 'Pendentes', valor: repo.pendentes),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Historico de denuncias',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...denuncias.map((d) => DenunciaCard(denuncia: d)),
        ],
      ),
    );
  }
}

class _Estatistica extends StatelessWidget {
  final String label;
  final int valor;
  const _Estatistica({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(
                '$valor',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
