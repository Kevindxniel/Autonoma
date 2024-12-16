import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AgregarNotaScreen extends StatefulWidget {
  const AgregarNotaScreen({Key? key}) : super(key: key);

  @override
  _AgregarNotaScreenState createState() => _AgregarNotaScreenState();
}

class _AgregarNotaScreenState extends State<AgregarNotaScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  // Referencia a Firebase Realtime Database
  final DatabaseReference _notasRef = FirebaseDatabase.instance.ref('notas');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final nota = {
                  'titulo': _tituloController.text,
                  'descripcion': _descripcionController.text,
                  'precio': _precioController.text,
                };

                try {
                  await _notasRef.push().set(nota); // Guarda la nota
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nota guardada correctamente')),
                  );
                  Navigator.pop(context); // Vuelve a la pantalla anterior
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Guardar Nota'),
            ),
          ],
        ),
      ),
    );
  }
}