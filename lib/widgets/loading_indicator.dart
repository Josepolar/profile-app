import 'package:flutter/cupertino.dart';
import 'package:profile_app/utils/constants.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: size / 2,
      color: color ?? AppColors.primary,
    );
  }
}
