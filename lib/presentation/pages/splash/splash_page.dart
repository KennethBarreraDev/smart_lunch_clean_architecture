import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lunch/core/base_widgets/session/session_loader_listener.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  // context.go(AppRoutes.authRoute);

  @override
  Widget build(BuildContext context) {
    return SessionLoaderListener(
      onUnauthenticatedSession: () {
        context.go(AppRoutes.authRoute);
      },
      child: Scaffold(
        body: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.orange, AppColors.coral],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(0, 1),
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                    maxHeight: 100,
                  ),
                  child: SvgPicture(
                    AssetBytesLoader(AppImages.whiteLogo),
                    semanticsLabel: "App bar",
                    // fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                CircularProgressIndicator(color: AppColors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
