import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class VerNotasScreen extends StatefulWidget {
  const VerNotasScreen({Key? key}) : super(key: key);

  @override
  _VerNotasScreenState createState() => _VerNotasScreenState();
}

class _VerNotasScreenState extends State<VerNotasScreen> {
  final DatabaseReference _notasRef = FirebaseDatabase.instance.ref('notas');
  List<Map<dynamic, dynamic>> _notas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    try {
      _notasRef.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        final List<Map<dynamic, dynamic>> notasCargadas = [];

        if (data != null) {
          data.forEach((key, value) {
            notasCargadas.add({
              'id': key,
              'titulo': value['titulo'],
              'descripcion': value['descripcion'],
              'precio': value['precio'],
            });
          });
        }

        setState(() {
          _notas = notasCargadas;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar notas: $e')),
      );
    }
  }

  Future<void> _editarNota(Map<dynamic, dynamic> nota) async {
    final tituloController = TextEditingController(text: nota['titulo']);
    final descripcionController =
        TextEditingController(text: nota['descripcion']);
    final precioController = TextEditingController(text: nota['precio']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Nota'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final notaActualizada = {
                  'titulo': tituloController.text,
                  'descripcion': descripcionController.text,
                  'precio': precioController.text,
                };

                _notasRef.child(nota['id']).update(notaActualizada);

                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarNota(Map<dynamic, dynamic> nota) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Nota'),
          content: const Text('¿Estás seguro de que deseas eliminar esta nota?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _notasRef.child(nota['id']).remove();

                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas Existentes'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/736x/58/7c/6a/587c6acf720e9677a946aea0841f4231.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: _notas.isEmpty
            ? const Center(
                child: Text(
                  'No hay notas disponibles',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: _notas.length,
                itemBuilder: (context, index) {
                  final nota = _notas[index];
                  return Card(
                    color: Colors.black87.withOpacity(0.8),
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        nota['titulo'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Descripción: ${nota['descripcion']}\nPrecio: ${nota['precio']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              _editarNota(nota);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _eliminarNota(nota);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
