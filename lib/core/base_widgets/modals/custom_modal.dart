import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  const CustomModal({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.onButtonPressed,
    this.buttonColor = const Color(0xFFDCEBE5),
    this.buttonTextColor = const Color(0xFF1BAA66),
  });

  final String title;
  final Widget content;

  final String buttonText;
  final VoidCallback? onButtonPressed;

  final Color buttonColor;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    content,
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Material(
                  color: buttonColor,
                  child: InkWell(
                    onTap: onButtonPressed,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            color: buttonTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
