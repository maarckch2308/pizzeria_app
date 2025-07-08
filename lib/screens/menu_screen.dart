import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pizza_model.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _mesaController = TextEditingController();
  final List<PizzaItem> _items = [];

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();

  void _agregarItem() {
    setState(() {
      _items.add(
        PizzaItem(
          nombre: _nombreController.text,
          cantidad: int.parse(_cantidadController.text),
          precio: double.parse(_precioController.text),
          notas: _notasController.text,
        ),
      );
      // Limpiar campos luego de añadir
      _nombreController.clear();
      _cantidadController.clear();
      _precioController.clear();
      _notasController.clear();
    });
  }

  Future<void> _registrarPedido() async {
    final mesa = int.tryParse(_mesaController.text);
    if (mesa == null || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega una mesa válida y al menos un item')),
      );
      return;
    }

    // Crear pedido en Firestore
    final pedidoRef = await FirebaseFirestore.instance.collection('orders').add({
      'mesa': mesa,
      'fecha': Timestamp.now(),
      'estado': 'pendiente',
    });

    // Agregar items del pedido
    for (var item in _items) {
      await pedidoRef.collection('items').add(item.toMap());
    }

    // Mostrar mensaje y limpiar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido registrado con éxito')),
    );
    _mesaController.clear();
    setState(() {
      _items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Pedido')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _mesaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número de mesa'),
            ),
            const SizedBox(height: 20),
            const Text('Agregar Pizza o Bebida', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del producto'),
            ),
            TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            TextField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            TextField(
              controller: _notasController,
              decoration: const InputDecoration(labelText: 'Notas (opcional)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _agregarItem,
              child: const Text('Agregar al Pedido'),
            ),
            const SizedBox(height: 20),
            const Text('Items del Pedido:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text('${item.nombre} (x${item.cantidad})'),
                  subtitle: Text('Precio: \$${item.precio}'),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrarPedido,
              child: const Text('Registrar Pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
