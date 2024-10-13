import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/net_inspect.dart';
import 'package:flutter_network_inspector/utils/constants.dart';
import 'package:flutter_network_inspector/utils/utils.dart';

class InspectorUI extends StatelessWidget {
  const InspectorUI({
    super.key,
    this.title = 'Activity',
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(title),
      ),
      body: ValueListenableBuilder(
        valueListenable: FNICLient.inspectorNotifierList,
        builder: (context, inspectorResults, _) {
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(
              color: Colors.black12,
              height: 0.3,
              thickness: .5,
            ),
            itemCount: inspectorResults.length,
            itemBuilder: (context, index) {
              final data = inspectorResults[index];
              final success = isSuccess(data.statusCode ?? 0);
              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                isThreeLine: false,
                onTap: () async {
                  Navigator.of(context).pushNamed('/details', arguments: data);
                },
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${data.url?.scheme.toUpperCase()}',
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data.baseRequest?.method ?? noValue,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${data.duration?.inMilliseconds}ms',
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.statusCode.toString(),
                          style: TextStyle(
                            color: success ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                title: Text(
                  '${data.url?.host}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(data.url?.path ?? noValue),
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
