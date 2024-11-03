import 'package:dio/dio.dart';
import 'package:flutter_network_inspector/client/network_inspector_dio_client.dart';
import 'package:flutter_network_inspector/client/network_inspector_http_client.dart';
import 'package:http/http.dart' as http;

var logEnabled = false;

class FNI {
  static init({http.Client? httpClient, Dio? dio}) {
    if (httpClient == null && dio == null) {
      throw ArgumentError(
        'At least one of httpClient or dio must be provided.',
      );
    }
    if (null != httpClient) {
      return FNIHttpCLient(httpClient);
    } else {
      return FNIDioClient(dio).dio;
    }
  }

  /// Toggles logging for the client.
  static setEnableLogging(bool enable) => logEnabled = enable;
}
