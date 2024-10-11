import 'dart:convert';

import 'package:flutter_network_inspector/client/logger.dart';
import 'package:flutter_network_inspector/net_inspect.dart';

class Services {
  static Future<void> executeTestCalls() async {
    final client = FNICLient();
    client.setEnableLogging(false);

    var response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},
    );
    // doLog('Final Response: ${response.body}');

    response = await client.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json'},
      body: '{"title": "foo", "body": "bar", "userId": 1}',
    );
    // doLog('Final Response: ${response.body}');

    response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1/comments'),
      headers: {'Content-Type': 'application/json'},
    );
    // doLog('Final Response: ${response.body}');

    response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=1'),
      headers: {'Content-Type': 'application/json'},
    );
    // doLog('Final Response: ${response.body}');

    response = await client.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        "id": 1,
        "title": "foo",
        "body": "bar",
        "userId": 1,
      }),
    );
    doLog('Final Response: ${response.body}');

    response = await client.patch(
      Uri.parse('https://jsonplaceholder.typicode.com/post/1'),
      headers: {'Content-Type': 'application/json'},
    );
    // doLog('Final Response: ${response.body}');

    response = await client.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json'},
    );
    // doLog('Final Response: ${response.body}');
  }
}
