import 'package:flutter/material.dart';
import '../data/denuncia_repository.dart';
import '../widgets/denuncia_card.dart';

class HomeListScreen extends StatefulWidget {
  final VoidCallback? onNovaDenuncia;
  const HomeListScreen({super.key, this.onNovaDenuncia});

  @override
  State<HomeListScreen> createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  @override
  Widget build(BuildContext context) {
    final denuncias = DenunciaRepository.instance.all;

    return Scaffold(
      appBar: AppBar(title: const Text('Bairro Melhor')),
      body:
          denuncias.isEmpty
              ? const Center(child: Text('Nenhuma denúncia registrada ainda.'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: denuncias.length,
                itemBuilder: (context, i) {
                  final denuncia = denuncias[i];
                  return DenunciaCard(
                    denuncia: denuncia,
                    onDismissed: () async {
                      await DenunciaRepository.instance.remove(denuncia.id);
                      if (!mounted) return;
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Denúncia excluída.')),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onNovaDenuncia,
        icon: const Icon(Icons.add),
        label: const Text('Nova Denúncia'),
      ),
    );
  }
}
