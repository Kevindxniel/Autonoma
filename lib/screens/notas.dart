import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AgregarNotaScreen extends StatefulWidget {
  const AgregarNotaScreen({Key? key}) : super(key: key);

  @override
  _AgregarNotaScreenState createState() => _AgregarNotaScreenState();
}

class _AgregarNotaScreenState extends State<AgregarNotaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  // Referencia a Firebase Realtime Database
  final DatabaseReference _notasRef = FirebaseDatabase.instance.ref('notas');

  Future<void> _guardarNota() async {
    if (_formKey.currentState!.validate()) {
      final nota = {
        'titulo': _tituloController.text,
        'descripcion': _descripcionController.text,
        'precio': double.parse(_precioController.text),
      };

      try {
        await _notasRef.push().set(nota);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nota guardada correctamente')),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error al guardar la nota: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la nota: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nota'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/736x/1b/14/1f/1b141f2029ae2518ff055781fc04b463.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un título';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una descripción';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: _precioController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa un precio';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Por favor, ingresa un precio válido';
                      }
                      return null;
                    }),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _guardarNota,
                  child: const Text('Guardar Nota'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}