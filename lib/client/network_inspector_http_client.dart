import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_network_inspector/client/fni.dart';
import 'package:flutter_network_inspector/client/logger.dart';
import 'package:flutter_network_inspector/models/inspector_result.dart';
import 'package:flutter_network_inspector/utils/data.dart';
import 'package:flutter_network_inspector/utils/utils.dart';
import 'package:http/http.dart' as http;

class FNIHttpCLient extends http.BaseClient {
  http.Client _client = http.Client();

  factory FNIHttpCLient(http.Client? c) {
    if (c == null) {
      return FNIHttpCLient._internal(http.Client());
    }
    return FNIHttpCLient._internal(c);
  }

  FNIHttpCLient._internal(this._client);

  http.Client get client => _client;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final startTime = DateTime.now();
    final inspectorResult = InspectorResult();

    final connectionType = await getConnectionType();
    final sslDetails = await getSSLDetails(request.url);

    // Add a new InspectorResult to the list
    inspectorNotifierList.value.add(inspectorResult);

    // Log the request details
    if (logEnabled) {
      doLog('Sending request to ${request.url}');
      doLog('Request Method: ${request.method}');
      doLog('Request Headers: ${request.headers}');
      if (request is http.Request) {
        doLog('Request Body: ${request.body}');
      }
    }

    inspectorResult.headers = request.headers;
    if (request is http.Request) {
      inspectorResult.reqBody = request.body;
    }

    try {
      final response = await _client.send(request);

      // Read the response stream once and convert it into a new stream.
      final responseBodyBytes = await response.stream.toBytes();
      // final responseBodyString = toPrettyJson(utf8.decode(responseBodyBytes));

      final decodedResponse = utf8.decode(responseBodyBytes);
      final responseBodyString = json.decode(decodedResponse) is List
          ? toPrettyJsonList(decodedResponse)
          : toPrettyJson(decodedResponse);

      // Log the end time and calculate the duration
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      if (logEnabled) {
        doLog('Response status: ${response.statusCode}');
        doLog('Response reason phrase: ${response.reasonPhrase}');
        doLog('Response Headers: ${response.headers}');
        doLog('Response Body: $responseBodyString');
        doLog('Connection Type: $connectionType');
        doLog(
          'SSL Details: Subject: ${sslDetails?.subject}, Issuer: ${sslDetails?.issuer}',
        );
      }

      // Ensure that the list is not empty before updating the last element
      if (inspectorNotifierList.value.isNotEmpty) {
        final updatedList = List<InspectorResult>.from(
          inspectorNotifierList.value,
        );
        updatedList[updatedList.length - 1] = InspectorResult(
          baseRequest: request,
          reqBody: inspectorResult.reqBody,
          url: request.url,
          method: request.method,
          statusCode: response.statusCode,
          resBody: responseBodyString,
          reasonPhrase: response.reasonPhrase,
          headers: response.headers,
          responseBodyBytes: responseBodyBytes.lengthInBytes,
          startTime: startTime,
          endTime: endTime,
          duration: duration,
          connectionType: connectionType,
          sslDetails: sslDetails,
          logEnabled: logEnabled,
        );
        inspectorNotifierList.value = updatedList;
      }

      // Create a new Stream from the response bytes
      final newStream = Stream.fromIterable([responseBodyBytes]);

      return http.StreamedResponse(
        newStream,
        response.statusCode,
        headers: response.headers,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Handle errors
      if (e is SocketException) {
        inspectorResult.reasonPhrase = 'Network Error: ${e.message}';
        if (logEnabled) doLog('Network Error: ${e.message}');
      } else {
        inspectorResult.reasonPhrase = 'Error: ${e.toString()}';
        if (logEnabled) doLog('Error: ${e.toString()}');
      }

      // Update inspectorResult even if there's an error
      inspectorResult.statusCode = 0;
      inspectorResult.endTime = endTime;
      inspectorResult.duration = duration;
      inspectorResult.connectionType = connectionType;
      inspectorResult.sslDetails = sslDetails;

      inspectorNotifierList.value.add(inspectorResult);

      rethrow;
    }
  }

  @override
  void close() {
    _client.close();
    if (logEnabled) doLog('FNI Client Closed');
  }
}
