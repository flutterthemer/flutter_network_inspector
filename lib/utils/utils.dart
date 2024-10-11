import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_network_inspector/models/ssl_details.dart';

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

String getFormattedTime(DateTime? dateTime) {
  if (null == dateTime) {
    return '00:00:00';
  }
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}:${dateTime.millisecond}';
}

Future<void> showBottomSheetPanel(
  BuildContext context,
  String title,
  String content,
) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (BuildContext context) {
      return SafeArea(
        top: false,
        left: false,
        right: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                title: Text(title),
                backgroundColor: Colors.transparent,
                leading: const SizedBox.shrink(),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    content,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
  );
}

bool isSuccess(int statusCode) => statusCode == 200 || statusCode == 201;

double convertBytesToKB(int bytes) => bytes / 1024;

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

/// Copies the given [text] to the clipboard.
Future<bool> copyToClipboard(String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    return true;
  } catch (e) {
    return false;
  }
}

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
