import 'package:flutter/material.dart';

import '../../../../util.dart';

class Ledger extends StatelessWidget {
  const Ledger({Key? key, required this.color, required this.text})
      : super(key: key);
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 20),
      Text(
        text,
        style: const TextStyle(color: kFontColorGrey),
      ),
    ]);
  }
}
