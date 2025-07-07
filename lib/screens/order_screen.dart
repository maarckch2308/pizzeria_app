import 'package:flutter/material.dart';
import '../models/pizza_model.dart';

class OrderScreen extends StatefulWidget {
  final Pizza pizza;

  OrderScreen({required this.pizza});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int cantidad = 1;
  String mesa = '';

  void _enviarPedido() {
    if (mesa.isNotEmpty) {
      // Aquí puedes usar Firebase, SQLite o simplemente imprimir por ahora
      print("🍕 Pedido enviado a la cocina:");
      print("Pizza: ${widget.pizza.nombre}");
      print("Cantidad: $cantidad");
      print("Mesa: $mesa");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pedido enviado a la cocina")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pedido")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.pizza.nombre, style: TextStyle(fontSize: 24)),
            Text("Precio: \$${widget.pizza.precio.toStringAsFixed(2)}"),
            Row(
              children: [
                Text("Cantidad: "),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (cantidad > 1) setState(() => cantidad--);
                  },
                ),
                Text("$cantidad"),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() => cantidad++);
                  },
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(labelText: "Número de mesa"),
              keyboardType: TextInputType.number,
              onChanged: (value) => mesa = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Enviar pedido"),
              onPressed: _enviarPedido,
            )
          ],
        ),
      ),
    );
  }
}
