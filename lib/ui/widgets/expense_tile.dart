import 'package:flutter/material.dart';
import 'package:office/logic/models/expense.dart';

import '../../util.dart';
import 'focused_menu.dart';
import 'popupmenubutton.dart';
import 'separator.dart';

class ExpenseTile extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final List<Author> authors;
  final Function() onTap;
  final String state;

  final Function(dynamic)? onPopMenuItemSelected;
  final List<PopupMenuItem> popMenuItems;
  final List<FocusedMenuItem> focusedMenuItems;

  const ExpenseTile({
    Key? key,
    required this.date,
    required this.onTap,
    required this.title,
    required this.amount,
    required this.authors,
    required this.state,
    required this.popMenuItems,
    required this.focusedMenuItems,
    required this.onPopMenuItemSelected,
  }) : super(key: key);

  const ExpenseTile.withMinimalFunctionality({
    Key? key,
    required this.date,
    required this.onTap,
    required this.title,
    required this.amount,
    required this.authors,
    required this.state,
  })  : popMenuItems = const [
          PopupMenuItem(child: SizedBox()),
        ],
        focusedMenuItems = const [],
        onPopMenuItemSelected = null,
        super(key: key);

  const ExpenseTile.settled({
    Key? key,
    required this.date,
    required this.onTap,
    required this.title,
    required this.amount,
    required this.authors,
    required this.state,
    required this.focusedMenuItems,
  })  : popMenuItems = const [
          PopupMenuItem(child: SizedBox()),
        ],
        onPopMenuItemSelected = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (focusedMenuItems.isNotEmpty) {
      return FocusedMenuHolder(
        menuItems: focusedMenuItems,
        onPressed: onTap,
        menuOffset: 10,
        child: _buildChild(context),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: _buildChild(context),
      );
    }
  }

  Separator _buildChild(BuildContext context) {
    return Separator(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state == ExpenseState.settled.name)
                  Text(
                    '${authors.first.flag} by: ${authors.first.name}',
                    style: const TextStyle(
                      color: kFontColorGrey,
                      fontSize: 12,
                    ),
                  )
                else
                  Text(
                    '${authors.last.flag}: ${authors.last.name}',
                    style: const TextStyle(
                      color: kFontColorGrey,
                      fontSize: 12,
                    ),
                  ),
                Visibility(
                  visible: !(onPopMenuItemSelected == null),
                  child: PopUpMenuButtonLayout(
                    popMenuItems: popMenuItems,
                    onPopMenuItemSelected: onPopMenuItemSelected,
                  ),
                ),
              ]),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              top: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kAccentFontColor,
                  ),
                ),
                Text(
                  'GHC $amount',
                  style: const TextStyle(
                    color: kFontColorBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: kSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
