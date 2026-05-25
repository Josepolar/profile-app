import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:profile_app/utils/constants.dart';

void showErrorMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      left: AppSpacing.md,
      right: AppSpacing.md,
      bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      child: Material(
        type: MaterialType.transparency,
        child: _MessageBanner(
          message: message,
          isError: true,
          onDismiss: () => entry.remove(),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 3), () {
    if (entry.mounted) entry.remove();
  });
}

class _MessageBanner extends StatefulWidget {
  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  const _MessageBanner({
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  @override
  State<_MessageBanner> createState() => _MessageBannerState();
}

class _MessageBannerState extends State<_MessageBanner> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: widget.isError ? AppColors.error : AppColors.textPrimary,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          widget.message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
