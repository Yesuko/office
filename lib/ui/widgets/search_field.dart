import 'package:flutter/material.dart';

import 'rounded_input_field.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedInputField(
      scale: 0.05,
      hintText: "Search",
      icon: Icons.search,
      iconSize: 20,
      onChanged: onChanged ?? (_) {},
      validator: (String? val) {
        return null;
      },
    );
  }
}
