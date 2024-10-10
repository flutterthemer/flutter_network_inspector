import 'dart:convert';
import 'package:http/http.dart';

Future<String> convertBodyToString(StreamedResponse response) async {
  final responseBodyBytes = await response.stream.toBytes();
  final responseBodyString = utf8.decode(responseBodyBytes);
  return responseBodyString;
}
