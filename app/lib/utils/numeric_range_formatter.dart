import 'package:flutter/services.dart';

/// Formatters to allow only certain ranges in TextInput. Inspired by https://www.woolha.com/tutorials/flutter-set-min-max-value-for-textfield-textformfield#google_vignette

class NumericRangeFormatter extends TextInputFormatter {

    final double min;
    final double max;

    NumericRangeFormatter({required this.min, required this.max});

    @override
    TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
    ) {
      if (newValue.text.isEmpty) {
        return newValue;
      }

      final newValueNumber = double.tryParse(newValue.text);

      if (newValueNumber == null) {
        return oldValue;
      }

      if (newValueNumber < min) {
        return newValue.copyWith(text: min.toString());
      } else if (newValueNumber > max) {
        return newValue.copyWith(text: max.toString());
      } else {
        return newValue;
      }
    }
  }

  class IntegerRangeFormatter extends TextInputFormatter {

    final int min;
    final int max;

    IntegerRangeFormatter({required this.min, required this.max});

    @override
    TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
    ) {
      if (newValue.text.isEmpty) {
        return newValue;
      }

      final newValueNumber = int.tryParse(newValue.text);

      if (newValueNumber == null) {
        return oldValue;
      }

      if (newValueNumber < min) {
        return newValue.copyWith(text: min.toString());
      } else if (newValueNumber > max) {
        return newValue.copyWith(text: max.toString());
      } else {
        return newValue;
      }
    }
  }