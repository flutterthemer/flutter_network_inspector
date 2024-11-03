import 'dart:convert';
import 'package:http/http.dart';

/// Converts the body of an `http.StreamedResponse` into a `String`.
///
/// This function reads the response stream from an `http.StreamedResponse`
/// and decodes the bytes into a UTF-8 string. It can be used to convert
/// streamed responses into a format suitable for logging, display, or further
/// processing.
///
/// Example usage:
/// ```dart
/// final response = await client.send(request);
/// final responseBody = await convertBodyToString(response);
/// print(responseBody);
/// ```
///
/// Parameters:
/// - `response` (`StreamedResponse`): The HTTP streamed response containing the response body stream.
///
/// Returns:
/// - `Future<String>`: A future that completes with the response body as a decoded string.
///
/// This function asynchronously waits for the entire response stream to be read into memory,
/// making it suitable for responses of manageable size. It decodes the bytes using UTF-8,
/// which is the most commonly used encoding for HTTP content.
Future<String> convertBodyToString(StreamedResponse response) async {
  final responseBodyBytes = await response.stream.toBytes();
  final responseBodyString = utf8.decode(responseBodyBytes);
  return responseBodyString;
}
