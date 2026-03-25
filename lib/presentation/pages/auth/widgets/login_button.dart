import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.text,
    required this.isEnabled,
    required this.isLoading,
    this.onPressed,
  });

  final String text;
  final bool isEnabled;
  final void Function()? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: // Rectangle 204
      Container(
        width: 225,
        height: 53,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: AppColors.orange,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          ),
          onPressed: () {
            if (isEnabled) {
              onPressed?.call();
            }
          },
          child: !isLoading
              ? Text(
                  text,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20.0,
                    fontFamily: "Comfortaa",
                  ),
                  textAlign: TextAlign.left,
                )
              : SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: AppColors.white),
                ),
        ),
      ),
    );
  }
}
