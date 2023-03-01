import 'package:flutter/material.dart';

import '../../util.dart';
import 'separator.dart';

class AmountTile extends StatelessWidget {
  final String amount;
  final Color? color;

  final double? width;

  const AmountTile({
    Key? key,
    required this.amount,
    this.color,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Separator(
      paddingTop: 8.0,
      paddingBottom: 8.0,
      paddingLeft: 8.0,
      paddingRight: 8.0,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "GHC $amount",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: color ?? kFontColorBlack,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ],
      ),
    );
  }
}
