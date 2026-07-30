import 'package:flutter/material.dart';

class FrequencySelector extends StatelessWidget {
  const FrequencySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _getValidValue(value),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          DropdownMenuItem(value: 'daily', child: Text('Daily')),
          DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
          DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
        ],
        onChanged: onChanged,
      ),
    );
  }

  String _getValidValue(String value) {
    const validValues = ['daily', 'weekly', 'monthly'];
    return validValues.contains(value) ? value : 'daily';
  }
}
