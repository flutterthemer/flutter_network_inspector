import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/net_inspect.dart';
import 'package:flutter_network_inspector/utils/utils.dart';

class InspectorUI extends StatelessWidget {
  const InspectorUI({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FNICLient.inspectorNotifierList,
      builder: (context, inspectorResults, _) {
        return ListView.separated(
          separatorBuilder: (_, __) => const Divider(),
          itemCount: inspectorResults.length,
          itemBuilder: (context, index) {
            final data = inspectorResults[index];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  PlainRow(title: 'Query', value: data.url?.query),
                  PlainRow(title: 'Origin', value: data.url?.origin),
                  PlainRow(title: 'Data', value: data.url?.data.toString()),
                  PlainRow(
                    title: 'Headers',
                    value: 'Method: ${data.baseRequest?.method}',
                    moreDetails: toPrettyJson(data.headers),
                  ),
                  PlainRow(
                    title: 'Response',
                    value: 'tap to see',
                    moreDetails: data.resBody,
                  ),
                  PlainRow(title: 'Reason phrase', value: data.reasonPhrase),
                  PlainRow(
                    title: 'Response length',
                    value: '${data.responseBodyBytes} bytes',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class PlainRow extends StatelessWidget {
  const PlainRow({
    super.key,
    required this.title,
    required this.value,
    this.moreDetails,
  });

  final String title;
  final String? value;
  final String? moreDetails;

  @override
  Widget build(BuildContext context) {
    final hasMoreDetails =
        moreDetails != null && moreDetails!.trim().isNotEmpty;
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text(': '),
        Flexible(child: Text(value ?? 'null')),
        if (hasMoreDetails) ...[
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              if (hasMoreDetails) {
                unawaited(showBottomSheetPanel(context, title, moreDetails!));
              }
            },
            child: const Icon(Icons.info),
          ),
        ],
      ],
    );
  }
}
