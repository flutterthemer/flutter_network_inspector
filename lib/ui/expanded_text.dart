import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String title;
  final String? content;
  final int collapsedLines;

  const ExpandableText({
    super.key,
    required this.title,
    required this.content,
    this.collapsedLines = 2,
  });

  @override
  State createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleExpanded,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
            ],
          ),
        ),
        if (_isExpanded)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: (widget.content == null || widget.content!.isEmpty)
                ? const Text('No Data to show')
                : Text(widget.content ?? 'No Data to show'),
          ),
      ],
    );
  }
}
