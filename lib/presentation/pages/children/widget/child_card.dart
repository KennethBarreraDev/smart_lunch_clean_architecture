import 'package:flutter/material.dart';

class ChildCard extends StatelessWidget {
  final String name;
  final String matricula;
  final String id;
  final String? imageUrl;
  final bool isActive;
  final VoidCallback? onTap;

  final Color _colorActivo = Colors.green;
  final Color _colorInactivo = const Color.fromARGB(255, 233, 191, 7);

  const ChildCard({
    super.key,
    required this.name,
    required this.matricula,
    required this.id,
    this.imageUrl,
    this.isActive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // FOTO
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                  ? NetworkImage(imageUrl!)
                  : null,
              child: imageUrl == null || imageUrl!.isEmpty
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),

            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Text(
                        'Matrícula: $matricula',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(width: 20),

                      Text(
                        'ID: $id',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isActive ? _colorActivo : _colorInactivo,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: isActive ? _colorActivo : _colorInactivo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey, size: 32),
          ],
        ),
      ),
    );
  }
}
