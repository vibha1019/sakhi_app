import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MicroMitra'),
      ),
      body: Center(
        child: Text(
          'Home Screen - Coming Soon!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}