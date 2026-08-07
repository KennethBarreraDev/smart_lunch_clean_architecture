import 'package:flutter/material.dart';

class LabelTextInput extends StatefulWidget {
  const LabelTextInput({
    super.key,
    required this.label,
    required this.initialValue,
    this.readOnly = false,
    this.isNumeric = false,
    this.onChanged,
  });

  final String label;
  final String initialValue;
  final bool readOnly;
  final bool isNumeric;
  final void Function(String)? onChanged;

  @override
  State<LabelTextInput> createState() => _LabelTextInputState();
}

class _LabelTextInputState extends State<LabelTextInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    if (widget.isNumeric) {
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
        _controller.value = TextEditingValue(
          text: newValue,
          selection: TextSelection.collapsed(offset: newValue.length),
        );
        widget.onChanged?.call(newValue);
        return;
      }
    }

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Color(0xFF6B6B6B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          readOnly: widget.readOnly,
          onChanged: _handleChanged,
          keyboardType: widget.isNumeric
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
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: Color(0xFF26BFC0),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
