import 'package:flutter/material.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class PermissionSwitch extends StatelessWidget {
  const PermissionSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final String enabledText = AppLocalizations.of(context)!.allowed_message;
    final String disabledText = AppLocalizations.of(context)!.forbidden_message;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value ? disabledText : enabledText,
          style: TextStyle(
            color: value ? Colors.red : Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 48,
            height: 26,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: value ? const Color(0xFFF14D5D) : const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(50),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
