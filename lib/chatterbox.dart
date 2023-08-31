import 'package:flutter/material.dart';

class ChatterBox extends StatelessWidget {
  const ChatterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter Box',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text("Chatter Box"),
        ),
      ),
    );
  }
}
