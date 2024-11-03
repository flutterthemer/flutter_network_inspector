import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_network_inspector/models/ssl_details.dart';

/// Converts a dynamic input into a formatted JSON string.
///
/// This function handles both `String` and `Map` input types.
/// - If the input is a JSON string, it decodes and formats it.
/// - If the input is a `Map`, it directly converts it to a formatted JSON string.
/// - If the input is `null` or an invalid type, it returns an error message.
///
/// Parameters:
/// - `input` (`dynamic`): The JSON string or Map to convert.
///
/// Returns:
/// - `String`: A prettified JSON string or an error message.
String toPrettyJson(dynamic input) {
  Map<dynamic, dynamic>? jsonMap;

  if (input == null) {
    return '{}';
  }

  if (input is String) {
    if (input.isEmpty) {
      return '{}';
    }
    // If input is a JSON string, decode it into a Map
    try {
      jsonMap = json.decode(input);
    } catch (e) {
      return 'Error decoding JSON string: $e';
    }
  } else if (input is Map) {
    // If input is already a Map, use it directly
    jsonMap = input;
  } else {
    return 'Invalid input type: expected String or Map';
  }

  if (jsonMap == null) {
    return '';
  }

  try {
    // Use JsonEncoder with 2-space indentation to make the JSON pretty
    const jsonEncoder = JsonEncoder.withIndent('  ');

    // Convert the Map object into a pretty JSON string
    return jsonEncoder.convert(jsonMap);
  } catch (e) {
    // If there's an error during conversion, return an error message
    return 'Error converting to JSON: $e';
  }
}

/// Formats a `DateTime` object into a string of the format `HH:mm:ss:SSS`.
///
/// If the input is `null`, it returns `"00:00:00"`.
///
/// Parameters:
/// - `dateTime` (`DateTime?`): The date and time to format.
///
/// Returns:
/// - `String`: The formatted time string.
String getFormattedTime(DateTime? dateTime) {
  if (null == dateTime) {
    return '00:00:00';
  }
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}:${dateTime.millisecond}';
}

/// Checks if a given HTTP status code represents a successful response.
///
/// Parameters:
/// - `statusCode` (`int`): The HTTP status code to check.
///
/// Returns:
/// - `bool`: `true` if the status code is 200 or 201, otherwise `false`.
bool isSuccess(int statusCode) => statusCode == 200 || statusCode == 201;

/// Converts bytes to kilobytes (KB).
///
/// Parameters:
/// - `bytes` (`int`): The number of bytes to convert.
///
/// Returns:
/// - `double`: The equivalent size in kilobytes.
double convertBytesToKB(int bytes) => bytes / 1024;

/// Retrieves the current network connection type.
///
/// This function checks for mobile, Wi-Fi, or Ethernet connectivity,
/// and returns a string representing the connection type. If the connection
/// type is unknown, it returns `"Unknown"`.
///
/// Returns:
/// - `Future<String>`: A future that completes with the connection type as a string.
Future<String> getConnectionType() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    return 'Mobile Data';
  }
  if (connectivityResult.contains(ConnectivityResult.wifi)) {
    return 'Wi-Fi';
  }
  if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    return 'Ethernet';
  }
  return 'Unknown';
}

/// Fetches SSL details for a given URL.
///
/// This function uses `HttpClient` to make a connection to the specified `url`,
/// and extracts SSL certificate details (subject and issuer) if available.
///
/// Parameters:
/// - `url` (`Uri`): The URL to retrieve SSL details from.
///
/// Returns:
/// - `Future<SSLDetails?>`: A future that completes with an `SSLDetails` object
/// containing the SSL certificate information or `null` if unavailable.
Future<SSLDetails?> getSSLDetails(Uri url) async {
  var client = HttpClient(context: SecurityContext.defaultContext);
  var request = await client.getUrl(url);
  var response = await request.close();
  final sslDetails = SSLDetails(subject: 'No Data', issuer: 'No Data');
  response.listen((_) {}, onDone: () {
    var certificate = response.certificate;
    if (certificate != null) {
      sslDetails.subject = certificate.subject;
      sslDetails.issuer = certificate.issuer;
    }
  });
  return sslDetails;
}

/// Copies the specified text to the system clipboard.
///
/// Parameters:
/// - `text` (`String`): The text to copy to the clipboard.
///
/// Returns:
/// - `Future<bool>`: A future that completes with `true` if the copy operation
/// succeeded, or `false` if an error occurred.
Future<bool> copyToClipboard(String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    return true;
  } catch (e) {
    return false;
  }
}

/// Displays a snackbar with a custom message in the provided context.
///
/// The snackbar has a floating behavior and a customizable display duration.
///
/// Parameters:
/// - `context` (`BuildContext`): The context in which to display the snackbar.
/// - `message` (`String`): The message to display in the snackbar.
/// - `duration` (`Duration`): The duration for which the snackbar should be displayed.
///   Defaults to 3 seconds.
void showSnackbar(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 3)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
