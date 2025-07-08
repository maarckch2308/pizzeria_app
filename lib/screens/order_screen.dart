import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pizza_model.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  // Cambiar estado a "listo"
  void _marcarPedidoListo(BuildContext context, String pedidoId) {
    FirebaseFirestore.instance.collection('orders').doc(pedidoId).update({
      'estado': 'listo',
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido marcado como listo')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pendientes'),
              Tab(text: 'Listos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña Pedidos Pendientes
            _buildPedidoList(context, estado: 'pendiente'),
            // Pestaña Pedidos Listos
            _buildPedidoList(context, estado: 'listo'),
          ],
        ),
      ),
    );
  }

  Widget _buildPedidoList(BuildContext context, {required String estado}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('estado', isEqualTo: estado)
          .orderBy('fecha')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No hay pedidos $estado'));
        }

        final pedidos = snapshot.data!.docs;

        return ListView.builder(
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            final pedido = pedidos[index];
            final pedidoId = pedido.id;
            final mesa = pedido['mesa'];
            final fecha = pedido['fecha'].toDate();

            return Card(
              margin: const EdgeInsets.all(10),
              child: ExpansionTile(
                title: Text('Mesa $mesa'),
                subtitle: Text(
                  'Fecha: ${fecha.toLocal().toString().substring(0, 16)}',
                ),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .doc(pedidoId)
                        .collection('items')
                        .snapshots(),
                    builder: (context, itemsSnapshot) {
                      if (itemsSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!itemsSnapshot.hasData || itemsSnapshot.data!.docs.isEmpty) {
                        return const Text('Sin items');
                      }

                      final items = itemsSnapshot.data!.docs
                          .map((doc) => PizzaItem.fromMap(
                              doc.data() as Map<String, dynamic>))
                          .toList();

                      return Column(
                        children: items.map((item) {
                          return ListTile(
                            title: Text(
                                '${item.nombre} (x${item.cantidad}) - \$${item.precio}'),
                            subtitle: Text(item.notas.isNotEmpty
                                ? 'Notas: ${item.notas}'
                                : 'Sin notas'),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  if (estado == 'pendiente')
                    ElevatedButton(
                      onPressed: () => _marcarPedidoListo(context, pedidoId),
                      child: const Text('Marcar como Listo'),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
