import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_network_inspector/client/fni.dart';
import 'package:flutter_network_inspector/client/logger.dart';
import 'package:flutter_network_inspector/models/inspector_result.dart';
import 'package:flutter_network_inspector/utils/data.dart';
import 'package:flutter_network_inspector/utils/utils.dart';

RequestOptions? _options;

class FNIDioClient {
  //
  Dio _dio;

  /// Factory constructor that initializes the Dio instance and adds the interceptor.
  factory FNIDioClient(Dio? d) {
    if (d == null) {
      final dio = Dio();
      dio.interceptors.add(FNIDioInterceptor());
      return FNIDioClient._internal(dio);
    }
    d.interceptors.add(FNIDioInterceptor());
    return FNIDioClient._internal(d);
  }

  /// Private constructor for initializing the Dio instance.
  FNIDioClient._internal(this._dio);

  /// Returns the Dio instance.
  Dio get dio => _dio;
}

class FNIDioInterceptor extends Interceptor {
  FNIDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();

    _options = options;

    // Log request details
    if (logEnabled) {
      doLog("Sending request to ${options.uri}");
      doLog("Request Method: ${options.method}");
      doLog("Request Headers: ${options.headers}");
      if (options.data != null) {
        doLog("Request Body: ${options.data}");
      }
    }

    // Add request details to inspector notifier
    final inspectorResult = InspectorResult()..startTime = startTime;

    // Add to the notifier list
    inspectorNotifierList.value.add(inspectorResult);

    options.extra['startTime'] = startTime;
    handler.next(options);
    doLog(options.method);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final endTime = DateTime.now();
    final startTime = response.requestOptions.extra['startTime'] as DateTime;
    final duration = endTime.difference(startTime);
    final connectionType = await getConnectionType();

    // Log response details
    if (logEnabled) {
      doLog("Response status: ${response.statusCode}");
      doLog("Response Headers: ${response.headers}");
      doLog("Response Body: ${response.data}");
      doLog("Request Duration: $duration");
    }

    final sslDetails = await getSSLDetails(_options!.uri);

    // Convert response data to bytes
    List<int> responseBodyBytes;
    if (response.data is String) {
      responseBodyBytes = utf8.encode(response.data);
    } else if (response.data is List<int>) {
      responseBodyBytes = utf8.encode(response.data);
    } else {
      responseBodyBytes = utf8.encode(jsonEncode(response.data));
    }

    if (inspectorNotifierList.value.isNotEmpty) {
      final updatedList = List<InspectorResult>.from(
        inspectorNotifierList.value,
      );
      updatedList[updatedList.length - 1] = InspectorResult(
        dioRequestOptions: _options,
        reqBody: _options?.data,
        url: _options?.uri,
        method: _options?.method,
        headers: _options?.headers,
        statusCode: response.statusCode,
        resBody: toPrettyJson(jsonEncode(response.data)),
        responseBodyBytes: responseBodyBytes.length,
        startTime: startTime,
        endTime: endTime,
        duration: duration,
        connectionType: connectionType,
        sslDetails: sslDetails,
        logEnabled: logEnabled,
      );
      inspectorNotifierList.value = updatedList;
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error details
    if (logEnabled) {
      doLog("Error occurred: ${err.message}");
    }

    // Update the last inspector result with error details
    if (inspectorNotifierList.value.isNotEmpty) {
      final lastInspectorResult = inspectorNotifierList.value.last;
      lastInspectorResult.reasonPhrase = err.message;
      lastInspectorResult.statusCode = 0; // Error case
      lastInspectorResult.endTime = DateTime.now(); // Set end time on error
    }

    handler.next(err);
  }
}
