import 'package:flutter/material.dart';

class MenuGridView extends StatelessWidget {
  const MenuGridView({
    Key? key,
    required this.children,
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 26,
    this.crossAxisSpacing = 12,
    this.itemHeight = 100,
    this.childAspectRatio,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 27,
    ),
  }) : super(key: key);

  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double itemHeight;
  final double? childAspectRatio;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = itemHeight;
    final spaceUnusedToRender = padding.left +
        padding.right +
        crossAxisSpacing * (crossAxisCount - 1); // include padding, spacing
    final double _itemWidth =
        (_size.width - spaceUnusedToRender) / crossAxisCount;
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio ?? _itemWidth / _itemHeight,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      children: children,
    );
  }
}
