import 'package:flutter/material.dart';
import 'package:notas_1/screens/detalles.dart';
import 'package:notas_1/screens/notas.dart';

class MiDrawer extends StatelessWidget {
  const MiDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Menú",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Series"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AgregarNotaScreen()),
            ),
          ),
          ListTile(
            title: const Text("Comentarios"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VerNotasScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
