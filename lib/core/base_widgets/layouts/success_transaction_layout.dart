import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_images.dart';

class SuccessLayout extends StatelessWidget {
  final Widget image;
  final Widget titles;
  final Widget content;

  const SuccessLayout({
    super.key,
    required this.image,
    required this.titles,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return TransparentScaffold(
      selectedOption: "Inicio",
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                _header(),
                image,
                titles,
                content,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return CustomAppBar(
      height: 38.h,
      showPageTitle: false,
      showDrawer: false,
      image: AppImages.appBarLongImg,
      titleTopPadding: 0.3,
      secondaryColor: true,
    );
  }
}



class SuccessTitles extends StatelessWidget {
  final String title;
  final String subtitle;

  const SuccessTitles({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.75),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}