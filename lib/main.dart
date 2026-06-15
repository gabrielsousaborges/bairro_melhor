import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'data/denuncia_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DenunciaRepository.instance.carregar();
  runApp(const BairroMelhorApp());
}

class BairroMelhorApp extends StatelessWidget {
  const BairroMelhorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bairro Melhor',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
