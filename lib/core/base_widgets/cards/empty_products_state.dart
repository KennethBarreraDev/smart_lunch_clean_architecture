import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_images.dart';

class EmptyProductsState extends StatelessWidget {
  const EmptyProductsState({super.key, this.message = ''});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.dishIcon, width: 96, height: 96),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Color(0xFF9A9A9A)),
          ),
        ],
      ),
    );
  }
}
