import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pizza_app/firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario antes de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PizzaApp());
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzería',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/menu': (context) => const MenuScreen(),
        '/orders': (context) => const OrderScreen(),
      },
    );
  }
}
