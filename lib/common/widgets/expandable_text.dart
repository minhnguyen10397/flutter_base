import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gold/common/widgets/buttons.dart';

import '../styles.dart';
import 'collapsed_text.dart';

class ExpandableText extends StatelessWidget {
  const ExpandableText({
    Key? key,
    required this.originalText,
    this.maxLines = 1,
  }) : super(key: key);

  final String originalText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    buildCollapsed() {
      return UICollapsedText(
        originalText,
        maxLines: maxLines,
        style: UITextStyle.regular,
      );
    }

    buildExpanded() {
      return Text(
        originalText,
        style: UITextStyle.regular,
      );
    }

    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Builder(
              builder: (context) {
                var controller = ExpandableController.of(context, required: true)!;
                return SplashButton(
                  onTap: controller.toggle,
                  child: Expandable(
                    collapsed: buildCollapsed(),
                    expanded: buildExpanded(),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
