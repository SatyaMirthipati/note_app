import 'package:flutter/services.dart';

class Helper {}

class CapitalizeEachWordFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.split(' ').map(
        (word) {
          if (word.isNotEmpty) {
            return '${word[0].toUpperCase()}${word.substring(1)}';
          } else {
            return '';
          }
        },
      ).join(' '),
      selection: newValue.selection,
    );
  }
}
