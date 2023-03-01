import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util.dart';
import 'text_field_container.dart';

class DateDropDownField extends StatefulWidget {
  final ValueChanged<String> dateChanged;
  final String hintText;
  final String initialDate;

  const DateDropDownField({
    Key? key,
    required this.dateChanged,
    required this.hintText,
    required this.initialDate,
  }) : super(key: key);

  @override
  State<DateDropDownField> createState() => _DateDropDownFieldState();
}

class _DateDropDownFieldState extends State<DateDropDownField> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialDate;

    controller.addListener(_getLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // This also removes the _getLatestValue listener.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: false,
              cursorColor: kPrimaryColor,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.event_available_sharp,
                  color: kPrimaryColor,
                ),
                hintText: widget.hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
              onPressed: () => _selectDate(context),
              icon: const Icon(
                Icons.calendar_month_sharp,
                color: kAccentLightColor,
              )),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 366)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text =
            DateFormat(kDateFormat).format(selectedDate).split(' ')[0];
      });
    }
  }

  void _getLatestValue() {
    widget.dateChanged(controller.text);
  }
}
