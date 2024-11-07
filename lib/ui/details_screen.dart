import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/models/inspector_result.dart';
import 'package:flutter_network_inspector/ui/expanded_text.dart';
import 'package:flutter_network_inspector/ui/inspector_ui.dart';
import 'package:flutter_network_inspector/utils/utils.dart';

/// A stateless widget that displays detailed information about a network request and response.
///
/// The `DetailsScreen` is part of a network inspector utility, which presents data such as
/// the request duration, status code, URL components, headers, and response body. This screen
/// is useful for debugging network requests, providing a user-friendly interface for viewing
/// network traffic details.
///
/// It expects an `InspectorResult` object to be passed as an argument via the `ModalRoute`.
///
/// Usage:
/// ```dart
/// Navigator.of(context).pushNamed('/details', arguments: inspectorResult);
/// ```
///
/// The `DetailsScreen` supports expandable sections for displaying lengthy content like headers,
/// request and response bodies, and SSL details.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Retrieve the `InspectorResult` object from the navigation arguments
    final data = ModalRoute.of(context)!.settings.arguments as InspectorResult;
    final success = isSuccess(data.statusCode ?? 0);
    final logEnabled = data.logEnabled;

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        title: Text(
          'Details',
          style: TextStyle(
            color: success ? Colors.green.shade400 : Colors.red.shade400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showSnackbar(
                context,
                logEnabled
                    ? 'Logs enabled.\nTo turn off, call client.setEnableLogging(false)'
                    : 'Logs disabled.\nTo turn on, call client.setEnableLogging(true)',
              );
            },
            icon: Icon(
              Icons.history,
              color: logEnabled ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          children: [
            // Display request timing details
            PlainRow(
              title: 'Start time',
              value: getFormattedTime(data.startTime),
            ),
            PlainRow(
              title: 'End time',
              value: getFormattedTime(data.endTime),
            ),
            PlainRow(
              title: 'Duration',
              value: '${data.duration?.inMilliseconds} ms',
            ),

            // Display connection information and status
            PlainRow(
              title: 'Connection type',
              value: '${data.connectionType}',
            ),
            PlainRow(
              title: 'Status Code',
              value: data.statusCode.toString(),
            ),

            // Display URL components
            PlainRow(title: 'Scheme', value: data.url?.scheme),
            PlainRow(title: 'Origin', value: data.url?.origin),
            PlainRow(title: 'Host', value: data.url?.host),
            PlainRow(title: 'Path', value: data.url?.path),

            // Display response data
            PlainRow(
              title: 'Response length',
              value:
                  '${convertBytesToKB(data.responseBodyBytes ?? 0).toStringAsFixed(2)} KB',
            ),

            // Expandable sections for detailed content
            ExpandableText(title: 'Query', content: data.url?.query),
            ExpandableText(
              title: 'Request Data',
              content: toPrettyJson(data.reqBody),
            ),
            ExpandableText(
              title: 'Headers',
              content: toPrettyJson(data.headers),
            ),
            ExpandableText(
              title: 'Response',
              content: data.resBody,
            ),
            ExpandableText(
              title: success ? 'Reason phrase' : 'Error',
              content: data.reasonPhrase,
            ),
            ExpandableText(
              title: 'SSL Details',
              content:
                  'Subject: \n${data.sslDetails?.subject}\nIssuer:\n${data.sslDetails?.issuer}',
            ),
          ],
        ),
      ),
    );
  }
}
