import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/ui/inspector_ui.dart';
import 'package:network_interceptor_demo/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Network Inspector Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Network Inspector'),
        ),
        body: const Column(
          children: [
            ElevatedButton(
              onPressed: Services.getTodos,
              child: Text('Get ToDos'),
            ),
            Expanded(child: InspectorUI())
          ],
        ),
      ),
    );
  }
}
