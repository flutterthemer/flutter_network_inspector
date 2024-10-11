import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/client/logger.dart';
import 'package:flutter_network_inspector/models/inspector_result.dart';
import 'package:flutter_network_inspector/ui/expanded_text.dart';
import 'package:flutter_network_inspector/ui/inspector_ui.dart';
import 'package:flutter_network_inspector/utils/utils.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as InspectorResult;
    final success = isSuccess(data.statusCode ?? 0);
    final logEnabled = data.logEnabled;
    doLog('logEnabled: $logEnabled');
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
          Icon(
            Icons.history,
            color: logEnabled ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          children: [
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
            PlainRow(
              title: 'Status Code',
              value: data.statusCode.toString(),
            ),
            PlainRow(title: 'Scheme', value: data.url?.scheme),
            PlainRow(title: 'Origin', value: data.url?.origin),
            PlainRow(title: 'Host', value: data.url?.host),
            PlainRow(title: 'Path', value: data.url?.path),
            PlainRow(
              title: 'Response length',
              value:
                  '${convertBytesToKB(data.responseBodyBytes ?? 0).toStringAsFixed(2)} KB',
            ),
            ExpandableText(title: 'Query', content: data.url?.query),
            ExpandableText(
              title: 'Request Data',
              content: toPrettyJson(data.reqBody),
            ),
            ExpandableText(
              title: 'Headers',
              content: toPrettyJson(data.headers),
            ),
            ExpandableText(title: 'Response', content: data.resBody),
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
