import 'package:flutter/material.dart';

import '../../util.dart';

class Separator extends StatelessWidget {
  const Separator({
    Key? key,
    required this.child,
    this.paddingTop,
    this.paddingBottom,
    this.paddingRight,
    this.paddingLeft,
    this.width,
  }) : super(key: key);
  final Widget child;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingRight;
  final double? paddingLeft;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kSecondaryColor,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: paddingTop ?? 8.0,
          left: paddingLeft ?? 9.0,
          right: paddingRight ?? 9.0,
          bottom: paddingBottom ?? 8.0,
        ),
        child: child,
      ),
    );
  }
}

class SeperatorLine extends StatelessWidget {
  const SeperatorLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: Colors.grey,
    );
  }
}
