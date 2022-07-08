import 'package:flutter/services.dart';

class Validation extends TextInputFormatter {
    RegExp _reg = RegExp(r'^(0|[1-9]\d*)(\.)?(\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return ((newValue.text.trim() == "" || _reg.hasMatch(newValue.text)) ? newValue : oldValue);

  }
}