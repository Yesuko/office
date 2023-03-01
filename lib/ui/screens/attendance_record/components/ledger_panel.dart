import 'package:flutter/material.dart';
import 'package:office/ui/screens/attendance_record/components/ledger.dart';
import 'package:office/util.dart';

class LedgerPanel extends StatelessWidget {
  const LedgerPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Ledger(
            color: kPresentColor,
            text: 'Present',
          ),
          Ledger(
            color: kAbsentColor,
            text: 'Absent',
          ),
          Ledger(
            color: kDayOffColor,
            text: 'Day Off',
          )
        ],
      ),
    );
  }
}
