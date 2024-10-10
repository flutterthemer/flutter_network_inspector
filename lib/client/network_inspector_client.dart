import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_network_inspector/models/inspector_result.dart';
import 'package:http/http.dart' as http;
// import 'logger.dart';

class FNICLient extends http.BaseClient {
  final http.Client _client;

  // Declare a static ValueNotifier for a list of InspectorResult
  static final ValueNotifier<List<InspectorResult>> inspectorNotifierList =
      ValueNotifier<List<InspectorResult>>([]);

  FNICLient([http.Client? client]) : _client = client ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final DateTime startTime = DateTime.now();
    // doLog('Request started at: $startTime');

    final inspectorResult = InspectorResult();

    // Add a new InspectorResult to the list
    inspectorNotifierList.value.add(inspectorResult);

    // Log the request details
    // doLog('Request: ${request.method} ${request.url}');
    inspectorResult.headers = request.headers;
    // request.headers.forEach((key, value) {
    //   doLog('Header: $key: $value');
    // });
    if (request is http.Request) {
      // doLog('Request body: ${request.body}');
      inspectorResult.reqBody = request.body;
    }

    final response = await _client.send(request);

    // Read the response stream once and convert it into a new stream.
    final responseBodyBytes = await response.stream.toBytes();
    final responseBodyString = utf8.decode(responseBodyBytes);

    // Log the end time and calculate the duration
    final DateTime endTime = DateTime.now();
    final Duration duration = endTime.difference(startTime);
    // doLog('Request ended at: $endTime');
    // doLog('Time taken for request: ${duration.inMilliseconds} ms');

    // Ensure that the list is not empty before updating the last element
    if (inspectorNotifierList.value.isNotEmpty) {
      final updatedList =
          List<InspectorResult>.from(inspectorNotifierList.value);
      updatedList[updatedList.length - 1] = InspectorResult(
        baseRequest: request,
        url: request.url,
        statusCode: response.statusCode,
        resBody: responseBodyString,
        reasonPhrase: response.reasonPhrase,
        headers: response.headers,
        responseBodyBytes: responseBodyBytes.lengthInBytes,
        startTime: startTime,
        endTime: endTime,
        duration: duration,
      );
      inspectorNotifierList.value = updatedList;
    }

    // // Log the response
    // doLog('Response status: ${response.statusCode}');
    // doLog('Response body: $responseBodyString');

    // Create a new Stream from the response bytes
    final newStream = Stream.fromIterable([responseBodyBytes]);

    // Return the response with the new stream
    return http.StreamedResponse(
      newStream,
      response.statusCode,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
    );
  }

  @override
  void close() {
    _client.close();
  }
}
