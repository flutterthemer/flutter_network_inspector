import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_network_inspector/client/logger.dart';
import 'package:flutter_network_inspector/net_inspect.dart';

class Services {
  static Future<void> executeTestCalls() async {
    final dioClient = FNI.init(dio: Dio());
    FNI.setEnableLogging(false);

    var dioResponse = await dioClient.get(
      'https://jsonplaceholder.typicode.com/posts/1',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: '{"title": "foo", "body": "bar", "userId": 1}',
    );

    doLog('Final Response: ${dioResponse.data}');

    dioResponse = await dioClient.post(
      'https://jsonplaceholder.typicode.com/posts',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: '{"title": "foo", "body": "bar", "userId": 1}',
    );

    doLog('Final POST Response: ${dioResponse.data}');

    dioResponse = await dioClient.post(
      'https://jsonplaceholder.typicode.com/posts?userId=1',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final client = FNI.init(httpClient: http.Client());
    var response = await client.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json'},
      body: '{"title": "foo", "body": "bar", "userId": 1}',
    );
    doLog('Final Response: ${response.body}');

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

    response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=1'),
      headers: {'Content-Type': 'application/json'},
    );

    response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1/comments'),
      headers: {'Content-Type': 'application/json'},
    );

    response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},
    );

    response = await client.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json'},
      body: '{"title": "foo", "body": "bar", "userId": 1}',
    );

    response = await client.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=1'),
      headers: {'Content-Type': 'application/json'},
    );

    doLog('Final Response: ${response.body}');
  }
}
