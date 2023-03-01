import 'package:flutter/material.dart';

import '../../util.dart';

class LabelFieldTile extends StatelessWidget {
  const LabelFieldTile(
      {required this.label,
      required this.fieldValue,
      required this.isVertical,
      Key? key,
      this.color})
      : super(key: key);

  final String label;
  final String? fieldValue;
  final bool isVertical;
  final Color? color;

  //List<Widget> children

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildChildren(),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildChildren(),
              ),
            ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      Text(
        label,
        style: const TextStyle(
            fontWeight: kFontWeight, color: kFontColorBlack, fontSize: 16),
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        width: 100.0,
      ),
      Expanded(
        child: Text(
          fieldValue ?? "",
          style: TextStyle(
            color: color ?? kFontColorBlack,
            fontSize: 16,
          ),
          textAlign: TextAlign.end,
        ),
      ),
    ];
  }
}
