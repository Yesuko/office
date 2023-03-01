import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util.dart';
import './focused_menu.dart';
import './popupmenubutton.dart';
import './separator.dart';

class JobTile extends StatelessWidget {
  final String blNumber;
  final String description;
  final String? etaDate;
  final String? etdDate;
  final String jobStage;
  final String jobType;
  final Function() onTap;
  final Function(dynamic)? onPopMenuItemSelected;
  final List<PopupMenuItem> popMenuItems;
  final List<FocusedMenuItem> focusedMenuItems;

  const JobTile({
    Key? key,
    required this.onTap,
    required this.popMenuItems,
    required this.focusedMenuItems,
    required this.onPopMenuItemSelected,
    required this.blNumber,
    required this.description,
    this.etaDate,
    this.etdDate,
    required this.jobStage,
    required this.jobType,
  }) : super(key: key);

  const JobTile.withMinimalFunctionality({
    Key? key,
    required this.onTap,
    required this.blNumber,
    required this.description,
    this.etaDate,
    this.etdDate,
    required this.jobStage,
    required this.jobType,
  })  : popMenuItems = const [
          PopupMenuItem(child: SizedBox()),
        ],
        onPopMenuItemSelected = null,
        focusedMenuItems = const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onPopMenuItemSelected != null) {
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
              Text(
                'BL#: $blNumber',
                style: const TextStyle(
                  color: kAccentFontColor,
                  fontWeight: FontWeight.bold,
                  //fontSize: 12,
                ),
              ),
              Visibility(
                visible: onPopMenuItemSelected != null,
                child: PopUpMenuButtonLayout(
                  popMenuItems: popMenuItems,
                  onPopMenuItemSelected: onPopMenuItemSelected,
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
                Text(
                  description,
                  softWrap: true,
                  style: const TextStyle(
                      //fontSize: 12,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    jobType,
                    style: const TextStyle(
                      color: kSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: etaDate != null,
                child: Text(
                  'ETA: $etaDate',
                  style: const TextStyle(
                    color: kSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                toBeginningOfSentenceCase(jobStage) ?? "",
                style: const TextStyle(
                  color: Colors.teal,
                  //fontSize: 12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
