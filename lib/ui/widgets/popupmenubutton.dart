import 'package:flutter/material.dart';

class PopUpMenuButtonLayout extends StatelessWidget {
  final Function(dynamic)? onPopMenuItemSelected;
  final List<PopupMenuItem> popMenuItems;
  final double? iconSize;
  final Color? iconColor;
  final IconData? iconData;

  const PopUpMenuButtonLayout({
    Key? key,
    this.onPopMenuItemSelected,
    required this.popMenuItems,
    this.iconSize = 22,
    this.iconColor,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PopupMenuButton(
        itemBuilder: (context) => popMenuItems,
        onSelected: onPopMenuItemSelected,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        position: PopupMenuPosition.under,
        child: SizedBox(
          height: 14,
          child: Icon(
            iconData ?? Icons.more_horiz,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
