import 'package:flutter/material.dart';

import '../../util.dart';
import 'separator.dart';

class EmployeeTile extends StatelessWidget {
  const EmployeeTile({
    Key? key,
    required this.fullName,
    required this.department,
    required this.onTap,
  }) : super(key: key);
  final String fullName;
  final String department;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Separator(
      child: GestureDetector(
        onTap: () => onTap(),
        child: ListTile(
          selectedColor: kPrimaryLightColor,
          leading: const CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Icon(
              Icons.account_circle,
              color: kAccentLightColor,
            ),
          ),
          title: Text(
            fullName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(department),
          trailing: const Icon(
            Icons.today,
            color: kAccentLightColor,
          ),
        ),
      ),
    );
  }
}
