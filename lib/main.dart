import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// void main() => runApp(PizzaApp());

void main() async {
  runApp(const PizzaApp());
}


class PizzaApp extends StatelessWidget {
  const PizzaApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzería',
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomeScreen(),
    );
  }
}
