import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/ui/details_screen.dart';
import 'package:flutter_network_inspector/ui/inspector_ui.dart';

class FNIHome extends StatelessWidget {
  const FNIHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => const InspectorUI();
            break;
          case '/details':
            builder = (BuildContext _) => const DetailsScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
