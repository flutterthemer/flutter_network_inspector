import 'package:flutter/material.dart';
import 'package:flutter_network_inspector/utils/utils.dart';

/// A stateful widget that displays expandable/collapsible text content with a title.
///
/// The `ExpandableText` widget is useful for displaying long pieces of text in a condensed form.
/// It allows the user to expand or collapse the content by tapping on the title or an icon,
/// making it ideal for showing additional details on demand.
///
/// This widget also provides an option to copy the content to the clipboard, accessible through a
/// copy icon button. If the content is null or empty, a placeholder message is shown instead.
///
/// Example usage:
/// ```dart
/// ExpandableText(
///   title: 'Description',
///   content: 'This is a long description that can be expanded or collapsed.',
/// );
/// ```
///
/// Parameters:
/// - `title` (String): The title of the expandable section, shown as a clickable text.
/// - `content` (String?): The text content to display when expanded. Defaults to 'No Data to show' if null or empty.
/// - `collapsedLines` (int): The number of lines to show when the content is collapsed. Default is 2.
///
/// This widget uses an `InkWell` widget to toggle the expansion state and shows an icon that indicates
/// whether the text is currently expanded or collapsed. The copy icon button allows copying the content.
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

  /// Toggles the expanded state of the widget.
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
        // Title row with clickable text and expand/collapse icon
        InkWell(
          onTap: _toggleExpanded,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: _toggleExpanded,
                style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                icon: Icon(
                  _isExpanded
                      ? Icons.expand_less_outlined
                      : Icons.expand_more_outlined,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        // Expands to show content when _isExpanded is true
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
            child: Stack(
              children: [
                // Displays the content or a placeholder message
                (widget.content == null || widget.content!.isEmpty)
                    ? const Text('No Data to show')
                    : Text(widget.content ?? 'No Data to show'),

                // Copy icon button to copy content to the clipboard
                if (null != widget.content && widget.content!.isNotEmpty)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () async {
                        final copied = await copyToClipboard(widget.content!);
                        if (copied && context.mounted) {
                          showSnackbar(context, '${widget.title} copied');
                        }
                      },
                      icon: const Icon(
                        Icons.copy_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  )
              ],
            ),
          ),
      ],
    );
  }
}
