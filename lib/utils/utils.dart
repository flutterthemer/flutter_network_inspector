import 'dart:convert';

import 'package:flutter/material.dart';

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
