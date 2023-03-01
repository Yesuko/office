import 'package:flutter/material.dart';

class DismissibleActionLayout extends StatelessWidget {
  final Color color;
  final AlignmentGeometry alignment;
  final IconData icon;

  const DismissibleActionLayout({
    Key? key,
    required this.color,
    required this.alignment,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}