import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'First Page',
      home: Scaffold(
        body: Center(
          child: Text('First Page'),
        ),
      ),
    );
  }
}