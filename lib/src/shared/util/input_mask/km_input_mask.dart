// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/services.dart';

class KmInputMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 2) {
      newText = newText.substring(0, newText.length - 2) + '.' + newText.substring(newText.length - 2);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.fromPosition(TextPosition(offset: newText.length)),
    );
  }
}