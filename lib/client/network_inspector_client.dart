import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Import this for SocketException
import 'package:flutter/foundation.dart';
import 'package:flutter_network_inspector/client/logger.dart';
import 'package:flutter_network_inspector/models/inspector_result.dart';
import 'package:http/http.dart' as http;

class FNICLient extends http.BaseClient {
  final http.Client _client;

  // Declare a static ValueNotifier for a list of InspectorResult
  static final ValueNotifier<List<InspectorResult>> inspectorNotifierList =
      ValueNotifier<List<InspectorResult>>([]);

  FNICLient([http.Client? client]) : _client = client ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final DateTime startTime = DateTime.now();
    final inspectorResult = InspectorResult();

    // Add a new InspectorResult to the list
    inspectorNotifierList.value.add(inspectorResult);

    // Log the request details
    inspectorResult.headers = request.headers;
    if (request is http.Request) {
      inspectorResult.reqBody = request.body;
      doLog(inspectorResult.reqBody);
    }

    try {
      final response = await _client.send(request);

      // Read the response stream once and convert it into a new stream.
      final responseBodyBytes = await response.stream.toBytes();
      final responseBodyString = utf8.decode(responseBodyBytes);

      // Log the end time and calculate the duration
      final DateTime endTime = DateTime.now();
      final Duration duration = endTime.difference(startTime);

      // Ensure that the list is not empty before updating the last element
      if (inspectorNotifierList.value.isNotEmpty) {
        final updatedList =
            List<InspectorResult>.from(inspectorNotifierList.value);
        updatedList[updatedList.length - 1] = InspectorResult(
          baseRequest: request,
          reqBody: inspectorResult.reqBody,
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

      // Create a new Stream from the response bytes
      final newStream = Stream.fromIterable([responseBodyBytes]);

      // Return the response with the new stream
      return http.StreamedResponse(
        newStream,
        response.statusCode,
        headers: response.headers,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      final DateTime endTime = DateTime.now();
      final Duration duration = endTime.difference(startTime);

      // Handle errors
      if (e is SocketException) {
        // Handle network errors
        inspectorResult.reasonPhrase = 'Network Error: ${e.message}';
      } else {
        // Handle other types of exceptions
        inspectorResult.reasonPhrase = 'Error: ${e.toString()}';
      }

      // Log the error details
      // doLog('Request failed: ${inspectorResult.reasonPhrase}');

      // Update inspectorResult even if there's an error
      inspectorResult.statusCode = 0;
      inspectorResult.endTime = endTime;
      inspectorResult.duration = duration;

      // Add the failed request result to the notifier list
      inspectorNotifierList.value.add(inspectorResult);

      rethrow;
    }
  }

  @override
  void close() {
    _client.close();
  }
}
