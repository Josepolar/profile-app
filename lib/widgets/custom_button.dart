import 'package:flutter/cupertino.dart';
import 'package:profile_app/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDestructive;
  final bool isSecondary;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDestructive = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;

    if (isDestructive) {
      backgroundColor = AppColors.error.withOpacity( 0.12);
      textColor = AppColors.error;
    } else if (isSecondary) {
      backgroundColor = AppColors.surface;
      textColor = AppColors.primary;
    } else {
      backgroundColor = AppColors.primary;
      textColor = CupertinoColors.white;
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isLoading ? null : onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: isSecondary || isDestructive
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity( 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: isLoading
              ? CupertinoActivityIndicator(
                  color: isSecondary || isDestructive
                      ? AppColors.primary
                      : CupertinoColors.white,
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    letterSpacing: -0.41,
                  ),
                ),
        ),
      ),
    );
  }
}
