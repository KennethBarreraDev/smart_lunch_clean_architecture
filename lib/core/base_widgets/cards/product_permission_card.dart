import 'package:flutter/material.dart';
import 'package:smart_lunch/core/base_widgets/switch/permission_switch.dart';

class ProductPermissionCard extends StatelessWidget {
  const ProductPermissionCard({
    super.key,
    required this.image,
    required this.productName,
    required this.category,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final ImageProvider image;
  final String productName;
  final String category;
  final String description;

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Imagen
          ClipOval(
            child: Image(
              image: image,
              width: 78,
              height: 78,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 18),

          /// Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF463C38),
                  ),
                ),

                if (category.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFA66A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF9A9A9A),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          /// Switch
          PermissionSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}