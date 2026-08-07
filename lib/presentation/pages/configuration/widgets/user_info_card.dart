import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_graphics/vector_graphics.dart';
import 'package:flutter_svg/svg.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.name,
    required this.familyName,
    this.imageUrl,
    this.onTap,
  });

  final String name;
  final String familyName;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = (imageUrl ?? "").isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
        child: SizedBox(
          height: 130,
          width: 100.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Transform.flip(
                flipX: true,
                child: SvgPicture(
                  AssetBytesLoader(AppImages.appBarLongImg),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                        image: DecorationImage(
                          fit: hasImage ? BoxFit.cover : BoxFit.contain,
                          image: hasImage
                              ? NetworkImage(imageUrl!)
                              : AssetImage(AppImages.defaultProfileStudentImage)
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa",
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Familia: $familyName",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Comfortaa",
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.white,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
