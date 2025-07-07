import 'package:flutter/material.dart';
import 'menu_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Ver menú de pizzas'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => MenuScreen(),
            ));
          },
        ),
      ),
    );
  }
}
