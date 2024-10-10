import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          'Details',
          style: TextStyle(
            color: success ? Colors.green.shade400 : Colors.red.shade400,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
              PlainRow(title: 'Host', value: data.url?.host),
              PlainRow(title: 'Path', value: data.url?.path),
              PlainRow(title: 'Origin', value: data.url?.origin),
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
                  title: 'Reason phrase', content: data.reasonPhrase),
            ],
          ),
        ),
      ),
    );
  }
}
