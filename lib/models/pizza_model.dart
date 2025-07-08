class PizzaItem {
  final String nombre;
  final int cantidad;
  final double precio;
  final String notas;

  PizzaItem({
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.notas,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cantidad': cantidad,
      'precio': precio,
      'notas': notas,
    };
  }

  factory PizzaItem.fromMap(Map<String, dynamic> map) {
    return PizzaItem(
      nombre: map['nombre'] ?? '',
      cantidad: int.tryParse(map['cantidad'].toString()) ?? 0,
      precio: double.tryParse(map['precio'].toString()) ?? 0.0,
      notas: map['notas'] ?? '',
    );
  }
}
