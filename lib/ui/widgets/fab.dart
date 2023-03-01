import 'package:flutter/material.dart';

import '../../util.dart';

class Fab {
  static buildWithIcon({
    required IconData icon,
    required Function() onPressed,
  }) {
    return FloatingActionButton(
      backgroundColor: kPrimaryColor,
      onPressed: onPressed,
      heroTag: null,
      child: IconButton(
        icon: Icon(icon),
        onPressed: () => onPressed(),
      ),
    );
  }

  static buildExtended({
    required String label,
    required Function() onPressed,
  }) {
    return FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        icon:const  Icon(Icons.add),

        onPressed: onPressed,
        label: Text(label));
  }
}
