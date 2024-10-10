import 'package:flutter_network_inspector/client/logger.dart';
import 'package:flutter_network_inspector/net_inspect.dart';

class Services {
  static Future<void> getTodos() async {
    final client = FNICLient();

    final postResponse = await client.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},
      body: '{"title": "foo", "body": "bar", "userId": 1}',
    );
    doLog('Final Response: ${postResponse.body}');
  }
}
