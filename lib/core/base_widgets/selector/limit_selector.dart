import 'package:flutter/material.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class LimitSelector extends StatelessWidget {
  const LimitSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: _getValidValue(value),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            isExpanded: true,
            items: [
              // Prohibited
              DropdownMenuItem(
                value: 'prohibited',
                child: Text(
                  AppLocalizations.of(context)!.forbidden_message,
                  style: const TextStyle(fontSize: 14),
                ),
              ),

              const DropdownMenuItem(
                value: null,
                enabled: false,
                child: Divider(height: 1, thickness: 1, color: Colors.grey),
              ),

              // Números
              ...List.generate(
                15,
                (index) => DropdownMenuItem(
                  value: '${index + 1}',
                  child: Text('${index + 1}', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  String? _getValidValue(String? value) {
    final validValues = [
      'prohibited',
      ...List.generate(15, (index) => '${index + 1}'),
    ];

    return value != null && validValues.contains(value) ? value : null;
  }
}
