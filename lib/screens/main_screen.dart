import 'package:flutter/material.dart';
import '../screens/home_list_screen.dart';
import '../screens/nova_denuncia_screen.dart';
import 'perfil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  void _onNovaDenunciaSalva() => setState(() => _index = 0);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeListScreen(onNovaDenuncia: () => setState(() => _index = 1)),
      NovaDenunciaScreen(onSalvar: _onNovaDenunciaSalva),
      const PerfilScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Denuncias'),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Nova',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
