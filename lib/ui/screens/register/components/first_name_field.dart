import 'package:flutter/material.dart';

import '../../../../databases/services/textformat_service.dart';
import '../../../widgets/rounded_input_field.dart';

class FirstNameField extends StatefulWidget {
  final TextEditingController otherController;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const FirstNameField({
    Key? key,
    required this.otherController,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  State<FirstNameField> createState() => _FirstNameFieldState();
}

class _FirstNameFieldState extends State<FirstNameField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      widget.otherController.text =
          '${_controller.text.toLowerCase()}@2pwaves.com';
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoundedInputField(
      hintText: 'First Name',
      focusNode: _focusNode,
      controller: _controller,
      validator: widget.validator,
      onSaved: widget.onSaved,
      inputFormatters: [UpperCaseBeginningTextFormatter()],
    );
  }
}
