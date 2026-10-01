import 'package:flutter/material.dart';
import './transferencias/lista.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja de Roupas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.checkroom,
              size: 100,
              color: Colors.pink,
            ),

            const SizedBox(height: 20),

            const Text(
              'Loja de Roupas',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Controle de compras',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaComprasRoupa(),
                  ),
                );
              },
              icon: const Icon(Icons.checkroom),
              label: const Text('Ver compras'),
            ),
          ],
        ),
      ),
    );
  }
}