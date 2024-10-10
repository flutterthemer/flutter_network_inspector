import 'package:http/http.dart';

class InspectorResult {
  Uri? url;
  String? reqBody;
  String? resBody;
  String? reasonPhrase;
  Map<dynamic, dynamic>? headers;
  int? statusCode;
  int? responseBodyBytes;
  BaseRequest? baseRequest;
  bool? expanded;
  DateTime? startTime;
  DateTime? endTime;
  Duration? duration;

  InspectorResult({
    this.baseRequest,
    this.statusCode,
    this.url,
    this.expanded = false,
    this.reqBody,
    this.resBody,
    this.headers,
    this.reasonPhrase,
    this.responseBodyBytes = 0,
    this.startTime,
    this.endTime,
    this.duration,
  });
}
