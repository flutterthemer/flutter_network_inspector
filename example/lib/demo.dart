import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/ui/inspector_ui.dart';
import 'package:network_interceptor_demo/services.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Services.getTodos();
            },
            child: const Text('Get ToDos'),
          ),
          const Expanded(
            child: InspectorUI(),
          )
        ],
      ),
    );
  }
}
