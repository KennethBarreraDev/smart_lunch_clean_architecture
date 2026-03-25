import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';

// ignore: depend_on_referenced_packages
import 'package:vector_graphics/vector_graphics.dart';

class LoginBasePage extends StatelessWidget {
  const LoginBasePage({
    this.shortMargin = false,
    super.key,
    required this.title,
    required this.bodyConsumer,
  });

  final String title;
  final Widget bodyConsumer;
  final bool shortMargin;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.loginBackground),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  AppColors.filter.withValues(alpha: 0.8),
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                  maxHeight: 100,
                ),
                child: SvgPicture(
                  AssetBytesLoader(AppImages.whiteLogo),
                  semanticsLabel: "App bar",
                ),
              ),
            ),
          ),

  
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 70.h),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: shortMargin ? 0 : 20),
                      Text(
                        title,
                        style: TextStyle(
                          color: const Color(0xffEF5360).withValues(alpha: 0.9),
                          fontSize: 40,
                        ),
                      ),
                      SizedBox(height: shortMargin ? 0 : 20),
                      bodyConsumer,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
