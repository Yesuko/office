import 'package:flutter/material.dart';

class PopupMenuItemLayout {
  static PopupMenuItem build({
    required String title,
    required IconData iconData,
    required int position,
    Color? color,
  }) {
    return PopupMenuItem(
      value: position,
      padding: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 8.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: color ?? Colors.black,
            size: 18,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
