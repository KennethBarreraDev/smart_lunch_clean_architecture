import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';

class DrawerOption extends StatelessWidget {
  const DrawerOption({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.route,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final String route;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap?.call();
              }
              context.go(route);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(81)),
                border: Border.all(color: AppColors.white.withValues(alpha: 0.15)),
                color: isSelected
                    ? AppColors.white.withValues(alpha: 0.25)
                    : Colors.transparent,
              ),
              child: Column(
                children: [
                  Icon(icon, size: 40, color: AppColors.white),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                            fontFamily: "Comfortaa",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
