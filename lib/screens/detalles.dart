import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class VerNotasScreen extends StatelessWidget {
  const VerNotasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final DatabaseReference notasRef = FirebaseDatabase.instance.ref('notas');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas Existentes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: notasRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No hay notas disponibles.', style: TextStyle(color: Colors.white)));
          }

          final Map<dynamic, dynamic> notasMap =
              (snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
          final List<Map<dynamic, dynamic>> notas =
              notasMap.entries.map((e) => {'key': e.key, ...e.value}).toList();

          return ListView.builder(
            itemCount: notas.length,
            itemBuilder: (context, index) {
              final nota = notas[index];
              return Card(
                color: Colors.grey[800],
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(nota['titulo'], style: const TextStyle(color: Colors.white)),
                  subtitle: Text(nota['descripcion'], style: const TextStyle(color: Colors.white)),
                  trailing: Text("\$${nota['precio']}", style: const TextStyle(color: Colors.white)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}