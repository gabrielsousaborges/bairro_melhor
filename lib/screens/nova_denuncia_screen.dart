import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/denuncia_repository.dart';
import '../models/denuncia.dart';

class NovaDenunciaScreen extends StatefulWidget {
  final VoidCallback? onSalvar;
  const NovaDenunciaScreen({super.key, this.onSalvar});

  @override
  State<NovaDenunciaScreen> createState() => _NovaDenunciaScreenState();
}

class _NovaDenunciaScreenState extends State<NovaDenunciaScreen> {
  TipoProblema _tipoSelecionado = TipoProblema.buraco;
  final _descricaoController = TextEditingController();
  final _localizacaoController = TextEditingController(
    text: 'Toque para informar o endereço',
  );
  XFile? _foto;

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final foto = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (foto != null) setState(() => _foto = foto);
  }

  Future<void> _enviarDenuncia() async {
    if (_descricaoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descreva o problema antes de enviar.')),
      );
      return;
    }

    final novaDenuncia = Denuncia(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipo: _tipoSelecionado,
      descricao: _descricaoController.text.trim(),
      localizacao: _localizacaoController.text.trim(),
      data: DateTime.now(),
      fotoPath: _foto?.path,
    );

    await DenunciaRepository.instance.add(novaDenuncia);

    if (!mounted) return;
    _descricaoController.clear();
    setState(() => _foto = null);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Denúncia enviada com sucesso!')),
    );

    widget.onSalvar?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Denúncia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tipo de problema',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.4,
              children:
                  TipoProblema.values.map((tipo) {
                    final selecionado = tipo == _tipoSelecionado;
                    return InkWell(
                      onTap: () => setState(() => _tipoSelecionado = tipo),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              selecionado
                                  ? const Color(0xFF1565C0)
                                  : Colors.white,
                          border: Border.all(color: const Color(0xFF1565C0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tipo.icon,
                              color:
                                  selecionado
                                      ? Colors.white
                                      : const Color(0xFF1565C0),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tipo.label,
                              style: TextStyle(
                                color:
                                    selecionado
                                        ? Colors.white
                                        : const Color(0xFF1565C0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descrição',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descricaoController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Descreva o problema encontrado',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Foto do problema (opcional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selecionarFoto,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    _foto == null
                        ? const Center(
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            size: 32,
                            color: Colors.grey,
                          ),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_foto!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Localização',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _localizacaoController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _enviarDenuncia,
              child: const Text('Enviar Denúncia'),
            ),
          ],
        ),
      ),
    );
  }
}
