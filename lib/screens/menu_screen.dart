import 'package:flutter/material.dart';
import '../models/pizza_model.dart';
import 'order_screen.dart';

class MenuScreen extends StatelessWidget {
  final List<Pizza> menu = [
    Pizza(nombre: "Pizza Margarita", descripcion: "Tomate y albahaca", precio: 8.99, imagen: "🍕"),
    Pizza(nombre: "Pizza Pepperoni", descripcion: "Clásica con pepperoni", precio: 9.99, imagen: "🍕"),
    Pizza(nombre: "Pizza Hawaiana", descripcion: "Piña y jamón", precio: 10.50, imagen: "🍍"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menú de Pizzas")),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final pizza = menu[index];
          return ListTile(
            leading: Text(pizza.imagen, style: TextStyle(fontSize: 30)),
            title: Text(pizza.nombre),
            subtitle: Text(pizza.descripcion),
            trailing: Text("\$${pizza.precio.toStringAsFixed(2)}"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => OrderScreen(pizza: pizza),
              ));
            },
          );
        },
      ),
    );
  }
}
