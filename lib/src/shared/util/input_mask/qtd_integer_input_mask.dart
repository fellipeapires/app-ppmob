// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/services.dart';

class QtdIntegerInputMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.fromPosition(TextPosition(offset: newText.length)),
    );
  }
}