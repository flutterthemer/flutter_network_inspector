import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/net_inspect.dart';
import 'package:flutter_network_inspector/utils/utils.dart';

class InspectorUI extends StatelessWidget {
  const InspectorUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text('Activity'),
      ),
      body: ValueListenableBuilder(
        valueListenable: FNICLient.inspectorNotifierList,
        builder: (context, inspectorResults, _) {
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(color: Colors.black12),
            itemCount: inspectorResults.length,
            itemBuilder: (context, index) {
              final data = inspectorResults[index];
              final success = isSuccess(data.statusCode ?? 0);
              return ListTile(
                dense: true,
                enableFeedback: true,
                onTap: () {
                  Navigator.of(context).pushNamed('/details', arguments: data);
                },
                leading: _LeadingStatusIncdicatorBlock(
                  success: success,
                  method: data.baseRequest?.method ?? ' <null>',
                ),
                trailing: Text(
                  '${data.duration?.inMilliseconds} ms',
                ),
                title: Text(
                  data.url?.host ?? '<null>',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(data.url?.path ?? '<null>')],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PlainRow extends StatelessWidget {
  const PlainRow({
    super.key,
    required this.title,
    required this.value,
    this.copyEnabled = false,
  });

  final String title;
  final String? value;
  final bool copyEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(color: Colors.blue),
        ),
        Expanded(child: Text(value ?? 'null')),
        if (null != value && value!.isNotEmpty)
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () async {
              final copied = await copyToClipboard(value!);
              if (copied && context.mounted) {
                showSnackbar(context, '$title copied');
              }
            },
            icon: const Icon(
              Icons.copy_outlined,
              color: Colors.grey,
            ),
          )
      ],
    );
  }
}

class _LeadingStatusIncdicatorBlock extends StatelessWidget {
  const _LeadingStatusIncdicatorBlock({
    this.success = false,
    this.method = '',
  });

  final bool success;
  final String method;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      width: 60,
      decoration: BoxDecoration(
        color: success ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        method,
        style: const TextStyle(color: Colors.white, fontSize: 10),
        textAlign: TextAlign.center,
      ),
    );
  }
}
