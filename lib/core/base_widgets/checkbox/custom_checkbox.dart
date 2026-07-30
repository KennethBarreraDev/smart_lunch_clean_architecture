import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final String text;
  final VoidCallback onTap;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF27C17E);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: green, width: 2),
            ),
            child: value
                ? const Icon(Icons.check_rounded, size: 20, color: green)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }
}
