import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/denuncia.dart';

class DenunciaCard extends StatelessWidget {
  final Denuncia denuncia;
  final VoidCallback? onDismissed;

  const DenunciaCard({super.key, required this.denuncia, this.onDismissed});

  @override
  Widget build(BuildContext context) {
    final dataFormatada = DateFormat('dd/MM/yyyy').format(denuncia.data);

    final card = Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
          child: Icon(denuncia.tipo.icon, color: const Color(0xFF1565C0)),
        ),
        title: Text(denuncia.descricao),
        subtitle: Text('${denuncia.localizacao}\n$dataFormatada'),
        isThreeLine: true,
        trailing: Chip(
          label: Text(
            denuncia.status.label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: denuncia.status.color,
        ),
      ),
    );

    if (onDismissed == null) return card;

    return Dismissible(
      key: ValueKey(denuncia.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss:
          (_) => showDialog<bool>(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: const Text('Excluir denúncia'),
                  content: const Text(
                    'Tem certeza que deseja excluir esta denúncia?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Excluir'),
                    ),
                  ],
                ),
          ).then((value) => value ?? false),
      onDismissed: (_) => onDismissed?.call(),
      child: card,
    );
  }
}
