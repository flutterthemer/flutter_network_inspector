import 'package:dio/dio.dart';
import 'package:flutter_network_inspector/models/ssl_details.dart';
import 'package:http/http.dart';

class InspectorResult {
  Uri? url;
  String? reqBody;
  String? resBody;
  String? reasonPhrase;
  String? method;
  Map<dynamic, dynamic>? headers;
  int? statusCode;
  int? responseBodyBytes;
  BaseRequest? baseRequest;
  RequestOptions? dioRequestOptions;
  bool? expanded;
  DateTime? startTime;
  DateTime? endTime;
  Duration? duration;
  String? connectionType;
  SSLDetails? sslDetails;
  bool logEnabled;

  InspectorResult({
    this.baseRequest,
    this.dioRequestOptions,
    this.statusCode,
    this.url,
    this.method,
    this.expanded = false,
    this.reqBody,
    this.resBody,
    this.headers,
    this.reasonPhrase,
    this.responseBodyBytes = 0,
    this.startTime,
    this.endTime,
    this.duration,
    this.connectionType,
    this.sslDetails,
    this.logEnabled = false,
  });
}
