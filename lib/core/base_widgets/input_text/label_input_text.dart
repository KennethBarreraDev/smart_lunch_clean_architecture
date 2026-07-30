import 'package:flutter/material.dart';

Widget LabelTextInput({
  required String label,
  required String initialValue,
  bool readOnly = false,
  bool isNumeric = false,
  void Function(String)? onChanged,
}) {
  final controller = TextEditingController(text: initialValue);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6B6B6B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        onChanged: (value) {
          if (isNumeric) {
            String newValue = value;

            // solo permite un solo punto
            int dotCount = value.split('.').length - 1;
            if (dotCount > 1) {
              int firstDotIndex = value.indexOf('.');
              newValue =
                  value.substring(0, firstDotIndex + 1) +
                  value.substring(firstDotIndex + 1).replaceAll('.', '');
            }

            newValue = newValue.replaceAll(RegExp(r'[^0-9.]'), '');

            if (newValue.startsWith('.') && !newValue.startsWith('0.')) {
              newValue = '0$newValue';
            }

            if (newValue != value) {
              controller.value = TextEditingValue(
                text: newValue,
                selection: TextSelection.collapsed(offset: newValue.length),
              );
              if (onChanged != null) onChanged(newValue);
              return;
            }
          }

          if (onChanged != null) onChanged(value);
        },
        keyboardType: isNumeric
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        style: const TextStyle(color: Color(0xFF4A4A4A), fontSize: 15),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Color(0xFF26BFC0), width: 1.5),
          ),
        ),
      ),
    ],
  );
}
