import 'package:flutter/material.dart';

import '../../util.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({
    Key? key,
    required this.iconData,
    required this.onTap,
    this.paddingRight,
    this.color,
    this.size,
    this.paddingLeft,
  }) : super(key: key);

  final IconData iconData;
  final void Function() onTap;
  final Color? color;
  final double? paddingRight;
  final double? paddingLeft;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: paddingRight ?? 10.0,
        left: paddingLeft ?? 0.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          iconData,
          color: color ?? kPrimaryColor,
          size: size ?? 24,
        ),
      ),
    );
  }
}
