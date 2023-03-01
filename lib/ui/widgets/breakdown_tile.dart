import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../util.dart';
import 'separator.dart';

class BreakdownTile extends StatelessWidget {
  final String title;
  final String amount;
  final bool showInfo;
  final bool enabled;
  final String state;
  final String? settleTime;
  final Function(BuildContext)? onDelete;
  final Function(BuildContext)? onSettle;
  final Function()? onTap;

  final Function()? onInfoPressed;

  const BreakdownTile({
    Key? key,
    required this.state,
    required this.title,
    required this.amount,
    this.settleTime,
    required this.onDelete,
    required this.onSettle,
    required this.onTap,
    required this.enabled,
    this.onInfoPressed,
    this.showInfo = false,
  }) : super(key: key);

  const BreakdownTile.settled({
    Key? key,
    required this.state,
    required this.title,
    required this.amount,
    required this.settleTime,
    this.onInfoPressed,
    this.showInfo = false,
    this.onDelete,
    this.onSettle,
    this.onTap,
  })  : enabled = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Slidable(
        enabled: enabled,
        startActionPane: ActionPane(
          // this widget used to control how the pane animates.
          motion: const DrawerMotion(),

          // All actions are defined in the children parameter.
          children: [
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete_forever_sharp,
              label: "Delete",
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: onSettle,
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              icon: Icons.done_sharp,
              label: "Settle",
            ),
          ],
        ),
        child: Separator(
          paddingBottom: 8.0,
          paddingLeft: 9.0,
          paddingRight: 9.0,
          paddingTop: 8.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: state == BreakdownState.settled.name,
                    child: Text(
                      "settled on $settleTime",
                      style: const TextStyle(
                        color: kFontColorGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showInfo,
                    child: GestureDetector(
                      onTap: onInfoPressed,
                      child: const SizedBox(
                        height: 14,
                        child: Icon(
                          Icons.info_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  top: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title),
                    Text('GHC $amount'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
