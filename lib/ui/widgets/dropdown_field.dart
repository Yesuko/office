import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../util.dart';
import 'text_field_container.dart';

class TypeDropDownField extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final String selectedValue;

  const TypeDropDownField({
    Key? key,
    required this.onChanged,
    required this.selectedValue,
  }) : super(key: key);

  @override
  State<TypeDropDownField> createState() => _TypeDropDownFieldState();
}

class _TypeDropDownFieldState extends State<TypeDropDownField> {
  String selectedValue = "";

  @override
  void initState() {
    super.initState();

    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.swap_horizontal_circle_sharp,
              color: kPrimaryColor,
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
              hint: const Text("Job type"),
              underline: Container(),
              elevation: 0,
              isExpanded: true,
              value: selectedValue,
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value!;
                });
                widget.onChanged(value);
              },
              items: JobTypes.values
                  .map<DropdownMenuItem<String>>((JobTypes value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(toBeginningOfSentenceCase(value.name) ?? ""),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class StageDropDownField extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final String currentState;

  const StageDropDownField({
    Key? key,
    required this.onChanged,
    required this.currentState,
  }) : super(key: key);

  @override
  State<StageDropDownField> createState() => _StageDropDownFieldState();
}

class _StageDropDownFieldState extends State<StageDropDownField> {
  late String selectedValue;
  late bool isPending;

  @override
  void initState() {
    super.initState();

    isPending = widget.currentState == JobState.pending.name;
    if (isPending) {
      selectedValue = PendingJobStages.documentation.name;
    } else {
      selectedValue = DeliveredJobStages.invoiceCreated.name;
    }

    // set initial value for job tile variable jobStage in case onChange
    // function of drop down button is not called
    widget.onChanged(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.trending_flat_sharp,
              color: kPrimaryColor,
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
              hint: const Text("Job Stage"),
              underline: Container(),
              elevation: 0,
              isExpanded: true,
              value: selectedValue,
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value!;
                });
                widget.onChanged(value);
              },
              items: isPending
                  ? PendingJobStages.values
                      .map<DropdownMenuItem<String>>((PendingJobStages value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child:
                            Text(toBeginningOfSentenceCase(value.name) ?? ""),
                      );
                    }).toList()
                  : DeliveredJobStages.values.map<DropdownMenuItem<String>>(
                      (DeliveredJobStages value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child:
                            Text(toBeginningOfSentenceCase(value.name) ?? ""),
                      );
                    }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DepartmentDropDownField extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  const DepartmentDropDownField({
    Key? key,
    this.onChanged,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  State<DepartmentDropDownField> createState() =>
      _DepartmentDropDownFieldState();
}

class _DepartmentDropDownFieldState extends State<DepartmentDropDownField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.business_sharp,
              color: kPrimaryColor,
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              hint: const Text("Department"),
              validator: widget.validator,
              elevation: 0,
              isExpanded: true,
              value: selectedValue,
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
              ),
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value!;
                });
                widget.onChanged!(value);
              },
              onSaved: widget.onSaved,
              items: Departments.values
                  .map<DropdownMenuItem<String>>((Departments value) {
                return DropdownMenuItem<String>(
                  value: toBeginningOfSentenceCase(value.name),
                  child: Text(toBeginningOfSentenceCase(value.name) ?? ""),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
